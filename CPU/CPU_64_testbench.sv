`timescale 1ns/10ps

module CPU_64_testbench ();
   logic clk, reset;
   logic uncondBr, brTaken;
   logic [18:0] condAddr19;
   logic [25:0] brAddr26;

   CPU_64 dut (.clk, .reset, .uncondBr, .brTaken, .condAddr19, .brAddr26);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end

   initial begin

      reset <= 1'b0; @(posedge clk);
      reset <= 1'b1; @(posedge clk);
      reset <= 1'b0; @(posedge clk);

      $display("%t Do not branch", $time);
      brTaken <= 1'b0;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);

      $display("%t Take Unconditional Branch", $time);
      brAddr26 <= 64'd12; condAddr19 <= 64'd24;
      uncondBr <= 1'b1;
      brTaken  <= 1'b1;
      @(posedge clk);

      $display("%t Take Conditional Branch", $time);
      uncondBr <= 1'b0;
      brTaken  <= 1'b1;
      @(posedge clk);
      $stop;
   end
endmodule
