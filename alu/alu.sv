`timescale 1ns/10ps

module alu (
   output logic [63:0] result,
   output logic        negative,
                       zero,
                       overflow,
                       carry_out,
   input  logic [63:0] A, B,
   input  logic  [2:0] cntrl
   );
   
   // Flags:
   // negative: whether the result output is negative if interpreted as 2's comp.
   // zero: whether the result output was a 64-bit zero.
   // overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
   // carry_out: on an add or subtract, whether the computation produced a carry-out.

   // cntrl			Operation						Notes:
   // 000:			result = B						value of overflow and carry_out unimportant
   // 010:			result = A + B
   // 011:			result = A - B
   // 100:			result = bitwise A & B		value of overflow and carry_out unimportant
   // 101:			result = bitwise A | B		value of overflow and carry_out unimportant
   // 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
   
   parameter DELAY = 0.05;
   logic [63:0] andOut, orrOut, xorOut, B_intoTheAdder; 
   genvar i;
   generate
      for (i = 0; i < 64; i++) begin : bitwiseGates
         and #DELAY a1 (andOut[i], A[i], B[i]);
         or  #DELAY o1 (orrOut[i], A[i], B[i]);
         xor #DELAY x1 (xorOut[i], A[i], B[i]);
         
         // For adder/subtractor
         xor #DELAY x2 (B_intoTheAdder[i], B[i], cntrl[0]);
      end
   endgenerate

   logic [63:0] sum;
   
   cla_64bit cla (
      .sum,
      .a(A),
      .b(B_intoTheAdder),
      .c_in(cntrl[0])
   );
endmodule

module alu_testbench ();
   logic [63:0] result;
   logic        negative,
                zero,
                overflow,
                carry_out;
   logic [63:0] A, B;
   logic  [2:0] cntrl;
   
   alu dut(.result, .negative, .zero, .overflow, .carry_out, .A, .B, .cntrl);
   initial begin
      cntrl = 3'b011;
      A = 64'h               0; // DEFAULT case
      B = 64'h               0; #1000;

      A = 64'hFFFFFFFFFFFFFFFF; // OR case 1
      B = 64'h               0; #1000;
      
      A = 64'h               0; // OR case 2    
      B = 64'hFFFFFFFFFFFFFFFF; #1000;

      A = 64'h0101010101010101; // XOR case1
      B = 64'h1010101010101010; #1000;
      
      A = 64'h1010101010101010; // XOR case2
      B = 64'h0101010101010101; #1000;

      A = 64'hFFFFFFFFFFFFFFFF; // AND case
      B = 64'hFFFFFFFFFFFFFFFF; #1000;
      
      A = 64'h00ABC00000000000;
      B = 64'h00ABC00000000000; #1000;   
   
   end
endmodule





