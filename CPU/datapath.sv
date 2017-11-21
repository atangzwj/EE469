`timescale 1ns/10ps

module datapath (
   input  logic        clk, reset,
   output logic  [3:0] flags,
   // Data fields
   input  logic  [4:0] Rd_0, Rm, Rn,
   input  logic  [8:0] Daddr9,
   input  logic [11:0] Imm12,
   input  logic  [1:0] Shamt,
   input  logic [15:0] Imm16,
   // Control Logic
   input  logic        Reg2Loc,
   input  logic        ALUSrc,
   input  logic        MemToReg_0,
   input  logic        RegWrite_0,
   input  logic        MemWrite_0,
   input  logic        MemRead_0,
   input  logic        ChooseImm,
   input  logic        xferByte_0,
   input  logic        ChooseMovk,
   input  logic        ChooseMovz,
   input  logic  [2:0] ALUOp_0
   );

   // Gate delay
   parameter DELAY = 0.05;

   // Selects between Rd and Rm to output to address Ab in regfile
      logic [4:0] Ab_in;
   selectData #(.WIDTH(5)) intoAb (
      .out(Ab_in),
      .A(Rd_0),
      .B(Rm),
      .sel(Reg2Loc)
   );  

   // Invert clk to regfile
   logic clk_regfile;
   not (clk_regfile, clk);

   // Regfile for holding and writing the values into the 32 Registers
   logic [63:0] Dw, Dw_0, Da, Da_0, Db, Db_0;
   logic        RegWrite, RegWrite_mem, RegWrite_exe;
   logic  [4:0] Rd, Rd_mem, Rd_exe;
   regfile rf (
      .clk(clk_regfile),
      .ReadData1(Da_0),
      .ReadData2(Db_0),
      .WriteData(Dw),
      .ReadRegister1(Rn),
      .ReadRegister2(Ab_in),
      .WriteRegister(Rd),
      .RegWrite
   );

   logic [63:0] ALU_out_0, Da_Fwd_0, Da_Fwd, Db_Fwd_0, Db_Fwd;
   logic  [1:0] MuxDa_Sel, MuxDb_Sel;
   
   // FORWARD MUX for Da
   // Cases for MuxDa_Sel:
   //    0x = Da_0
   //    0x = Da_0
   //    10 = Dw_0        (value from mem stage)
   //    11 = Alu_out_0   (value from exe stage)   
   selectData Mux_fwd_Da (
      .out(Da_Fwd_0),
      .A(Dw_0),
      .B(ALU_out_0),
      .sel(MuxDa_Sel[0])
   );
   
   selectData Mux_fwd_Da_1 (
      .out(Da_Fwd),
      .A(Da_0),
      .B(Da_Fwd_0),
      .sel(MuxDa_Sel[1])
   );   

   // FORWARD MUX for Db
   // Cases for MuxDb_Sel:
   //    0x = Db_0
   //    0x = Db_0
   //    10 = Dw_0        (value from mem stage)
   //    11 = Alu_out_0   (value from exe stage) 
   selectData Mux_fwd_Db (
      .out(Db_Fwd_0),
      .A(Dw_0),
      .B(ALU_out_0),
      .sel(MuxDb_Sel[0])
   );
   
   selectData Mux_fwd_Db_1 (
      .out(Db_Fwd),
      .A(Db_0),
      .B(Db_Fwd_0),
      .sel(MuxDb_Sel[1])
   );   

   // Instantiate forwarding mux
   forwardingUnit fu (
   .MuxDa_Sel,
   .MuxDb_Sel,
   
   .Rd_mem,       // destination register in exe stage
   .Rd_exe,       // destination register in mem stage
   .Rn,
   .Rmd(Ab_in),
   .RegWrite_mem,
   .RegWrite_exe
   );   
   
   
   // Sign extends Daddr_9 to a 64bit number
   logic [63:0] Daddr9_SE;
   assign Daddr9_SE = {{55{Daddr9[8]}}, Daddr9};

   // Selects between Db from regfile and the sign extended Daddr9
   // Output goes into the Immediate Constant Mux
   logic [63:0] Db_Imm;
   selectData intoImmMux (
      .out(Db_Imm),
      .A(Db_Fwd),
      .B(Daddr9_SE),
      .sel(ALUSrc)
   );

   // Zero extends the Immediate Constant Imm12 to a 64bit number
   logic [63:0] Imm12_ZE, Db_ALU, Db_ALU_0;
   assign Imm12_ZE = {52'b0, Imm12};

   // Selects between the output from Db_Imm (which is either Db from regfile
   // or from address offset Daddr9) and the immediate constant
   // Output goes into the movkMux
   logic [63:0] Db_Movk;   
   selectData intoMovkMux (
      .out(Db_Movk),
      .A(Db_Imm),
      .B(Imm12_ZE),
      .sel(ChooseImm)
   );   

   ////////////////////////
   //MOVK and MOVZ section/
   
   // General concept for MOVK:
   //    1. Set the 16 bit section of Db we want to replace to zeros
   //    2. Shift the Imm16 to the desired bit range, zero out everything else
   //       Aside. (This number is used as the output for Movz)
   //    3. "Or" Db with ShiftedImm16 
   
   // multiplies the Shamt by 16 
   logic  [5:0] distance;
   assign distance = {Shamt, 4'b0};
   
   // shifts our 16 bit of 1s to specified distance
   logic [63:0] clearBar, clear;
   shifter shiftClear (
      .result(clearBar),
      .value(64'hFFFF),
      .direction(1'b0),
      .distance
   );
   
   // Zero extend our input Imm16, send through the shifter to get the 
   // ShiftedImm16 mask
   logic [63:0] Imm16_ZE, ShiftedImm16;   
   assign Imm16_ZE = {48'b0, Imm16};
   shifter shiftImm (
      .result(ShiftedImm16),
      .value(Imm16_ZE),
      .direction(1'b0),
      .distance
   );
 
   // Gate logic for masking Db and replacing the appropriate section
   logic [63:0] cleared, movk_done;
   genvar i;
   generate
      for (i = 0; i < 64; i++) begin : movk_gates
         // invert each bit of clearBar to get our clear mask
         not #DELAY (clear[i], clearBar[i]);
         // set the desired section of Db to 0
         and #DELAY (cleared[i], Db_0[i], clear[i]);
         // replace the 0 section with the ShiftedImm 16
         or  #DELAY (movk_done[i], cleared[i], ShiftedImm16[i]); 
      end
   endgenerate

   // Selects between output from previous Db value and the result from 
   // the MOVK op. Output goes into the Movz Mux
   logic [63:0] Db_Movz;
   selectData intoMovzMux (
      .out(Db_Movz),
      .A(Db_Movk),
      .B(movk_done),
      .sel(ChooseMovk)
   );
   
   // Selects between output from previous Db value and result from MOVZ op.
   // Output goes into the ALU
   selectData intoALU (
      .out(Db_ALU_0),
      .A(Db_Movz),
      .B(ShiftedImm16),
      .sel(ChooseMovz)
   );
      
   // Accelerated Zero Flag Checker (for CBZ)
   alu check_0 (
      .result(),
      .negative(),
      .zero(flags[2]), // output to be used for cond branch in CPU_64
      .overflow(),
      .carry_out(),
      .A(),
      .B(Db_ALU_0),
      .cntrl(3'b000)
   );

   // ALU used for arithmetic between the outputs of the regfile
   // or as an address offset from DAddr9 (from STUR or LDUR)
   logic [63:0] ALU_out;
   logic  [2:0] ALUOp;
   alu op (
      .result(ALU_out_0),
      .negative(flags[3]),
      .zero(), // output to be used for cond branch in CPU_64
      .overflow(flags[1]),
      .carry_out(flags[0]),
      .A(Da),
      .B(Db_ALU),
      .cntrl(ALUOp)
   );

   // Select if we are loading/storing 1 byte or 8 bytes (LDURB vs LDUR)
      // xfer_size:
      // 4'b1000 = 64bits transferred
      // 4'd0001 =  8bits transferred
   logic xferByte;
   logic [3:0] xfer_size;
   assign xfer_size[2:1] = 2'b0; // set middle two bits of xfer_size to 0
   assign xfer_size[0] = xferByte;
   not #DELAY (xfer_size[3], xferByte);
   
   // Data Memory
   logic [63:0] Dmem_out;
   datamem dm (
      .clk,
      .read_data(Dmem_out),
      .address(ALU_out),
      .write_enable(MemWrite),
      .read_enable(MemRead),               
      .write_data(Db),
      .xfer_size
   );
   
   // For LDURB:
   // Replaces top 56 bits of datamem's output with zeros
   // Output is sent to the regfile
   logic [63:0] ReplacedZero_56, fromDataMem;
   assign ReplacedZero_56 = {56'b0, Dmem_out[7:0]};
   selectData chooseZeroReplace (
      .out(fromDataMem),
      .A(Dmem_out),
      .B(ReplacedZero_56),
      .sel(xferByte)
   );
   
   // selects between the output from the ALU and from the data memory
   // writes this selected value into the register
   selectData intoReg (
      .out(Dw_0),
      .A(ALU_out),
      .B(fromDataMem),
      .sel(MemToReg)
   );
   
   // INSTANTIATE PIPELINE_REG HERE
   pipelineRegs plRegs (
      .clk,
      .reset,
      .MemToReg,
      .RegWrite,
      .RegWrite_exe,
      .RegWrite_mem,
      .MemWrite,
      .MemRead,
      .xferByte,
      .ALUOp,

      .Db_ALU,
      .Da,
      .Db,
      .ALU_out,
      .Dw,
      .Rd,
      .Rd_exe,
      .Rd_mem,

      .MemToReg_0,
      .RegWrite_0,
      .MemWrite_0,
      .MemRead_0,
      .xferByte_0,
      .ALUOp_0,

      .Db_ALU_0,
      .Da_Fwd,
      .Db_Fwd,
      .ALU_out_0,
      .Dw_0,
      .Rd_0
   );
   
endmodule
