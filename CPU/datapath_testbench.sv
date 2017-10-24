`timescale 1ns/10ps

module datapath_testbench ();
   logic        clk, reset;
   logic        zeroFlag;
   // Data fields
   logic  [4:0]  Rd, Rm, Rn;
   logic  [8:0]  Daddr9;
   logic [11:0] Imm12;   
   // Control Logic
   logic        Reg2Loc;
   logic        ALUSrc;
   logic        MemToReg;
   logic        RegWrite;
   logic        MemWrite;
   logic        MemRead;
   logic        ChooseImm;  
   logic  [2:0] ALUOp;
   
   logic  [6:0] ctrlBus;
   
   datapath dut (.clk, .reset,
                 .zeroFlag,
                 .Rd, .Rm, .Rn,
                 .Daddr9,
                 .Imm12,
                 .Reg2Loc,
                 .ALUSrc,
                 .MemToReg,
                 .RegWrite,
                 .MemWrite,
                 .MemRead,
                 .ChooseImm,
                 .ALUOp);
                 
   assign ChooseImm = ctrlBus[6];
   assign Reg2Loc   = ctrlBus[5];
   assign ALUSrc    = ctrlBus[4];
   assign MemToReg  = ctrlBus[3];
   assign RegWrite  = ctrlBus[2];
   assign MemWrite  = ctrlBus[1];
   assign MemRead   = ctrlBus[0];
   
   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end
   
   integer i;   
   initial begin
   reset <= 1'b1; @(posedge clk);
   reset <= 1'b0; @(posedge clk);
   
   
   $display("%t ADDI X0, X31, #420", $time);   
   ctrlBus <= {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ALUOp <= 3'b010;
   Rn <= 31;
   Rd <= 0;
   Imm12 <= 420;
   @(posedge clk);
   $display("%t Reading Reg Rm = X0, (Output @ Db)", $time);
   RegWrite <= 0;
   Rm <= 0;
   @(posedge clk);   

   $stop;
   end
   
   
endmodule