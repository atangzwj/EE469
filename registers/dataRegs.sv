`timescale 1ns/10ps

module dataRegs (
   input  logic        clk, reset,

   
   );
   

endmodule

module dataRegs_testbench ();
   logic clk, reset;
   
   dataRegs dut (
      .clk, .reset,

   );
   
   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end
   
   integer i;
   initial begin

   end
endmodule
