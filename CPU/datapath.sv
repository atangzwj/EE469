`timescale 1ns/10ps

module datapath (
   input  logic       clk, reset,
   output logic       zeroFlag,
   // Data fields
   input  logic [4:0] Rd, Rm, Rn,
   input  logic [8:0] Daddr9,
   // Control Logic
   input  logic       Reg2Loc,
   input  logic       ALUSrc,
   input  logic       MemToReg,
   input  logic       RegWrite,
   input  logic       MemWrite,
   input  logic [2:0] ALUOp
   );
   
   // Gate delay
   parameter DELAY = 0.05;
   
   // Selects between Rd and Rm to output to address Ab in regfile
   // If Reg2Loc == 1, instruction was STUR 
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
               .ReadRegister1(Rm),
               .ReadRegister2(Rn),
               .WriteRegister(Rd),
               .RegWrite
               );
   
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
   
   // Sign extends Daddr_9 to a 64bit number
   logic [63:0] Daddr9_SE, Db_ALU;
   assign Daddr9_SE = {55{Daddr9[8]}, Daddr9};
   
   // Selects between Db from regfile and the sign extended Daddr9
   // Output goes into the ALU
   selectData intoAlu (.out(Db_ALU),
                       .A(Db),
                       .B(Daddr9_SE),
                       .sel(ALUSrc));

   // Data Memory
   logic [63:0] Dmem_out;
   not #DELAY n1 (NOTMemWrite, MemWrite);
   datamem dm (.clk,
               .read_data(Dmem_out),
               .address(ALU_out),
               .write_enable(MemWrite),
               .read_enable(NOTMemWrite),
               .write_data(Db),
               .xfer_size(),
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


module datapath_testbench ();
   logic       clk, reset,
   logic       zeroFlag,
   // Data fields
   logic [4:0] Rd, Rm, Rn,
   logic [7:0] Daddr9,
   // Control Logic
   logic       Reg2Loc,
   logic       ALUSrc,
   logic       MemToReg,
   logic       RegWrite,
   logic       MemWrite,
   logic [2:0] ALUOp

   datapath dut (.clk, .reset,
                 .zeroFlag,
                 .Rd, Rm, Rn,
                 .Daddr9,
                 .Reg2Loc,
                 .ALUSrc,
                 .MemToReg,
                 .RegWrite,
                 .MemWrite,
                 .ALUOp);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end
   
   integer i;   
   initial begin
   reset <= 1'b1; @(posedge clk);
   reset <= 1'b0; @(posedge clk);
   // write to all registers
   $display("%t Writing to all registers.", $time);   
   for (i=0; i<31; i=i+1) begin
      RegWrite <= 0;
      Rm <= i - 1;
      Rd <= i;
      in <= i*64'b10;
      @(posedge clk);
      
      RegWrite <= 1;
      @(posedge clk);
   end
   $display("%t Testing ADD X1, X2, X3", $time);
   flag <= 0;
   // ADD X1, X2, X3
   Rm <= 5'd2;
   Rn <= 5'd3;
   Rd <= 5'd1;
   ALUOp <= 3'b010;
   RegWrite <= 1;
   #500;
   
   $stop;
   end
   
   
endmodule