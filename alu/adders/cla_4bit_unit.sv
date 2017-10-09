`timescale 1ns/10ps

module cla_4bit_unit (
   output logic       PG, GG,
   output logic [3:1] c_add,
   input  logic [3:0] p, g,
   input  logic       c_in
   ); 
   
   // c1 = g0 + p0c0 (b0 as intermediate value)
   logic b0;
   and(b0, p[0], c_in);
   or (c_add[1], g[0], b0);
   
   // c2 = g1 + p1g0 + p1p0c0 (b1 and b2 as intermediate values)
   logic b1, b2;
   and(b1, p[1], p[0], c_in);
   and(b2, p[1], g[0]);
   or (c_add[2], g[1], b2, b1);
   
   // c3 = g2 + p2g1 + p2p1g0 + p2p1p0c0;
   logic b3, b4, b5;
   and(b3, p[2], p[1], p[0], c_in);
   and(b4, p[2], p[1], g[0]);
   and(b5, p[2], g[1]);
   or (c_add[3], b5, b4, b3);
   
   // -- GROUP SIGNALS --//
   // -- for the p and g produced by the 4bit adder into higher level cla -- //
   // PG = p0p1p2p3
   and(PG, p[0], p[1], p[2], p[3]);
   
   // GG = g3 + g2p3 + g1p3p2 + g0p3p2p1
   logic b6, b7, b8;
   and(b6, g[0], p[3], p[2], p[1]);
   and(b7, g[1], p[3], p[2]);
   and(b8, g[2], p[3]);
   or (GG, g[3], b8, b7, b6);

endmodule


// Note: testbench only worked when the #50s
//       were omitted
module cla_4bit_unit_testbench ();
   logic       PG, GG;
   logic [3:1] c_add;
   logic [3:0] p, g;
   logic       c_in;

   cla_4bit_unit dut (.PG, .GG, .c_add, .p, .g, .c_in);

   integer i;
   initial begin
      for (i = 0; i < 550; i++) begin
         {c_in, p, g} = i; #10;
      end
   end
endmodule 
