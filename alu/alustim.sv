// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

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

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<10; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
      
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);

		/* Our Test Cases */
      A = 64'h7FFFFFFFFFFFFFFF; B = 64'h0000000000000001; // Carry to top bit
      #(delay);
      assert(carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);      
      A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000001; // Carry through
      #(delay);
      assert(carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);      
      A = -64'd4; B = 64'd4; // Sum to 0
      assert(result == 0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
      #(delay);
      A = -64'd4; B = -64'd4;
      #(delay);
      assert(result == -64'd8 && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
      for (i=0; i<10; i++) begin
         A = $random(); B = $random();
         #(delay);
         assert(result == A + B);
      end
      
      $display("%t testing subtraction", $time);
      cntrl = ALU_SUBTRACT;
      A = 64'd0; B = 64'd0;
      #(delay);
      assert(result == 0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
      A = 64'd5; B = 64'd5;
      #(delay);
      assert(result == 0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
      A = 64'd5; B = -64'd5;
      #(delay);
      assert(result == 64'd10 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
      for (i=0; i<10; i++) begin
         A = $random(); B = $random();
         #(delay);
         assert(result == A - B);
      end

      $display("%t testing and", $time);      
      cntrl = ALU_AND;

      A = 64'h               0;
      B = 64'h               0; #5000;
      assert(result == (A & B));

      A = 64'hFFFFFFFFFFFFFFFF;
      B = 64'hFFFFFFFFFFFFFFFF; #5000;
      assert(result == (A & B));

      A = 64'hAAAAAAAAAAAAAAAA;
      B = 64'h5555555555555555; #5000;
      assert(result == (A &B));

      for (i=0; i<10; i++) begin
         A = $random(); B = $random();
         #(delay);
         assert(result == (A & B));
      end
      
      $display("%t testing or", $time);      
      cntrl = ALU_OR;

      A = 64'h               0;
      B = 64'h               0; #5000;
      assert(result == (A | B));

      A = 64'hFFFFFFFFFFFFFFFF;
      B = 64'hFFFFFFFFFFFFFFFF; #5000;
      assert(result == (A | B));

      A = 64'hAAAAAAAAAAAAAAAA;
      B = 64'h5555555555555555; #5000;
      assert(result == (A | B));
      
      for (i=0; i<10; i++) begin
         A = $random(); B = $random();
         #(delay);
         assert(result == (A | B)); 
      end
      
      $display("%t testing xor", $time);      
      cntrl = ALU_XOR;

      A = 64'h               0;
      B = 64'h               0; #5000;
      assert(result == (A ^ B));

      A = 64'hFFFFFFFFFFFFFFFF;
      B = 64'hFFFFFFFFFFFFFFFF; #5000;
      assert(result == (A ^ B));

      A = 64'hAAAAAAAAAAAAAAAA;
      B = 64'h5555555555555555; #5000;
      assert(result == (A ^ B));
      
      for (i=0; i<10; i++) begin
         A = $random(); B = $random();
         #(delay);
         assert(result == (A ^ B));
      end
      $stop;
   end
endmodule
