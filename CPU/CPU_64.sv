`timescale 1ns/10ps

module CPU_64 (
   input logic clk, reset
   );

   logic [63:0] instrAddr, instrAddrNext;
   logic [31:0] instruction;

   // Program Counter
   reg64 pc (
      .clk,
      .reset,
      .dOut(instrAddr),
      .WriteData(instrAddrNext),
      .wrEnable(1'b1)
   );

   logic [18:0] condAddr19;
   logic [25:0] brAddr26;
   logic [63:0] condAddr19_SE, brAddr26_SE;
   assign condAddr19    = instruction[23:5];
   assign brAddr26      = instruction[25:0];
   assign condAddr19_SE = {{45{condAddr19[18]}}, condAddr19};
   assign brAddr26_SE   = {{38{brAddr26[25]}}, brAddr26};

   logic [63:0] brChoice, brChoice4x;
   selectData branchSelector (
      .out(brChoice),
      .A(condAddr19_SE),
      .B(brAddr26_SE),
      .sel(uncondBr)
   );

   // Branching control signals
   logic uncondBr, brTaken;

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
      .sel(brTaken)
   );

   // Instruction Memory
   instructmem iMem (.address(instrAddr), .instruction, .clk);
endmodule

module CPU_64_testbench ();
   logic clk, reset;

   CPU_64 dut (.clk, .reset);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end

   integer i;   
   initial begin
   reset <= 1'b1; @(posedge clk);
   reset <= 1'b0; @(posedge clk);
   
   $stop;
   end
endmodule
