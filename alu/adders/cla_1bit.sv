`timescale 1ns/10ps

module cla_1bit (
   output logic s, p, g,
   input  logic a, b, c_in
   ); 
   
   xor pro (p, a, b);
   xor sum (s, p, c_in);
   and gen (g, a, b);

endmodule


// Note: testbench only worked when the #50s
//       were omitted
module cla_1bit_testbench ();
   logic s, p, g;
   logic a, b, c_in;

   cla_1bit dut (.s, .p, .g, .a, .b, .c_in);

   integer i;
   initial begin
      for (i = 0; i < 8; i++) begin
         {c_in, b, a} = i; #10;
      end
   end
endmodule 
