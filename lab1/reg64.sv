module reg64 (
   input  logic        clk,
   output logic [63:0] dOut,
   input  logic [63:0] WriteData,
   input  logic        wrEnable
   );

   logic [63:0] dIn;

   genvar i;
   generate
      for (i = 0; i < 64; i++) begin : regMuxes
         mux2_1 mux (
            .out(dIn[i]),
            .i0(dOut[i]),
            .i1(WriteData[i]),
            .sel(wrEnable)
         );
      end
   endgenerate

   generate
      for (i = 0; i < 64; i++) begin : regFFs
         D_FF dff (.q(dOut[i]), .d(dIn[i]), .reset(1'b0), .clk);
      end
   endgenerate
endmodule

module reg64_testbench ();
   logic        clk;
   logic [63:0] dOut;
   logic [63:0] WriteData;
   logic        wrEnable;

   reg64 dut (.clk, .dOut, .WriteData, .wrEnable);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end

   initial begin
      WriteData <= 64'h0000000000000000; wrEnable <= 1'b0; @(posedge clk);
      WriteData <= 64'h00000000000000FF; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
      WriteData <= 64'h000000000000FF00; wrEnable <= 1'b1; @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
      WriteData <= 64'h0000000000FF0000; wrEnable <= 1'b1  @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
      WriteData <= 64'h00000000FF000000; wrEnable <= 1'b1  @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
      WriteData <= 64'h000000FF00000000; wrEnable <= 1'b1  @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
      WriteData <= 64'h0000FF0000000000; wrEnable <= 1'b1  @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
      WriteData <= 64'h00FF000000000000; wrEnable <= 1'b1  @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
      WriteData <= 64'hFF00000000000000; wrEnable <= 1'b1  @(posedge clk);
                                         wrEnable <= 1'b0; @(posedge clk);
      $stop;
   end
endmodule
