`timescale 1ns/10ps

module datapath (
   input logic       clk, reset,
   input logic [4:0] Rd, Rm, Rn,
   input logic [2:0] ALUOp
   );
   
   logic [63:0] instAddr, instAddrNext;
   logic [31:0] instruction;
   
   // Program Counter
   reg64 pc (.clk,
             .reset,
             .dOut(instAddr),
             .WriteData(instAddrNext),
             .wrEnable(1'b1));
             
   // Instruction Memory
   instructmem im (.clk, .instruction, .address(instAddr));
   
   // Next instruction address: Adds 4 to the instruction memory
   alu addInst_4 (.result(instAddrNext),
                  .negative(),
                  .zero(),
                  .overflow(),
                  .carry_out(),
                  .A(instAddr),
                  .B(64'd4),
                  .cntrl(3'b010));
   
   // Regfile
   logic [63:0] Dw, Da, Db;
   regfile rf (.clk,
               .ReadData1(Da),
               .ReadData2(Db),
               .WriteData(),
               .ReadRegister1(),
               .ReadRegister2(),
               .WriteREgister(),
               .RegWrite()
               );
   
   alu gpr (.result(Dw),
            .negative(),
            .zero(),
            .overflow(),
            .carry_out(),
            .A(Da),
            .B(Db),
            .cntrl(ALUOp));   
   
   
endmodule

module datapath_testbench ();
   logic clk, reset;

   datapath dut (.clk, .reset);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end
   
   integer i;   
   initial begin
   reset <= 1'b1; @(posedge clk);
   reset <= 1'b0; @(posedge clk);
   
   for (i = 0; i < 10; i++) begin
      @(posedge clk);
   end
   
   $stop;
   
   end
endmodule