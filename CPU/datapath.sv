`timescale 1ns/10ps

module datapath (
   input logic         clk, reset,
   output logic [31:0] instruction,
   input logic   [4:0] Rd, Rm, Rn,
   // Control Logic
   input logic   [2:0] ALUOp,
   input logic         RegWrite
   );
   
   logic [63:0] instAddr, instAddrNext;
   
   // Program Counter
   reg64 pc (.clk,
             .reset,
             .dOut(instAddr),
             .WriteData(instAddrNext),
             .wrEnable(1'b1));
             
   // Instruction Memory, outputs the instruction
   instructmem im (.clk, .instruction, .address(instAddr));
   
   // Next instruction address: Adds 4 to the instruction memory
   alu addInst_4 (.result(instAddrNext),
                  .negative(),
                  .zero(),
                  .overflow(),
                  .carry_out(),
                  .A(instAddr),
                  .B(64'd4),
                  .cntrl(3'b010));

   // Regfile
   logic [63:0] Dw, Da, Db;
   regfile rf (.clk,
               .ReadData1(Da),
               .ReadData2(Db),
               .WriteData(Dw),
               .ReadRegister1(Rm),
               .ReadRegister2(Rn),
               .WriteRegister(Rd),
               .RegWrite
               );
               
   alu op (.result(Dw),
           .negative(),
           .zero(),
           .overflow(),
           .carry_out(),
           .A(Da),
           .B(Db),
           .cntrl(ALUOp));
endmodule

module datapath_testbench ();
   logic       clk, reset;
   logic [2:0] ALUOp;
   logic       RegWrite;
   logic [4:0] Rd, Rm, Rn;

   datapath dut (.clk, .reset, .instruction, .ALUOp, .RegWrite, .Rd, .Rm, .Rn);

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