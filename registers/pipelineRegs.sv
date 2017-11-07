module pipelineRegs (
   input  logic        clk, reset,
   //output logic        Reg2Loc,
   output logic        ALUSrc,
   output logic        MemToReg,
   output logic        RegWrite,
   output logic        MemWrite,
   output logic        MemRead,
   output logic        ChooseImm,
   output logic        xferByte,
   output logic        ChooseMovk,
   output logic        ChooseMovz,
   output logic  [2:0] ALUOp
   
   //input  logic        Reg2Loc_0,
   input  logic        ALUSrc_0,
   input  logic        MemToReg_0,
   input  logic        RegWrite_0,
   input  logic        MemWrite_0,
   input  logic        MemRead_0,
   input  logic        ChooseImm_0,
   input  logic        xferByte_0,
   input  logic        ChooseMovk_0,
   input  logic        ChooseMovz_0,
   input  logic  [2:0] ALUOp_0
   );

   // Create intitial control bus to be passed into the IDEX register
   logic [11:0] stage1;
   assign stage1 = {
      //Reg2Loc_0,    //12
      ALUSrc_0      //11
      MemToReg_0,   //10
      RegWrite_0,   // 9
      MemWrite_0,   // 8
      MemRead_0,    // 7
      ChooseImm_0,  // 6
      xferByte_0,   // 5
      ChooseMovk_0, // 4
      ChooseMovz_0, // 3
      ALUOp_0       // 2-0            
   };
   
   // Instruction Decode/Execute Register
   logic [11:0] stage2;
   register #(.WIDTH(12)) IDEX (
      .clk, .reset,
      .dOut(stage2),
      .WriteData(stage1),
      .wrEnable(1'b1),
   );
      
   assign ALUSrc     = stage2[11];
   assign ChooseImm  = stage2[6];
   assign ChooseMovk = stage2[4];
   assign ChooseMovz = stage2[3];
   assign ALUOP      = stage2[2:0];
   
   // Execute/Memory Register
   logic [4:0] stage3, stage2b;
   assign stage2b = {stage2[10:7], stage2[5]};   
   register #(.WIDTH(5)) EXMEM (
      .clk, .reset,
      .dOut(stage3),
      .WriteData(stage2b),
      .wrEnable(1'b1),
   );
   
   assign MemToReg = stage3[10];   
   assign MemWrite = stage3[8];
   assign MemRead  = stage3[7];
   assign xferByte = stage3[5];
   
   // Memory/WriteBack Register
   logic stage4;
   register #(.WIDTH(1)) MEMWB (
      .clk, .reset,
      .dOut(stage4),
      .WriteData(stage3[9]),
      .wrEnable(1'b1),
   );
 
   // Note: Could be more direct and say .dOut(RegWrite) but maybe have to extend it later?
   assign RegWrite = stage4; 
   
endmodule