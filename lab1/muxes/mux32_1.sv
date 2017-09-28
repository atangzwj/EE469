module mux32_1(
   output logic        out,
   input  logic        sel4, sel3, sel2, sel1, sel0,
   input  logic [31:0] in
   );

   // Wires
   logic v0, v1, v2, v3;

   mux8_1 m0(.out(v0), 
               .i000(in[0]),  
               .i001(in[1]),
               .i010(in[2]),
               .i011(in[3]),
               .i100(in[4]),
               .i101(in[5]),
               .i110(in[6]),
               .i111(in[7]),  .sel0, .sel1, .sel2);
   mux8_1 m1(.out(v1), 
               .i000(in[8]),  
               .i001(in[9]),
               .i010(in[10]),
               .i011(in[11]),
               .i100(in[12]),
               .i101(in[13]),
               .i110(in[14]),
               .i111(in[15]), .sel0, .sel1, .sel2);
   mux8_1 m2(.out(v2),
               .i000(in[16]),  
               .i001(in[17]),
               .i010(in[18]),
               .i011(in[19]),
               .i100(in[20]),
               .i101(in[21]),
               .i110(in[22]),
               .i111(in[23]), .sel0, .sel1, .sel2);
   mux8_1 m3(.out(v3),
               .i000(in[24]),  
               .i001(in[25]),
               .i010(in[26]),
               .i011(in[27]),
               .i100(in[28]),
               .i101(in[29]),
               .i110(in[30]),
               .i111(in[31]), .sel0, .sel1, .sel2);                 

   mux4_1 m (.out, .i00(v0), .i01(v1), .i10(v2), .i11(v3), .sel0(sel3), .sel1(sel4));

endmodule

module mux32_1_testbench();
   logic        out;
   logic        sel4, sel3, sel2, sel1, sel0;
   logic [31:0] in;

   mux32_1 dut (.out, .sel4, .sel3, .sel2, .sel1, .sel0, .in);

   integer i;
   initial begin
      for(i=0; i<100000; i++) begin
         {sel4, sel3, sel2, sel1, sel0, in} = i; #1;
      end
   end
endmodule 

