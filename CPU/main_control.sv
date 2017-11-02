`timescale 1ns/10ps

module main_control (
   output logic        Reg2Loc,
   output logic        ALUSrc,
   output logic        MemToReg,
   output logic        RegWrite,
   output logic        MemWrite,
   output logic        MemRead,
   output logic        ChooseImm,
   output logic        xferByte,
   output logic        BrTaken,
   output logic        UncondBr,
   output logic        ChooseMovk,
   output logic        ChooseMovz,
   output logic  [2:0] ALUOp,
   input  logic [10:0] opcode,
   input  logic  [3:0] flags
   );

   // Intstruction opcodes
   parameter
   B     = 10'b000_101x_xxxx,
   CBZ   = 10'b101_1010_0xxx,
   B_LT  = 10'b010_1010_0xxx,
   ADDS  = 10'b101_0101_1000,
   SUBS  = 10'b111_0101_1000,
   ADDI  = 10'b100_1000_1000,
   LDUR  = 10'b111_1100_0010,
   LDURB = 10'b001_1100_0010,
   STUR  = 10'b111_1100_0000,
   STURB = 10'b001_1100_0000,
   MOVK  = 10'b001_1110_0101,
   MOVZ  = 10'b001_1010_0101;

   always_comb begin
      casex (opcode)
         B:        begin
                      Reg2Loc    = 1'bx;
                      ALUSrc     = 1'bx;
                      MemToReg   = 1'bx;
                      RegWrite   = 1'b0;
                      MemWrite   = 1'b0;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'bx;
                      xferByte   = 1'bx;
                      BrTaken    = 1'b1;
                      UncondBr   = 1'b1;
                      ChooseMovk = 1'bx;
                      ChooseMovz = 1'bx;
                      ALUOp      = 3'bxxx;
                   end
         CBZ:      begin
                      Reg2Loc    = 1'bx;
                      ALUSrc     = 1'b0;
                      MemToReg   = 1'bx;
                      RegWrite   = 1'b0;
                      MemWrite   = 1'b0;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'bx;
                      xferByte   = 1'bx;
                      BrTaken    = flags[2];
                      UncondBr   = 1'b0;
                      ChooseMovk = 1'bx;
                      ChooseMovz = 1'bx;
                      ALUOp      = 3'b000;
                   end
         B_LT:     begin
                      Reg2Loc    = 1'bx;
                      ALUSrc     = 1'b0;
                      MemToReg   = 1'bx;
                      RegWrite   = 1'b0;
                      MemWrite   = 1'b0;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'bx;
                      xferByte   = 1'bx;
                      BrTaken    = flags[3] ^ flags[1];
                      UncondBr   = 1'b0;
                      ChooseMovk = 1'bx;
                      ChooseMovz = 1'bx;
                      ALUOp      = 3'bxxx;
                   end
         ADDS:     begin
                      Reg2Loc    = 1'b1;
                      ALUSrc     = 1'b0;
                      MemToReg   = 1'b0;
                      RegWrite   = 1'b1;
                      MemWrite   = 1'b0;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'b0;
                      xferByte   = 1'bx;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'b0;
                      ChooseMovz = 1'b0;
                      ALUOp      = 3'b010;
                   end
         SUBS:     begin
                      Reg2Loc    = 1'b1;
                      ALUSrc     = 1'b0;
                      MemToReg   = 1'b0;
                      RegWrite   = 1'b1;
                      MemWrite   = 1'b0;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'b0;
                      xferByte   = 1'bx;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'b0;
                      ChooseMovz = 1'b0;
                      ALUOp      = 3'b011;
                   end
         ADDI:     begin
                      Reg2Loc    = 1'bx;
                      ALUSrc     = 1'bx;
                      MemToReg   = 1'b0;
                      RegWrite   = 1'b1;
                      MemWrite   = 1'b0;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'b1;
                      xferByte   = 1'bx;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'b0;
                      ChooseMovz = 1'b0;
                      ALUOp      = 3'b010;
                   end
         LDUR:     begin
                      Reg2Loc    = 1'bx;
                      ALUSrc     = 1'b1;
                      MemToReg   = 1'b1;
                      RegWrite   = 1'b1;
                      MemWrite   = 1'b0;
                      MemRead    = 1'b1;
                      ChooseImm  = 1'b0;
                      xferByte   = 1'b0;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'b0;
                      ChooseMovz = 1'b0;
                      ALUOp      = 3'b010;
                   end
         LDURB:    begin
                      Reg2Loc    = 1'bx;
                      ALUSrc     = 1'b1;
                      MemToReg   = 1'b1;
                      RegWrite   = 1'b1;
                      MemWrite   = 1'b0;
                      MemRead    = 1'b1;
                      ChooseImm  = 1'b0;
                      xferByte   = 1'b1;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'b0;
                      ChooseMovz = 1'b0;
                      ALUOp      = 3'b010;
                   end
         STUR:     begin
                      Reg2Loc    = 1'b0;
                      ALUSrc     = 1'b1;
                      MemToReg   = 1'bx;
                      RegWrite   = 1'b0;
                      MemWrite   = 1'b1;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'b0;
                      xferByte   = 1'b0;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'b0;
                      ChooseMovz = 1'b0;
                      ALUOp      = 3'b010;
                   end
         STURB:    begin
                      Reg2Loc    = 1'b0;
                      ALUSrc     = 1'b1;
                      MemToReg   = 1'bx;
                      RegWrite   = 1'b0;
                      MemWrite   = 1'b1;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'b0;
                      xferByte   = 1'b0;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'b0;
                      ChooseMovz = 1'b0;
                      ALUOp      = 3'b010;
                   end
         MOVK:     begin
                      Reg2Loc    = 1'bx;
                      ALUSrc     = 1'bx;
                      MemToReg   = 1'b0;
                      RegWrite   = 1'b1;
                      MemWrite   = 1'b0;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'bx;
                      xferByte   = 1'bx;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'b1;
                      ChooseMovz = 1'b0;
                      ALUOp      = 3'b000;
                   end
         MOVZ:     begin
                      Reg2Loc    = 1'bx;
                      ALUSrc     = 1'bx;
                      MemToReg   = 1'b0;
                      RegWrite   = 1'b1;
                      MemWrite   = 1'b0;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'bx;
                      xferByte   = 1'bx;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'bx;
                      ChooseMovz = 1'b1;
                      ALUOp      = 3'b000;
                   end
         default:  begin
                      Reg2Loc    = 1'bx;
                      ALUSrc     = 1'bx;
                      MemToReg   = 1'bx;
                      RegWrite   = 1'b0;
                      MemWrite   = 1'b0;
                      MemRead    = 1'bx;
                      ChooseImm  = 1'bx;
                      xferByte   = 1'bx;
                      BrTaken    = 1'b0;
                      UncondBr   = 1'bx;
                      ChooseMovk = 1'bx;
                      ChooseMovz = 1'bx;
                      ALUOp      = 3'b000;
                   end
      endcase
   end
endmodule
