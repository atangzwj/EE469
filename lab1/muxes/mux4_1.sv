/*
module mux4_1(
   output logic out, 
   input  logic i11, i10, i01, i00, 
   input  logic sel1, sel0
   );

   logic v0, v1;

   mux2_1 m0(.out(v0),  .i0(i00), .i1(i01), .sel(sel0));
   mux2_1 m1(.out(v1),  .i0(i10), .i1(i11), .sel(sel0));
   mux2_1 m (.out(out), .i0(v0),  .i1(v1),  .sel(sel1));
endmodule
*/

module mux4_1(
   output logic       out, 
   input  logic [3:0] in, 
   input  logic [1:0] sel
   );

   logic v0, v1;

   mux2_1 m0(.out(v0),
               .i0(in[0]),
               .i1(in[1]),
               .sel(sel[0]));
   mux2_1 m1(.out(v1),
               .i0(in[2]),
               .i1(in[3]),
               .sel(sel[0]));
   mux2_1 m (.out(out),
               .i0(v0),
               .i1(v1),
               .sel(sel[1]));
endmodule

module mux4_1_testbench();
   logic [3:0] in;
   logic [1:0] sel;
   logic out;

   mux4_1 dut (.out, .in, .sel);

   integer i;
   initial begin
      for(i=0; i<64; i++) begin
         {sel, in} = i; #10;
      end
   end
endmodule 

