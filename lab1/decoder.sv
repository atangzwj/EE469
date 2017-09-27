module decoder (
   output logic [31:0] regEnable,
   input  logic [4:0]  WriteRegister,
   input  logic        RegWrite
   );

   logic [4:0] writeRegInv;
   generate
      for (i = 0; i < 5; i++) begin : 
   endgenerate
endmodule
