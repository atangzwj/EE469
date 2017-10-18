module programCounter (
   input  logic        clk, reset,
   output logic [63:0] instructAddr,
   input  logic [63:0] nextAddr
   );
   
   reg64 pc (.clk,
             .dOut(instructAddr)
             .WriteData(nextAddr)
             .wrEnable(1'b1));
   
endmodule