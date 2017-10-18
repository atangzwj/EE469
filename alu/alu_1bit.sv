`timescale 1ns/10ps

module alu_1bit (
   output logic       result,
   output logic       c_out,
   input  logic       c_in, a, b,
   input  logic [2:0] cntrl
   );

   logic [7:0] toMux;
   
   // cntrl			Operation						Notes:
   // [0] 000:			result = B						value of overflow and carry_out unimportant
   // [2] 010:			result = A + B
   // [3] 011:			result = A - B
   // [4] 100:			result = bitwise A & B		value of overflow and carry_out unimportant
   // [5] 101:			result = bitwise A | B		value of overflow and carry_out unimportant
   // [6] 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant   
   
   parameter DELAY = 0.05;   
   logic notB, b_muxed, sum;
   
   // Generate the inverted pattern of b 
   not #DELAY n1 (notB, b);
   
   // If subtract op, set b_muxed to the invert of B
   // If add op, set b_muxed to B
   // Feed b_muxed into the full adder
   mux2_1 m2 (.out(b_muxed), .i0(b), .i1(notB), .sel(cntrl[0]));
   adder_full af (.sum, .c_out, .a, .b(b_muxed), .c_in);

   // For and, or, and xor bitwise operations
   logic andOut, orrOut, xorOut;
   and  #DELAY a1 (andOut, a, b);
   or   #DELAY o1 (orrOut, a, b);
   xor  #DELAY x1 (xorOut, a, b);
   
   // Store the outputs into the corresponding cntrl pattern in toMux 
   assign toMux[0] = b;
   assign toMux[2] = sum;
   assign toMux[3] = sum;
   assign toMux[4] = andOut;
   assign toMux[5] = orrOut;
   assign toMux[6] = xorOut;
   
   // Select the result from toMux based on the cntrl bit
   mux8_1 m8 (.out(result), .in(toMux), .sel(cntrl));
endmodule

module alu_1bit_testbench ();
   logic       result;
   logic       c_out;
   logic       c_in, a, b;
   logic [2:0] cntrl;

   alu_1bit dut (.result, .c_out, .c_in, .a, .b, .cntrl);

   integer i;
   initial begin
      c_in = 1'b0;
      cntrl = 3'b000;
      for(i=0; i<4; i++) begin
         {b, a} = i; #1000;
      end
      cntrl = 3'b010;
      for(i=0; i<4; i++) begin
         {b, a} = i; #1000;
      end
      cntrl = 3'b011;
      for(i=0; i<4; i++) begin
         {b, a} = i; #1000;
      end
      cntrl = 3'b100;
      for(i=0; i<4; i++) begin
         {b, a} = i; #1000;
      end
      cntrl = 3'b101;
      for(i=0; i<4; i++) begin
         {b, a} = i; #1000;
      end
      cntrl = 3'b110;
      for(i=0; i<4; i++) begin
         {b, a} = i; #1000;
      end      
   end
endmodule 
