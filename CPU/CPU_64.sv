`timescale 1ns/10ps

module CPU_64 (clk, reset);
   input logic clk, reset;

   logic [63:0] instrAddr, instrAddrNext;
   logic [31:0] instruction;

   // Parse instruction for fields
   logic [10:0] opcode;
   assign opcode = instruction[31:21];
   
   logic [18:0] condAddr19;
   logic [25:0] brAddr26;
   assign condAddr19 = instruction[23:5];
   assign brAddr26   = instruction[25:0];

   logic [4:0] Rd, Rm, Rn;
   assign Rd = instruction[4:0];
   assign Rm = instruction[20:16];
   assign Rn = instruction[9:5];

   logic [8:0] Daddr9;
   assign Daddr9 = instruction[20:12];

   logic [11:0] Imm12;
   assign Imm12 = instruction[21:10];

   logic [1:0] Shamt;
   assign Shamt = instruction[22:21];

   logic [15:0] Imm16;
   assign Imm16 = instruction[20:5];

   // Program Counter
   reg64 pc (
      .clk,
      .reset,
      .dOut(instrAddr),
      .WriteData(instrAddrNext),
      .wrEnable(1'b1)
   );

   // Sign extend condAddr19 and brAddr26
   logic [63:0] condAddr19_SE, brAddr26_SE;
   assign condAddr19_SE = {{45{condAddr19[18]}}, condAddr19};
   assign brAddr26_SE   = {{38{brAddr26[25]}}, brAddr26};

   // Select between conditional or unconditional branch amount
   logic [63:0] brChoice, brChoice4x;
   selectData branchSelector (
      .out(brChoice),
      .A(condAddr19_SE),
      .B(brAddr26_SE),
      .sel(uncondBr)
   );

   // Branching control signals
   logic UncondBr, BrTaken;

   // Branch amount times 4
   assign brChoice4x = {brChoice[61:0], 2'b0};

   logic [63:0] pcPlus4, pcPlusSEBranch;

   // Adder that produces PC + 4
   alu pcPlusFour (
      .result(pcPlus4),
      .negative(),
      .zero(),
      .overflow(),
      .carry_out(),
      .A(instrAddr),
      .B(64'd4),
      .cntrl(3'b010)
   );

   // Adder that produces PC + SE(branch)
   alu pcPlusSEBr (
      .result(pcPlusSEBranch),
      .negative(),
      .zero(),
      .overflow(),
      .carry_out(),
      .A(brChoice4x),
      .B(instrAddr),
      .cntrl(3'b010)
   );

   // Select between PC + 4 and PC + SE(branch)
   selectData toBranchOrNotToBranchThatIsTheQuestion (
      .out(instrAddrNext),
      .A(pcPlus4),
      .B(pcPlusSEBranch),
      .sel(BrTaken)
   );

   // Instruction Memory
   instructmem iMem (.address(instrAddr), .instruction, .clk);

   // Control logic
   logic       Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, MemRead,
               ChooseImm, xferByte, ChooseMovk, ChooseMovz;
   logic [2:0] ALUOp;
   logic [3:0] flags;
   main_control control (
      .Reg2Loc,
      .ALUSrc,
      .MemToReg,
      .RegWrite,
      .MemWrite,
      .MemRead,
      .ChooseImm,
      .xferByte,
      .BrTaken,
      .UncondBr,
      .ChooseMovk,
      .ChooseMovz,
      .ALUOp,
      .opcode,
      .flags
   );

   // Datapath
   datapath dp (
      .clk,
      .reset,
      .flags,
      .Rd,
      .Rm,
      .Rn,
      .Daddr9,
      .Imm12,
      .Shamt,
      .Imm16,
      .Reg2Loc,
      .ALUSrc,
      .MemToReg,
      .RegWrite,
      .MemWrite,
      .MemRead,
      .ChooseImm,
      .xferByte,
      .ChooseMovk,
      .ChooseMovz,
      .ALUOp
   );
endmodule
