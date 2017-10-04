// Test bench for Register file
`timescale 1ns/10ps

module regfile (
   output logic [63:0] ReadData1,
   output logic [63:0] ReadData2,
   input  logic [63:0] WriteData,
   input  logic [4:0]  ReadRegister1,
   input  logic [4:0]  ReadRegister2,
   input  logic [4:0]  WriteRegister,
   input  logic        RegWrite,
   input  logic        clk
   );

   logic [31:0] regSelect;
   decoder5_32 dec (.d(regSelect), .sel(WriteRegister), .en(RegWrite));

   logic [31:0][63:0] gprConcat;
   assign gprConcat[31][63:0] = 64'b0;
   genvar i;
   generate
      for (i = 0; i < 31; i++) begin : reg64s
         reg64 gpr (
            .clk,
            .dOut(gprConcat[i][63:0]),
            .WriteData,
            .wrEnable(regSelect[i])
         );
      end
   endgenerate

   mux64x32_64 bigMux1 (
      .readData(ReadData1),
      .regs(gprConcat),
      .sel(ReadRegister1)
   );

   mux64x32_64 bigMux2 (
      .readData(ReadData2),
      .regs(gprConcat),
      .sel(ReadRegister2)
   );
endmodule
