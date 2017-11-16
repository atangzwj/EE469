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
   
   output logic [63:0] Db_ALU,
   output logic [63:0] Da,
   output logic [63:0] Db,
   output logic [63:0] ALU_out,
   output logic [63:0] Dw,
   output logic  [4:0] Rd,

   input  logic        MemToReg_0,
   input  logic        RegWrite_0,
   input  logic        MemWrite_0,
   input  logic        MemRead_0,
   input  logic        xferByte_0,
   input  logic  [2:0] ALUOp_0,

   input  logic [63:0] Db_ALU_0,
   input  logic [63:0] Da_0,
   input  logic [63:0] Db_0,
   input  logic [63:0] ALU_out_0,
   input  logic [63:0] Dw_0,
   input  logic  [4:0] Rd_0
   );
   
   // Create initial control bus to be passed into the IDEX register
   logic [7:0] stage1;
   assign stage1 = {
      MemToReg_0, // 7 
      RegWrite_0, // 6
      MemWrite_0, // 5
      MemRead_0,  // 4
      xferByte_0, // 3
      ALUOp_0     // 2-0            
   };

   // Instruction Decode/Execute Registers for Data
   logic [63:0] Db_1;
   register Db_ALU_reg_0 (
      .clk,
      .reset,
      .dOut(Db_ALU),
      .WriteData(Db_ALU_0),
      .wrEnable(1'b1)
   );

   register Da_reg_0 (
      .clk,
      .reset,
      .dOut(Da),
      .WriteData(Da_0),
      .wrEnable(1'b1)
   );

   register Db_reg_0 (
      .clk,
      .reset,
      .dOut(Db_1),
      .WriteData(Db_0),
      .wrEnable(1'b1)
   );

   logic [4:0] Rd_1;
   register #(.WIDTH(5)) Rd_IDEX (
      .clk,
      .reset,
      .dOut(Rd_1),
      .WriteData(Rd_0),
      .wrEnable(1'b1)
   );

   // Instruction Decode/Execute Register for Control Signals
   logic [7:0] stage2;
   register #(.WIDTH(8)) IDEX (
      .clk,
      .reset,
      .dOut(stage2),
      .WriteData(stage1),
      .wrEnable(1'b1)
   );
      
   assign ALUOp = stage2[2:0];

   // Execute/Memory Register for Data
   register Db_reg_1 (
      .clk,
      .reset,
      .dOut(Db),
      .WriteData(Db_1),
      .wrEnable(1'b1)
   );

   register ALU_out_reg (
      .clk,
      .reset,
      .dOut(ALU_out),
      .WriteData(ALU_out_0),
      .wrEnable(1'b1)
   );

   logic [4:0] Rd_2;
   register #(.WIDTH(5)) Rd_EXMEM (
      .clk,
      .reset,
      .dOut(Rd_2),
      .WriteData(Rd_1),
      .wr_Enable(1'b1)
   );

   // Execute/Memory Register for Control Signals
   logic [4:0] stage3, stage2b;
   assign stage2b = stage2[7:3];;   
   register #(.WIDTH(5)) EXMEM (
      .clk,
      .reset,
      .dOut(stage3),
      .WriteData(stage2b),
      .wrEnable(1'b1)
   );
   
   assign MemToReg = stage3[4];   
   assign MemWrite = stage3[2];
   assign MemRead  = stage3[1];
   assign xferByte = stage3[0];

   // Memory/Writeback Register for Data
   register Dw_reg (
      .clk,
      .reset,
      .dOut(Dw),
      .WriteData(Dw_0),
      .wrEnable(1'b1)
   );

   register #(.WIDTH(5)) Rd_MEMWR (
      .clk,
      .reset,
      .dOut(Rd),
      .WriteData(Rd_2),
      .wrEnable(1'b1)
   );

   // Memory/WriteBack Register for Control Signals
   logic stage4;
   register #(.WIDTH(1)) MEMWB (
      .clk,
      .reset,
      .dOut(stage4),
      .WriteData(stage3[3]),
      .wrEnable(1'b1)
   );
 
   // Note: Could be more direct and say .dOut(RegWrite) but maybe have to extend it later?
   assign RegWrite = stage4;
endmodule

module pipelineRegs_testbench ();
   logic        clk, reset;
   logic        MemToReg, MemToReg_0,
                RegWrite, RegWrite_0,
                MemWrite, MemWrite_0,
                MemRead,  MemRead_0,
                xferByte, xferByte_0;
   logic  [2:0] ALUOp, ALUOp_0;  
   
   logic [63:0] Db_ALU,  Db_ALU_0,
                Da,      Da_0,
                Db,      Db_0,
                ALU_out, ALU_out_0,
                Dw,      Dw_0;
   logic  [4:0] Rd,      Rd_0;

   pipelineRegs dut (
      .clk,
      .reset,
      .MemToReg,
      .RegWrite,
      .MemWrite,
      .MemRead,
      .xferByte,
      .ALUOp,
   
      .Db_ALU,
      .Da,
      .Db,
      .ALU_out,
      .Dw,
      .Rd,

      .MemToReg_0,
      .RegWrite_0,
      .MemWrite_0,
      .MemRead_0,
      .xferByte_0,
      .ALUOp_0,

      .Db_ALU_0,
      .Da_0,
      .Db_0,
      .ALU_out_0,
      .Dw_0,
      .Rd_0
   );

   logic [7:0] ctrlBus;

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end

   assign MemToReg_0 = ctrlBus[7];
   assign RegWrite_0 = ctrlBus[6];
   assign MemWrite_0 = ctrlBus[5];
   assign MemRead_0  = ctrlBus[4];
   assign xferByte_0 = ctrlBus[3];              
   assign ALUOp_0    = ctrlBus[2:0];

   assign Db_ALU_0  = 64'hFFFF_FFFF_FFFF_FFFF;
   assign Da_0      = 64'hFFFF_FFFF_FFFF_FFFF;
   assign Db_0      = 64'hFFFF_FFFF_FFFF_FFFF;
   assign ALU_out_0 = 64'hFFFF_FFFF_FFFF_FFFF;
   assign Dw_0      = 64'hFFFF_FFFF_FFFF_FFFF;
   assign Rd_0      =  5'b11111;

   integer i;
   initial begin
      reset <= 1'b0; @(posedge clk);
      reset <= 1'b1; @(posedge clk);
      reset <= 1'b0;
      ctrlBus = 8'b1111_1111;

      for (i = 0; i < 10; i++) begin
         @(posedge clk);
      end
      $stop;
   end
endmodule
