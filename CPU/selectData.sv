`timescale 1ns/10ps

// Used to select one of two buses 
module selectData #(parameter TOP_BIT = 64) (
   output logic [TOP_BIT - 1 : 0] out, 
   input  logic [TOP_BIT - 1 : 0] A,
   input  logic [TOP_BIT - 1 : 0] B,
   input  logic                   sel
   );

   genvar i;
   generate
      for (i = 0; i < TOP_BIT + 1; i++) begin : muxing
         mux2_1 m (
            .out(out[i]),
            .i0(A[i]),
            .i1(B[i]),
            .sel
         );
      end
   endgenerate
endmodule
