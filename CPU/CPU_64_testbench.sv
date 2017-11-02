`timescale 1ns/10ps

module CPU_64_testbench ();
   logic clk, reset;
   
   CPU_64 dut (.clk, .reset);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end

   initial begin
      reset <= 1'b0; @(posedge clk);
      reset <= 1'b1; @(posedge clk);
      reset <= 1'b0;
      
      integer i;
      for (i = 0; i < 12; i++) begin
         @(posedge clk);
      end
      $stop;
   end
endmodule
