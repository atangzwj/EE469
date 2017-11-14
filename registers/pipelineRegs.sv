`timescale 1ns/10ps

/*
   MAP:
                  Output of Movz
                  Da
                  Db
                  --------------
                  ALUOp
                  MemWrite
                  Xfer_Byte
                  Mem2Reg
                  RegWrite
                       |
                       |
                       v
      |-----------------------------------|
       Instruction Decode/Execute Register
      |-----------------------------------|
      
                  ALU_Out
                  Db
                  --------------
                  MemWrite
                  Xfer_Byte
                  Mem2Reg
                  RegWrite
                       |
                       |
                       v
      |-----------------------------------|
             Execute/Memory Register
      |-----------------------------------|      

               Output of Datamem
                    RegWrite
                       |
                       |
                       v
      |-----------------------------------|
            Memory/WriteBack Register
      |-----------------------------------|      
*/

module pipelineRegs (
   input  logic        clk, reset,
   output logic        MemToReg,
   output logic        RegWrite,
   output logic        MemWrite,
   output logic        MemRead,
   output logic        xferByte,
   output logic  [2:0] ALUOp,
   
   input  logic        MemToReg_0,
   input  logic        RegWrite_0,
   input  logic        MemWrite_0,
   input  logic        MemRead_0,
   input  logic        xferByte_0,
   input  logic  [2:0] ALUOp_0
   );
   
   // Create initial control bus to be passed into the IDEX register
   logic [7:0] stage1;
   assign stage1 = {
      MemToReg_0,   // 7 
      RegWrite_0,   // 6
      MemWrite_0,   // 5
      MemRead_0,    // 4
      xferByte_0,   // 3
      ALUOp_0       // 2-0            
   };
   
   // Instruction Decode/Execute Register
   logic [7:0] stage2;
   register #(.WIDTH(8)) IDEX (
      .clk, .reset,
      .dOut(stage2),
      .WriteData(stage1),
      .wrEnable(1'b1)
   );
      
   assign ALUOp = stage2[2:0];
   
   // Execute/Memory Register
   logic [4:0] stage3, stage2b;
   assign stage2b = stage2[7:3];;   
   register #(.WIDTH(5)) EXMEM (
      .clk, .reset,
      .dOut(stage3),
      .WriteData(stage2b),
      .wrEnable(1'b1)
   );
   
   assign MemToReg = stage3[4];   
   assign MemWrite = stage3[2];
   assign MemRead  = stage3[1];
   assign xferByte = stage3[0];
   
   // Memory/WriteBack Register
   logic stage4;
   register #(.WIDTH(1)) MEMWB (
      .clk, .reset,
      .dOut(stage4),
      .WriteData(stage3[3]),
      .wrEnable(1'b1)
   );
 
   // Note: Could be more direct and say .dOut(RegWrite) but maybe have to extend it later?
   assign RegWrite = stage4;
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
   
   pipelineRegs dut (
      .clk, .reset,
      .ALUSrc,
      .MemToReg,
      .RegWrite,
      .MemWrite,
      .MemRead,
      .ChooseImm,
      .xferByte,
      .ChooseMovk,
      .ChooseMovz,
      .ALUOp,
   
      .ALUSrc_0,
      .MemToReg_0,
      .RegWrite_0,
      .MemWrite_0,
      .MemRead_0,
      .ChooseImm_0,
      .xferByte_0,
      .ChooseMovk_0,
      .ChooseMovz_0,
      .ALUOp_0
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
      reset <= 1'b0; @(posedge clk);
      reset <= 1'b1; @(posedge clk);
      reset <= 1'b0;
      ctrlBus = 10'b1111111111;
      ALUOp_0 = 3'b001;
      
      for (i = 0; i < 10; i++) begin
         @(posedge clk);
      end
      $stop;
   end
endmodule
