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

endmodule