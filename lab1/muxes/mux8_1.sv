module mux8_1(
   output logic       out, 
   input  logic [7:0] in,
   input  logic [2:0] sel
   );

   logic v0, v1;

   mux4_1 m0(.out(v0),  .in(in[3:0]),     .sel(sel[1:0]));
   mux4_1 m1(.out(v1),  .in(in[7:4]),     .sel(sel[1:0]));
   mux2_1 m (.out(out), .i0(v0), .i1(v1), .sel(sel[2]));
endmodule


module mux8_1_testbench();
   logic [7:0] in;
   logic [2:0] sel;
   logic out;

   mux8_1 dut (.out, .in, .sel);

   integer i;
   initial begin
      for(i=0; i<2048; i++) begin
         {sel, in} = i; #10;
      end
   end
endmodule 


