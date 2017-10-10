`timescale 1ns/10ps

module cla_16bit (
   output logic [15:0] sum,
   output logic        PG, GG,
   input  logic [15:0] a, b,
   input  logic        c_in
   ); 
   
   logic [3:1] c_add;
   logic [3:0] p, g;
   
   // Calc the sum bits from the 4bit adders
   cla_4bit a1 (
      .sum(sum[3:0]),
      .PG(p[0]),
      .GG(g[0]),
      .a(a[3:0]),
      .b(b[3:0]),
      .c_in
   );

   cla_4bit a2 (
      .sum(sum[7:4]),
      .PG(p[1]),
      .GG(g[1]),
      .a(a[7:4]),
      .b(b[7:4]),
      .c_in(c_add[1])
   );

   cla_4bit a3 (
      .sum(sum[11:8]),
      .PG(p[2]),
      .GG(g[2]),
      .a(a[11:8]),
      .b(b[11:8]),
      .c_in(c_add[2])
   );

   cla_4bit a4 (
      .sum(sum[15:12]),
      .PG(p[3]),
      .GG(g[3]),
      .a(a[15:12]),
      .b(b[15:12]),
      .c_in(c_add[3])
   );
   
   // Feed the ps and gs into the lcu to calc carry
   lcu_4bit u1 (.PG, .GG, .c_add, .p, .g, .c_in);

endmodule

// Note: testbench only worked when the #50s
//       were omitted
module cla_16bit_testbench ();
   logic [15:0] sum;
   logic        PG, GG;
   logic [15:0] a, b;
   logic        c_in;

   cla_16bit dut (.sum, .PG, .GG, .a, .b, .c_in);

   integer i;
   initial begin
      c_in = 1'b0;
      a = 16'd128; b = 16'd64; #10;
      for (i = 63; i < 100000; i++) begin
         b = i * 7; #10;
      end    
   end
endmodule
