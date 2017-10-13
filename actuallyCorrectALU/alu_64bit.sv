`timescale 1ns/10ps

module alu_64bit (
   output logic [63:0] result,
   output logic        negative,
                       zero,
                       overflow,
                       carry_out,
   input  logic [63:0] A, B,
   input  logic  [2:0] cntrl
   );

   parameter DELAY = 0.05;
   logic [64:0] c_Store;
   logic [15:0] norPuts;
   logic  [3:0] andPuts;   
   assign c_Store[0] = cntrl[0];
   genvar i;
   generate
      for (i = 0; i < 64; i++) begin : eachALU
         alu_1bit dut (.result(result[i]),
                       .c_out(c_Store[i + 1]),
                       .c_in(c_Store[i]),
                       .a(A[i]),
                       .b(B[i]),
                       .cntrl);
      end   

      // -- Zero flag generate section -- //
      for (i = 0; i < 16; i++) begin : nor_Result
         nor #DELAY (norPuts[i],
                        result[i * 4],
                        result[i * 4 + 1],
                        result[i * 4 + 2],
                        result[i * 4 + 3]);
      end
      
      for (i = 0; i < 4; i++) begin : and_norPuts
         and #DELAY (andPuts[i],
                        norPuts[i * 4],
                        norPuts[i * 4 + 1],
                        norPuts[i * 4 + 2],
                        norPuts[i * 4 + 3]);
      end
      // --------------------------------- //
   endgenerate
   
   and #DELAY (zero, andPuts[0], andPuts[1], andPuts[2], andPuts[3]);
   assign negative = result[63];
   assign carry_out = c_Store[64];
   xor #DELAY (overflow, c_Store[64], c_Store[63]);
   
   
   
endmodule

module alu_64bit_testbench ();
   logic [63:0] result;
   logic        negative,
                zero,
                overflow,
                carry_out;
   logic [63:0] A, B;
   logic  [2:0] cntrl;
   
   alu_64bit dut(.result, .negative, .zero, .overflow, .carry_out, .A, .B, .cntrl);

   integer i;
   initial begin
   
      // -- B -- //
      cntrl = 3'b000; 
      A = 64'h               0; // Both zero
      B = 64'h               0; #5000;

      A = 64'h            FFFF; // One input zero
      B = 64'h               0; #5000;

      A = 64'h               0; // Other input zero
      B = 64'h            CCCC; #5000;

      A = 64'h               C; // Output negative
      B = 64'h800000000000000F; #5000;

      A = 64'hFFFFFFFFFFFFFFF4; // Carry all the way through
      B = 64'h               C; #5000;

      A = 64'h7FFFFFFFFFFFFFFF; // Carry through to top bit;
      B = 64'h               1; #5000;
   
      // -- A + B -- //      
      cntrl = 3'b010;
      A = -64'd              10;
      B = 64'd               10; #5000;
      
      A = 64'h               0; // Both zero
      B = 64'h               0; #5000;

      A = 64'h            FFFF; // One input zero
      B = 64'h               0; #5000;

      A = 64'h               0; // Other input zero
      B = 64'h            CCCC; #5000;

      A = 64'h               C; // Output negative
      B = 64'h800000000000000F; #5000;

      A = 64'hFFFFFFFFFFFFFFF4; // Carry all the way through
      B = 64'h               C; #5000;

      A = 64'h7FFFFFFFFFFFFFFF; // Carry through to top bit;
      B = 64'h               1; #5000;

      // -- A - B -- //      
      cntrl = 3'b011;



      A = 64'h            4; // One input zero
      B = 64'h             5; #5000;

      A = 64'h               0; // Other input zero
      B = 64'h            CCCC; #5000;

      A = 64'h               C; // Output negative
      B = 64'h800000000000000F; #5000;

      A = 64'hFFFFFFFFFFFFFFF4; // Carry all the way through
      B = 64'h               C; #5000;

      A = 64'h7FFFFFFFFFFFFFFF; // Carry through to top bit;
      B = 64'h               1; #5000;
      
      // -- bitwise A & B -- //      
      cntrl = 3'b100;
      A = 64'h               0; // Both zero
      B = 64'h               0; #5000;

      A = 64'h            FFFF; // One input zero
      B = 64'h               0; #5000;

      A = 64'h               0; // Other input zero
      B = 64'h            CCCC; #5000;

      A = 64'h               C; // Output negative
      B = 64'h800000000000000F; #5000;

      A = 64'hFFFFFFFFFFFFFFF4; // Carry all the way through
      B = 64'h               C; #5000;

      A = 64'h7FFFFFFFFFFFFFFF; // Carry through to top bit;
      B = 64'h               1; #5000;
      
      // -- bitwise A | B -- //      
      cntrl = 3'b101;
      A = 64'h               0; // Both zero
      B = 64'h               0; #5000;

      A = 64'h            FFFF; // One input zero
      B = 64'h               0; #5000;

      A = 64'h               0; // Other input zero
      B = 64'h            CCCC; #5000;

      A = 64'h               C; // Output negative
      B = 64'h800000000000000F; #5000;

      A = 64'hFFFFFFFFFFFFFFF4; // Carry all the way through
      B = 64'h               C; #5000;

      A = 64'h7FFFFFFFFFFFFFFF; // Carry through to top bit;
      B = 64'h               1; #5000;
      
      // -- bitwise A XOR B -- //      
      cntrl = 3'b110;
      A = 64'h               0; // Both zero
      B = 64'h               0; #5000;

      A = 64'h            FFFF; // One input zero
      B = 64'h               0; #5000;

      A = 64'h               0; // Other input zero
      B = 64'h            CCCC; #5000;

      A = 64'h               C; // Output negative
      B = 64'h800000000000000F; #5000;

      A = 64'hFFFFFFFFFFFFFFF4; // Carry all the way through
      B = 64'h               C; #5000;

      A = 64'h7FFFFFFFFFFFFFFF; // Carry through to top bit;
      B = 64'h               1; #5000;     
   end
endmodule 
