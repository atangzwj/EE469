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

   logic [31:0] instruct_wait;
   // Instruction Memory
   instructmem iMem (.address(instrAddr), .instruction(instruct_wait), .clk);

   // Instruction Fetch Register
   register #(.WIDTH(32)) instFetch (
      .clk,
      .reset,
      .dOut(instruction),
      .WriteData(instruct_wait),
      .wrEnable(1'b1)
   );

   // Generates an old PC value that is one clock cycle before
   // To be used for Old_PC + SE(Branch)
   logic [63:0] instrAddr_Old;
   register #(.WIDTH(64)) oldPC (
      .clk,
      .reset,
      .dOut(instrAddr_Old),
      .WriteData(instrAddr),
      .wrEnable(1'b1)
   );   
   
   // Program Counter
   register pc (
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

   // Branching control signals
   logic UncondBr, BrTaken;

   // Select between conditional or unconditional branch amount
   logic [63:0] brChoice, brChoice4x;
   selectData branchSelector (
      .out(brChoice),
      .A(condAddr19_SE),
      .B(brAddr26_SE),
      .sel(UncondBr)
   );
   
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
      .B(instrAddr_Old),
      .cntrl(3'b010)
   );

   // Select between PC + 4 and PC + SE(branch)
   selectData toBranchOrNotToBranchThatIsTheQuestion (
      .out(instrAddrNext),
      .A(pcPlus4),
      .B(pcPlusSEBranch),
      .sel(BrTaken)
   );

   // Control logic
   logic       Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, MemRead,
               ChooseImm, xferByte, ChooseMovk, ChooseMovz, storeFlags_0;
   logic [2:0] ALUOp;

   logic [2:0] flags; 
   logic [3:0] regFlags;
   logic       zeroFlag;
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
      .storeFlags(storeFlags_0),
      .ALUOp,
      .opcode,
      .zeroFlag,
      .regFlags
   ); 

   // Datapath
   datapath dp (
      .clk,
      .reset,
      .flags,
      .zeroFlag,
      .Rd_0(Rd),
      .Rm,
      .Rn,
      .Daddr9,
      .Imm12,
      .Shamt,
      .Imm16,
      .Reg2Loc,
      .ALUSrc,
      .MemToReg_0(MemToReg),
      .RegWrite_0(RegWrite),
      .MemWrite_0(MemWrite),
      .MemRead_0(MemRead),
      .ChooseImm,
      .xferByte_0(xferByte),
      .ChooseMovk,
      .ChooseMovz,
      .ALUOp_0(ALUOp)
   );

   // Delay storeFlags for use in EXEC stage
   logic storeFlags;
   D_FF storeFlags_delay (.q(storeFlags), .d(storeFlags_0), .reset, .clk);

   // Selects between the preexisting flags in the register and 
   // new flags from the most recent ALU execution
   // Output gets written (or rewritten) into the flag register
   logic zeroFlag_d;
   D_FF zeroFlag_delay (.q(zeroFlag_d), .d(zeroFlag), .reset, .clk);   
   
   
   logic [3:0] writeToFR, newFlags;
   assign newFlags = {flags[2], zeroFlag_d, flags[1:0]};
   
   selectData #(.WIDTH(4)) toFlagReg (
      .out(writeToFR),
      .A(regFlags),
      .B(newFlags),
      .sel(storeFlags) // 1 if instruction is ADDS or SUBS
   );   
   
   // Hold the flags until the next clock cycle for B.LT to use
   // flag[3] = negative
   // flag[2] = zero
   // flag[1] = overflow
   // flag[0] = carry_out

   D_FF fr0 (.q(regFlags[0]), .d(writeToFR[0]), .reset, .clk);
   D_FF fr1 (.q(regFlags[1]), .d(writeToFR[1]), .reset, .clk);
   D_FF fr2 (.q(regFlags[2]), .d(writeToFR[2]), .reset, .clk);
   D_FF fr3 (.q(regFlags[3]), .d(writeToFR[3]), .reset, .clk);

//   genvar i;
//   generate
//      for(i = 0; i < 4; i++) begin : flagRegisters
//         if (i == 2)
//            D_FF fr (.q(regFlags[i]), .d(zeroFlag_d), .reset, .clk);
//        else
//            D_FF fr (.q(regFlags[i]), .d(writeToFR[i]), .reset, .clk);
//      end
//   endgenerate
endmodule
