`timescale 1ns/10ps

module register #(parameter WIDTH = 64) (
   input  logic                 clk, reset,
   output logic [WIDTH - 1 : 0] dOut,
   input  logic [WIDTH - 1 : 0] WriteData,
   input  logic                 wrEnable
   );

   logic [WIDTH - 1 : 0] dIn;

   // Generate muxes that select between new data and old values
   genvar i;
   generate
      for (i = 0; i < WIDTH; i++) begin : regMuxes
         mux2_1 mux (
            .out(dIn[i]),
            .i0(dOut[i]),
            .i1(WriteData[i]),
            .sel(wrEnable)
         );
      end
   endgenerate

   // Generate D_FFs to hold data
   generate
      for (i = 0; i < WIDTH; i++) begin : regFFs
         D_FF dff (.q(dOut[i]), .d(dIn[i]), .reset, .clk);
      end
   endgenerate
endmodule

module register_testbench ();
   logic        clk, reset;
   logic [63:0] dOut;
   logic [63:0] WriteData;
   logic        wrEnable;

   register dut (.clk, .reset, .dOut, .WriteData, .wrEnable);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end

   initial begin
      reset = 1'b0;
      WriteData <= 64'h0000000000000000; wrEnable <= 1'b0; @(posedge clk);
      WriteData <= 64'h00000000000000FF; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
                                                           @(posedge clk);
                                                           @(posedge clk);
                                                           @(posedge clk); 
                                                           @(posedge clk); 
      WriteData <= 64'h000000000000FF00; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
                                                           @(posedge clk); 
                                                           @(posedge clk); 
                                                           @(posedge clk); 
      WriteData <= 64'h0000000000FF0000; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
                                                           @(posedge clk); 
                                                           @(posedge clk); 
      WriteData <= 64'h00000000FF000000; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
                                                           @(posedge clk); 
      WriteData <= 64'h000000FF00000000; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
                                                           @(posedge clk); 
      WriteData <= 64'h0000FF0000000000; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
                                                           @(posedge clk); 
      WriteData <= 64'h00FF000000000000; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
                                                           @(posedge clk); 
      WriteData <= 64'hFF00000000000000; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
                                                           @(posedge clk); 
      $stop;
   end
endmodule
