`timescale 1ns/10ps

module datapath (
   input  logic        clk, reset,
   output logic  [3:0] flags,
   // Data fields
   input  logic  [4:0] Rd, Rm, Rn,
   input  logic  [8:0] Daddr9,
   input  logic [11:0] Imm12,
   // Control Logic
   input  logic        Reg2Loc,
   input  logic        ALUSrc,
   input  logic        MemToReg,
   input  logic        RegWrite,
   input  logic        MemWrite,
   input  logic        MemRead,
   input  logic        ChooseImm,
   input  logic        xferByte,
   input  logic  [2:0] ALUOp
   );

   // Gate delay
   parameter DELAY = 0.05;

   // Selects between Rd and Rm to output to address Ab in regfile
      logic [4:0] Ab_in;
   selectData #(.WIDTH(5)) intoAb (
      .out(Ab_in),
      .A(Rd),
      .B(Rm),
      .sel(Reg2Loc)
   );  

   // Regfile for holding and writing the values into the 32 Registers
   logic [63:0] Dw, Da, Db;
   regfile rf (
      .clk, // to be inverted in Lab4
      .ReadData1(Da),
      .ReadData2(Db),
      .WriteData(Dw),
      .ReadRegister1(Rn),
      .ReadRegister2(Ab_in),
      .WriteRegister(Rd),
      .RegWrite
   );

   // Sign extends Daddr_9 to a 64bit number
   logic [63:0] Daddr9_SE;
   assign Daddr9_SE = {{55{Daddr9[8]}}, Daddr9};

   // Selects between Db from regfile and the sign extended Daddr9
   // Output goes into the Immediate Constant Mux
   logic [63:0] Db_Imm;
   selectData intoImmMux (
      .out(Db_Imm),
      .A(Db),
      .B(Daddr9_SE),
      .sel(ALUSrc)
   );

   // Zero extends the Immediate Constant Imm12 to a 64bit number
   logic [63:0] Imm12_ZE, Db_ALU;
   assign Imm12_ZE = {52'b0, Imm12};

   // Selects between the output from Db_Imm (which is either Db from regfile
   // or from address offset Daddr9) and the immediate constant
   // Output goes into ALU
   selectData intoALU (
      .out(Db_ALU),
      .A(Db_Imm),
      .B(Imm12_ZE),
      .sel(ChooseImm)
   );   

   // ALU used for arithmetic between the outputs of the regfile
   // or as an address offset from DAddr9 (from STUR or LDUR)
   logic [63:0] ALU_out;
   logic  [3:0] ALU_flags;
   alu op (
      .result(ALU_out),
      .negative(ALU_flags[3]),
      .zero(ALU_flags[2]), // output to be used for cond branch in CPU_64
      .overflow(ALU_flags[1]),
      .carry_out(ALU_flags[0]),
      .A(Da),
      .B(Db_ALU),
      .cntrl(ALUOp)
   );
   
   // Flag Register
   D_FF negFlag      (.q(flags[3]), .d(ALU_flags[3]), .reset, .clk);
   D_FF zeroFlag     (.q(flags[2]), .d(ALU_flags[2]), .reset, .clk);
   D_FF overflowFlag (.q(flags[1]), .d(ALU_flags[1]), .reset, .clk);
   D_FF cOutFlag     (.q(flags[0]), .d(ALU_flags[0]), .reset, .clk);

   // Select if we are loading/storing 1 byte or 8 bytes (LDURB vs LDUR)
      // xfer_size:
      // 4'b1000 = 64bits transferred
      // 4'd0001 =  8bits transferred
   logic [3:0] xfer_size;
   assign xfer_size[2:1] = 2'b0; // set middle two bits to 0
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
   
   // Replaces top 56 bits of datamem's output with zeros
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
      .out(Dw),
      .A(ALU_out),
      .B(fromDataMem),
      .sel(MemToReg)
   );
endmodule
