`timescale 1ns/10ps

module dataRegs (
   input  logic        clk, reset,

   
   );
   

endmodule

module pipelineRegs_testbench ();
   logic clk, reset;
   logic ALUSrc,      ALUSrc_0,
         MemToReg,    MemToReg_0,
         RegWrite,    RegWrite_0,
         MemWrite,    MemWrite_0,
         MemRead,     MemRead_0,
         ChooseImm,   ChooseImm_0,
         xferByte,    xferByte_0,
         ChooseMovk,  ChooseMovk_0,
         ChooseMovz,  ChooseMovz_0;
   logic [2:0] ALUOp, ALUOp_0;  
   
   dataRegs dut (
      .clk, .reset,

   );

   logic  [9:0] ctrlBus;
   
   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end

   assign ChooseMovz_0 = ctrlBus[9];
   assign ChooseMovk_0 = ctrlBus[8];
   assign xferByte_0   = ctrlBus[7];              
   assign ChooseImm_0  = ctrlBus[6];
   assign Reg2Loc_0    = ctrlBus[5];
   assign ALUSrc_0     = ctrlBus[4];
   assign MemToReg_0   = ctrlBus[3];
   assign RegWrite_0   = ctrlBus[2];
   assign MemWrite_0   = ctrlBus[1];
   assign MemRead_0    = ctrlBus[0];
   
   integer i;
   initial begin

   end
endmodule
