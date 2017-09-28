module decoder (
   output logic [31:0] regEnable,
   input  logic [4:0]  WriteRegister,
   input  logic        RegWrite
   );

   logic [4:0] wrInv;
   genvar i;
   generate
      for (i = 0; i < 5; i++) begin : WriteRegNots
         not n (wrInv[i], WriteRegister[i]);
      end
   endgenerate

   logic [3:0] enWR;
   and en0 (enWR[0], RegWrite, wrInv[4],         wrInv[3]);
   and en1 (enWR[1], RegWrite, wrInv[4],         WriteRegister[3]);
   and en2 (enWR[2], RegWrite, WriteRegister[4], wrInv[3]);
   and en3 (enWR[3], RegWrite, WriteRegister[4], WriteRegister[3]);

   logic [7:0] wr;
   and wr0 (wr[0], wrInv[2],         wrInv[1],         wrInv[0]);
   and wr1 (wr[1], wrInv[2],         wrInv[1],         WriteRegister[0]);
   and wr2 (wr[2], wrInv[2],         WriteRegister[1], wrInv[0]);
   and wr3 (wr[3], wrInv[2],         WriteRegister[1], WriteRegister[0]);
   and wr4 (wr[4], WriteRegister[2], wrInv[1],         wrInv[0]);
   and wr7 (wr[7], WriteRegister[2], WriteRegister[1], WriteRegister[0]);
   
   genvar j;
   generate
      for (i = 0; i < 4; i++) begin : regEnables1
         for (j = 0; j < 8; j++) begin : regEnables2
            and (regEnable[8 * i + j], enWR[i], wr[j]);
         end
      end
   endgenerate
endmodule

module decoder_testbench();
   logic [31:0] regEnable;
   logic [4:0]  WriteRegister;
   logic        RegWrite;

   decoder dut (.regEnable, .WriteRegister, .RegWrite);

   integer i;
   initial begin
      RegWrite = 1'b0;
      for (i = 0; i < 32; i++) begin
         WriteRegister = i; #10;
      end
      WriteRegister = 0;
      RegWrite = 1'b1;
      for (i = 0; i < 32; i++) begin
         WriteRegister = i; #10;
      end
   end
endmodule
