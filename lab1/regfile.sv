module regfile (
   output logic [63:0] ReadData1,
   output logic [63:0] ReadData2,
   input  logic [63:0] WriteData,
   input  logic [4:0]  ReadRegister1,
   input  logic [4:0]  ReadRegister2,
   input  logic [4:0]  WriteRegister,
   input               RegWrite,
   input               clk,
   );

   // 1. Decoder chooses register to write data
   
   // 2. WriteData passes data to the selected register
   
   // 3. Generate a 2D array with 32 registers and 64 bit data for each register
   
   // 4. Instantiate the 64x32_1 mux module twice, passing the ReadRegisters
    
endmodule
