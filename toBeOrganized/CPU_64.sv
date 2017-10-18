module CPU_64 (
   input  logic clk, reset,
   output logic [31:0][63:0] displayRegs // ??
   );
   
   logic [63:0] instructAddr, nextAddr;
   logic [31:0] instruction;
   
   // not using it? 
   logic n1, z1, o1, c1;
   
   programCounter pc (.clk, .instructAddr, .nextAddr);
   instructMem im (.clk, .instruction, .address(instructAddr));
   alu addInst_4 (.result(nextAddr),
                  .negative(n1),
                  .zero(z1),
                  .overflow(o1),
                  .carry_out(c1),
                  .A(instructAddr),
                  .B(64'b4),
                  .cntrl(3'b010));
   
endmodule   