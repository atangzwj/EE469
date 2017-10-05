module mux16_1 (
   output logic        out, 
   input  logic [15:0] in,
   input  logic [3:0]  sel
   );

   logic v0, v1;

   mux8_1 m0 (.out(v0),  .in(in[7:0]),     .sel(sel[2:0]));
   mux8_1 m1 (.out(v1),  .in(in[15:8]),    .sel(sel[2:0]));
   mux2_1 m  (.out(out), .i0(v0), .i1(v1), .sel(sel[3]));
endmodule


module mux16_1_testbench ();
   logic [15:0] in;
   logic [3:0] sel;
   logic out;

   mux16_1 dut (.out, .in, .sel);

   integer i;
   initial begin
      sel = 4'b0000;
      for(i=0; i<1000; i++) begin
         in = i; #1;
      end
      sel = 4'b0001;
      for(i=1000; i<2000; i++) begin
         in = i; #1;
      end
      sel = 4'b0010;      
      for(i=1000; i<2000; i++) begin
         in = i; #1;
      end
   end
endmodule 
