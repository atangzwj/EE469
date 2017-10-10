`timescale 1ns/10ps

module cla_64bit (
   output logic [63:0] sum,
   output logic        PG, GG,
   input  logic [63:0] a, b,
   input  logic        c_in
   );

   logic [3:1] c_add;
   logic [3:0] p, g;

   cla_16bit a0 (
      .sum(sum[15:0]),
      .PG(p[0]),
      .GG(g[0]),
      .a(a[15:0]),
      .b(b[15:0]),
      .c_in
   );

   cla_16bit a1 (
      .sum(sum[31:16]),
      .PG(p[1]),
      .GG(g[1]),
      .a(a[31:16]),
      .b(b[31:16]),
      .c_in(c_add[1])
   );

   cla_16bit a2 (
      .sum(sum[47:32]),
      .PG(p[2]),
      .GG(g[2]),
      .a(a[47:32]),
      .b(b[47:32]),
      .c_in(c_add[2])
   );

   cla_16bit a3 (
      .sum(sum[63:48]),
      .PG(p[3]),
      .GG(g[3]),
      .a(a[63:48]),
      .b(b[63:48]),
      .c_in(c_add[3])
   );

   lcu_4bit lcu (.PG, .GG, .c_add, .p, .g, .c_in);

endmodule

module cla_64bit_testbench ();
   logic [63:0] sum;
   logic        PG, GG;
   logic [63:0] a, b;
   logic        c_in;

   cla_64bit dut (.sum, .PG, .GG, .a, .b, .c_in);

   initial begin
      c_in = 1'b0;
      a = 64'h00000000000000000000000000000000; // Both zero
      b = 64'h00000000000000000000000000000000; #10;

      a = 64'h0000000000000000000000000000FFFF; // One input zero
      b = 64'h00000000000000000000000000000000; #10;

      a = 64'h00000000000000000000000000000000; // Other input zero
      b = 64'h0000000000000000000000000000CCCC; #10;

      a = 64'h0000000000000000000000000000000C; // Output negative
      b = 64'h8000000000000000000000000000000F; #10;

      a = 64'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4; // Carry all the way through
      b = 64'h0000000000000000000000000000000C; #10;

      a = 64'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // Carry through to top bit;
      b = 64'h00000000000000000000000000000001; #10;
   end
endmodule
