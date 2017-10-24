`timescale 1ns/10ps

module mux64x32_64 (
   output logic [63:0]       readData,
   input  logic [31:0][63:0] regs,
   input  logic [4:0]        sel
   );

   genvar i, j;

   generate
      for (i = 0; i < 64; i++) begin : eachBit
         logic [31:0] storeBits;
         for (j = 0; j < 32; j++) begin : eachReg
            assign storeBits[j] = regs[j][i];
         end
         mux32_1 m (.out(readData[i]), .sel, .in(storeBits));
      end
   endgenerate

endmodule
