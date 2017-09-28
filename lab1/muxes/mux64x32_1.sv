module mux64x32_1(
   output logic [63:0]       readData,
   input  logic [63:0][31:0] regs,
   input  logic [4:0]        sel
   );
   
   genvar i, j;
   
   generate
      for (i = 0; i < 64; i++) begin : eachMux
         logic [31:0] storeBits;
         for (j = 0; j < 32; j++) begin : eachBit
            buf b(storeBits[j], regs[i][j]);
         end
         mux32_1 m(.out(readData[i]),
                     .sel4(sel[4]),
                     .sel3(sel[3]),
                     .sel2(sel[2]),
                     .sel1(sel[1]),
                     .sel0(sel[0]),
                     .in(storeBits));
      end
   endgenerate
   
endmodule