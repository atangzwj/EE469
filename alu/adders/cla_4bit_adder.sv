`timescale 1ns/10ps

module cla_4bit_adder (
   output logic [3:0] sum,
   output logic       PG, GG,
   input  logic [3:0] a, b,
   input  logic       c_in
   ); 
   
   logic [3:0] c_add, p, g;
   assign c_add[0] = c_in;
   
   // calc the sum bits from the 1bit adders
   genvar i;
   generate
      for (i = 0; i < 4; i++) begin : eachBitAdder
         cla_1bit_adder a1(.s(sum[i]),
                           .p(p[i]),
                           .g(g[i]),
                           .a(a[i]),
                           .b(b[i]),
                           .c_in(c_add[i]));
      
      end
   endgenerate
   
   // feed the ps and gs into the cla unit to calc carry
   cla_4bit_unit u1(.PG,
                    .GG,
                    .c_add(c_add[3:1]), // excludes c_in
                    .p,
                    .g,
                    .c_in);

endmodule


// Note: testbench only worked when the #50s
//       were omitted
module cla_4bit_adder_testbench ();
   logic [3:0] sum;
   logic       PG, GG;
   logic [3:0] a, b;
   logic       c_in;

   cla_4bit_adder dut (.sum, .PG, .GG, .a, .b, .c_in);

   integer i;
   initial begin
      c_in = 1'b0;
      for (i = 0; i < 520; i++) begin
         {c_in, a, b} = i; #10;
      end
   end
endmodule 
