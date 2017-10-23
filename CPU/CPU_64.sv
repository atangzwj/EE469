`timescale 1ns/10ps

module CPU_64 (
   input logic clk, reset,
   );
   
   logic [63:0] instrAddr, instrAddrNext;
   logic [31:0] instruction;

   // Program Counter
   reg64 pc (
      .clk,
      .reset,
      .dOut(instrAddr),
      .WriteData(instrAddrNext),
      .wrEnable(1'b1)
   );

   // Instruction Memory
   instructmem iMem (.clk, .instruction, .address(instAddr));

   // 
   alu pcPlus4 (
      .result(instrAddrNext),
      .negative(),
      .zero(),
      .overflow(),
      .carry_out(),
      .A(instrAddr),
      .B(64'd4),
      .cntrl(3'b010)
   );
endmodule

module CPU_64_testbench ();
   logic clk, reset;

   CPU_64 dut (.clk, .reset);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end
   
   integer i;   
   initial begin
   reset <= 1'b1; @(posedge clk);
   reset <= 1'b0; @(posedge clk);
   
   $stop;
   end
endmodule
