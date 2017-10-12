`timescale 1ns/10ps

module adder_half (
   output logic sum, c_out,
   input  logic a, b
   );
   parameter DELAY = 0.05;
   
   xor #DELAY x1 (sum,   a, b);
   and #DELAY a1 (c_out, a, b);

endmodule

// Note: testbench only worked when the #50s
//       were omitted
module adder_half_testbench ();
   logic sum, c_out;
   logic a, b;

   adder_half dut (.sum, .c_out, .a, .b);

   integer i;
   initial begin
      for (i = 0; i < 4; i++) begin
         {b, a} = i; #100;
      end
   end
endmodule 
