`timescale 1ns/10ps

module main_control (
   output logic        Reg2Loc,
   output logic        ALUSrc_0,
   output logic        MemToReg_0,
   output logic        RegWrite_0,
   output logic        MemWrite_0,
   output logic        MemRead_0,
   output logic        ChooseImm_0,
   output logic        xferByte_0,
   output logic        BrTaken,
   output logic        UncondBr,
   output logic        ChooseMovk_0,
   output logic        ChooseMovz_0,
   output logic        storeFlags,
   output logic  [2:0] ALUOp_0,
   input  logic [10:0] opcode,
   input  logic  [3:0] flags, regFlags
   );
   
   // Instruction opcodes
   parameter
   B     = 11'b000_101x_xxxx,
   CBZ   = 11'b101_1010_0xxx,
   B_LT  = 11'b010_1010_0xxx,
   ADDS  = 11'b101_0101_1000,
   SUBS  = 11'b111_0101_1000,
   ADDI  = 11'b100_1000_100x,
   LDUR  = 11'b111_1100_0010,
   LDURB = 11'b001_1100_0010,
   STUR  = 11'b111_1100_0000,
   STURB = 11'b001_1100_0000,
   MOVK  = 11'b111_1001_01xx,
   MOVZ  = 11'b110_1001_01xx;

   always_comb begin
      casex (opcode)
         B:        begin
                      Reg2Loc      = 1'bx;
                      ALUSrc_0     = 1'bx;
                      MemToReg_0   = 1'bx;
                      RegWrite_0   = 1'b0;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'bx;
                      xferByte_0   = 1'bx;
                      BrTaken      = 1'b1;
                      UncondBr     = 1'b1;
                      ChooseMovk_0 = 1'bx;
                      ChooseMovz_0 = 1'bx;
                      storeFlags   = 1'b0;
                      ALUOp_0      = 3'bxxx;
                   end
         CBZ:      begin
                      Reg2Loc      = 1'b0;
                      ALUSrc_0     = 1'b0;
                      MemToReg_0   = 1'bx;
                      RegWrite_0   = 1'b0;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'b0;
                      xferByte_0   = 1'bx;
                      BrTaken      = flags[2]; // zero flag from same clk cycle
                      UncondBr     = 1'b0;
                      ChooseMovk_0 = 1'b0;
                      ChooseMovz_0 = 1'b0;
                      storeFlags   = 1'b0;                    
                      ALUOp_0      = 3'b000;
                   end
         B_LT:     begin
                      Reg2Loc      = 1'bx;
                      ALUSrc_0     = 1'b0;
                      MemToReg_0   = 1'bx;
                      RegWrite_0   = 1'b0;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'bx;
                      xferByte_0   = 1'bx;
                      BrTaken      = regFlags[3] ^ regFlags[1]; // from flag reg
                      UncondBr     = 1'b0;
                      ChooseMovk_0 = 1'bx;
                      ChooseMovz_0 = 1'bx;
                      storeFlags   = 1'b0;                      
                      ALUOp_0      = 3'bxxx;
                   end
         ADDS:     begin
                      Reg2Loc      = 1'b1;
                      ALUSrc_0     = 1'b0;
                      MemToReg_0   = 1'b0;
                      RegWrite_0   = 1'b1;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'b0;
                      xferByte_0   = 1'bx;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'b0;
                      ChooseMovz_0 = 1'b0;
                      storeFlags   = 1'b1;
                      ALUOp_0      = 3'b010;
                   end
         SUBS:     begin
                      Reg2Loc      = 1'b1;
                      ALUSrc_0     = 1'b0;
                      MemToReg_0   = 1'b0;
                      RegWrite_0   = 1'b1;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'b0;
                      xferByte_0   = 1'bx;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'b0;
                      ChooseMovz_0 = 1'b0;
                      storeFlags   = 1'b1;
                      ALUOp_0      = 3'b011;
                   end
         ADDI:     begin
                      Reg2Loc      = 1'bx;
                      ALUSrc_0     = 1'bx;
                      MemToReg_0   = 1'b0;
                      RegWrite_0   = 1'b1;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'b1;
                      xferByte_0   = 1'bx;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'b0;
                      ChooseMovz_0 = 1'b0;
                      storeFlags   = 1'b0;
                      ALUOp_0      = 3'b010;
                   end
         LDUR:     begin
                      Reg2Loc      = 1'bx;
                      ALUSrc_0     = 1'b1;
                      MemToReg_0   = 1'b1;
                      RegWrite_0   = 1'b1;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'b1;
                      ChooseImm_0  = 1'b0;
                      xferByte_0   = 1'b0;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'b0;
                      ChooseMovz_0 = 1'b0;
                      storeFlags   = 1'b0;
                      ALUOp_0      = 3'b010;
                   end
         LDURB:    begin
                      Reg2Loc      = 1'bx;
                      ALUSrc_0     = 1'b1;
                      MemToReg_0   = 1'b1;
                      RegWrite_0   = 1'b1;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'b1;
                      ChooseImm_0  = 1'b0;
                      xferByte_0   = 1'b1;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'b0;
                      ChooseMovz_0 = 1'b0;
                      storeFlags   = 1'b0;
                      ALUOp_0      = 3'b010;
                   end
         STUR:     begin
                      Reg2Loc      = 1'b0;
                      ALUSrc_0     = 1'b1;
                      MemToReg_0   = 1'bx;
                      RegWrite_0   = 1'b0;
                      MemWrite_0   = 1'b1;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'b0;
                      xferByte_0   = 1'b0;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'b0;
                      ChooseMovz_0 = 1'b0;
                      storeFlags   = 1'b0;
                      ALUOp_0      = 3'b010;
                   end
         STURB:    begin
                      Reg2Loc      = 1'b0;
                      ALUSrc_0     = 1'b1;
                      MemToReg_0   = 1'bx;
                      RegWrite_0   = 1'b0;
                      MemWrite_0   = 1'b1;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'b0;
                      xferByte_0   = 1'b1;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'b0;
                      ChooseMovz_0 = 1'b0;
                      storeFlags   = 1'b0;
                      ALUOp_0      = 3'b010;
                   end
         MOVK:     begin
                      Reg2Loc      = 1'b0;
                      ALUSrc_0     = 1'bx;
                      MemToReg_0   = 1'b0;
                      RegWrite_0   = 1'b1;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'bx;
                      xferByte_0   = 1'bx;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'b1;
                      ChooseMovz_0 = 1'b0;
                      storeFlags   = 1'b0;
                      ALUOp_0      = 3'b000;
                   end
         MOVZ:     begin
                      Reg2Loc      = 1'bx;
                      ALUSrc_0     = 1'bx;
                      MemToReg_0   = 1'b0;
                      RegWrite_0   = 1'b1;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'bx;
                      xferByte_0   = 1'bx;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'bx;
                      ChooseMovz_0 = 1'b1;
                      storeFlags   = 1'b0;
                      ALUOp_0      = 3'b000;
                   end
         default:  begin
                      Reg2Loc      = 1'bx;
                      ALUSrc_0     = 1'bx;
                      MemToReg_0   = 1'bx;
                      RegWrite_0   = 1'b0;
                      MemWrite_0   = 1'b0;
                      MemRead_0    = 1'bx;
                      ChooseImm_0  = 1'bx;
                      xferByte_0   = 1'bx;
                      BrTaken      = 1'b0;
                      UncondBr     = 1'bx;
                      ChooseMovk_0 = 1'bx;
                      ChooseMovz_0 = 1'bx;
                      storeFlags   = 1'b0;
                      ALUOp_0      = 3'b000;
                   end
      endcase
            
   end
endmodule

module main_control_testbench ();
   logic        clk;
   logic        Reg2Loc;
   logic        ALUSrc_0;
   logic        MemToReg_0;
   logic        RegWrite_0;
   logic        MemWrite_0;
   logic        MemRead_0;
   logic        ChooseImm_0;
   logic        xferByte_0;
   logic        BrTaken;
   logic        UncondBr;
   logic        ChooseMovk_0;
   logic        ChooseMovz_0;
   logic        storeFlags;
   logic  [2:0] ALUOp_0;
   logic [10:0] opcode;
   logic  [3:0] flags, regFlags; 

   main_control dut (
      .Reg2Loc,
      .ALUSrc_0,
      .MemToReg_0,
      .RegWrite_0,
      .MemWrite_0,
      .MemRead_0,
      .ChooseImm_0,
      .xferByte_0,
      .BrTaken,
      .UncondBr,
      .ChooseMovk_0,
      .ChooseMovz_0,
      .storeFlags,
      .ALUOp_0,
      .opcode,
      .flags,
      .regFlags
   );

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end

   parameter
   B     = 11'b000_1010_1101,
   CBZ   = 11'b101_1010_0xxx,
   B_LT  = 11'b010_1010_0xxx,
   ADDS  = 11'b101_0101_1000,
   SUBS  = 11'b111_0101_1000,
   ADDI  = 11'b100_1000_1000,
   LDUR  = 11'b111_1100_0010,
   LDURB = 11'b001_1100_0010,
   STUR  = 11'b111_1100_0000,
   STURB = 11'b001_1100_0000,
   MOVK  = 11'b001_1110_0101,
   MOVZ  = 11'b001_1010_0101;

   initial begin
      opcode <= B;     flags <= 4'b0000; @(posedge clk);
      opcode <= CBZ;                     @(posedge clk);
                       flags <= 4'b0100; @(posedge clk);
      opcode <= B_LT;                    @(posedge clk);
                       flags <= 4'b0010; @(posedge clk);
                       flags <= 4'b1000; @(posedge clk);
                       flags <= 4'b1010; @(posedge clk);
      opcode <= ADDS;                    @(posedge clk);
      opcode <= SUBS;                    @(posedge clk);
      opcode <= ADDI;                    @(posedge clk);
      opcode <= LDUR;                    @(posedge clk);
      opcode <= LDURB;                   @(posedge clk);
      opcode <= STUR;                    @(posedge clk);
      opcode <= STURB;                   @(posedge clk);
      opcode <= MOVK;                    @(posedge clk);
      opcode <= MOVZ;                    @(posedge clk);
                                         @(posedge clk);
      $stop;
   end
endmodule
