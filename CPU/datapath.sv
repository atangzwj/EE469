`timescale 1ns/10ps

module datapath (
   input  logic       clk, reset,
   output logic       zeroFlag,
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
   input  logic        MemRead, // TEMPORARY?   
   input  logic        ChooseImm,   
   input  logic  [2:0] ALUOp
   );
   
   // Gate delay
   parameter DELAY = 0.05;
   
   // Selects between Rd and Rm to output to address Ab in regfile
   // If Reg2Loc == 0, instruction was STUR 
   logic [4:0] Ab_in;
   selectData #(.TOP_BIT(4)) intoAb (
                       .out(Ab_in),
                       .A(Rd),
                       .B(Rm),
                       .sel(Reg2Loc));  
   
   // Regfile for holding and writing the values into the 32 Registers
   logic [63:0] Dw, Da, Db;
   regfile rf (.clk, // to be inverted in Lab4
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
   selectData intoImmMux (.out(Db_Imm),
                          .A(Db),
                          .B(Daddr9_SE),
                          .sel(ALUSrc));
   
   // Zero extends the Immediate Constant Imm12 to a 64bit number
   logic [63:0] Imm12_ZE, Db_ALU;
   assign Imm12_ZE = {52'b0, Imm12};
   
   // Selects between the output from Db_Imm (which is either Db from regfile
   // or from address offset Daddr9), or the immediate constant
   // Output goes into ALU
   selectData intoALU (.out(Db_ALU),
                       .A(Db_Imm),
                       .B(Imm12_ZE),
                       .sel(ChooseImm));   

   // ALU used for arithmetic between the outputs of the regfile
   // or as an address offset from DAddr9 (from STUR or LDUR)
   logic [63:0] ALU_out;    
   alu op (.result(ALU_out),
           .negative(),
           .zero(zeroFlag), // output to be used for cond branch in CPU_64
           .overflow(),
           .carry_out(),
           .A(Da),
           .B(Db_ALU),
           .cntrl(ALUOp));
   

   // Data Memory
   logic [63:0] Dmem_out;
   not #DELAY n1 (NOTMemWrite, MemWrite);
   datamem dm (.clk,
               .read_data(Dmem_out),
               .address(ALU_out),
               .write_enable(MemWrite),
               //.read_enable(NOTMemWrite),
               .read_enable(MemRead),               
               .write_data(Db),
               .xfer_size(4'd8)
               );
   
   // selects between the output from the ALU and from the data memory
   // writes this selected value into the register
   selectData intoReg (.out(Dw),
                       .A(ALU_out),
                       .B(Dmem_out),
                       .sel(MemToReg));
endmodule

// Used to select data for Reg2Loc, ALUSrc, MemToReg muxes 
module selectData #(parameter TOP_BIT = 63) (
   output logic [TOP_BIT:0] out, 
   input  logic [TOP_BIT:0] A,
   input  logic [TOP_BIT:0] B,
   input  logic             sel
   );

   genvar i;
   generate
      for (i = 0; i < TOP_BIT + 1; i++) begin : muxing
         mux2_1 m (.out(out[i]),
                   .i0(A[i]),
                   .i1(B[i]),
                   .sel);
      end
   endgenerate
endmodule