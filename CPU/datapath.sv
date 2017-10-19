`timescale 1ns/10ps

module datapath (
   input  logic clk, reset
   );
   
   logic [63:0] instAddr, instAddrNext;
   logic [31:0] instruction;
   
   // Program Counter, 
   reg64 pc (.clk,
             .reset,
             .dOut(instAddr),
             .WriteData(instAddrNext),
             .wrEnable(1'b1));
   
   instructmem im (.clk, .instruction, .address(instAddr));
   alu addInst_4 (.result(instAddrNext),
                  .negative(),
                  .zero(),
                  .overflow(),
                  .carry_out(),
                  .A(instAddr),
                  .B(64'd4),
                  .cntrl(3'b010));
endmodule

module datapath_testbench ();
   logic clk, reset;

   datapath dut (.clk, .reset);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end
   
   integer i;   
   initial begin
   reset <= 1'b1; @(posedge clk);
   reset <= 1'b0; @(posedge clk);
   
   for (i = 0; i < 10; i++) begin
      @(posedge clk);
   end
   
   $stop;
   
   end
endmodule