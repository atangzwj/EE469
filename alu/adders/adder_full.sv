`timescale 1ns/10ps

module adder_full (
   output logic sum, c_out,
   input  logic a, b, c_in
   );
   
   logic h1Carry, h2Carry, h1Sum;
   
   adder_half h1(.sum(h1Sum),
                 .c_out(h1Carry),
                 .a,
                 .b);
   adder_half h2(.sum,
                 .c_out(h2Carry),
                 .a(h1Sum),
                 .b(c_in));

   or x1(c_out, h1Carry, h2Carry);

endmodule

// Note: testbench only worked when the #50s
//       were omitted
module adder_full_testbench ();
   logic sum, c_out;
   logic a, b, c_in;

   adder_full dut (.sum, .c_out, .a, .b, .c_in);

   integer i;
   initial begin
      for (i = 0; i < 8; i++) begin
         {c_in, b, a} = i; #10;
      end
   end
endmodule 
