`timescale 1ns/10ps

module datapath (
   input  logic clk, reset
   //output logic [31:0][63:0] displayRegs // ??
   //output logic someShit[]
   );
   
   logic [63:0] instructAddr, nextAddr;
   logic [31:0] instruction;
   
   // not using it? 
   logic n1, z1, o1, c1;
   
   // Program Counter, 
   reg64 pc (.clk,
             .reset,
             .dOut(instructAddr),
             .WriteData(nextAddr),
             .wrEnable(1'b1));
   
   instructmem im (.clk, .instruction, .address(instructAddr));
   alu addInst_4 (.result(nextAddr),
                  .negative(n1),
                  .zero(z1),
                  .overflow(o1),
                  .carry_out(c1),
                  .A(instructAddr),
                  .B(64'd4),
                  .cntrl(3'b010));
endmodule

module datapath_testbench ();
   logic        clk, reset;

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