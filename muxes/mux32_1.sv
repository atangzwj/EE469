`timescale 1ns/10ps

module mux32_1 (
   output logic        out, 
   input  logic [31:0] in,
   input  logic [4:0]  sel
   );

   logic v0, v1;

   mux16_1 m0 (.out(v0),  .in(in[15:0]),    .sel(sel[3:0]));
   mux16_1 m1 (.out(v1),  .in(in[31:16]),   .sel(sel[3:0]));
   mux2_1  m  (.out(out), .i0(v0), .i1(v1), .sel(sel[4]));
endmodule

module mux32_1_testbench ();
   logic        out;
   logic [4:0]  sel;
   logic [31:0] in;

   mux32_1 dut (.out, .sel, .in);

   integer i;
   initial begin
      sel = 5'b00000;
      for(i=0; i<1000; i++) begin
         in = i; #1;
      end
      sel = 5'b00001;
      for(i=1000; i<2000; i++) begin
         in = i; #1;
      end
      sel = 5'b00010;      
      for(i=1000; i<2000; i++) begin
         in = i; #1;
      end
   end
endmodule 
