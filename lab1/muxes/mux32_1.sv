module mux32_1(
   output logic       out;
   input  logic [4:0] sel;
   input  logic [31:0] in;
   );

   // Wires
   logic [1:0] mOut;

   mux8_1 m0(.out(mOut[0]), .i0(in[0]), .i1(in[1]), .sel(sel[2:0])); 
   mux8_1 m1(.out(mOut[1]), .i0(in[2]), .i1(in[3]), .sel(sel[2:0])); 
   mux8_1 m2(.out(mOut[1]), .i0(in[2]), .i1(in[3]), .sel(sel[2:0])); 
   mux8_1 m3(.out(mOut[1]), .i0(in[2]), .i1(in[3]), .sel(sel[2:0])); 
   mux4_1 m4(.out(out), .i0(mOut[0]), .i1(mOut[1]), .sel(sel[4:3])); 

endmodule


