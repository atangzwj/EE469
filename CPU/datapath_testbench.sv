`timescale 1ns/10ps

module datapath_testbench ();
   logic        clk, reset;
   // Data fields
   logic  [4:0]  Rd, Rm, Rn;
   logic  [8:0]  Daddr9;
   logic [11:0]  Imm12;
   logic  [3:0]  flags;
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
                 .flags,
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
   
   // ****************
   // PRELIMINARY TEST
   // ****************
      // Step 1. ADDI X0, X31, #420   -- Add 420 into X0
      // Step 2. STUR X0, [X31, 0]    -- Store 420 into address 0 in datamem
      // Step 3. LDUR X30, [X31, 0]   -- Load 420 from address 0 into X30
      // Step 4. SUBS X5, X31, X30    -- Compute 0 - 420 = -420 into X5
   
   $display("%t ADDI X0, X31, #420", $time);   
   ctrlBus <= {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ALUOp   <= 3'b010;
   Rn      <= 31;
   Rd      <= 0;
   Imm12   <= 420;
   @(posedge clk);
   $display("%t Reading Reg Rm = X0, (Output @ Db)", $time);
   ctrlBus[2] <= 0; // RegWrite
   Rm <= 0;
   @(posedge clk);   

   $display("%t STUR X0, [X31, 0].", $time);   
   ctrlBus <= {1'b0, 1'b0, 1'b1, 1'bx, 1'b0, 1'b1, 1'b0};
   ALUOp   <= 3'b010;
   Daddr9  <= 0;
   Rd      <= 0;
   Rn      <= 31;
   @(posedge clk);   

   $display("%t LDUR X30, [X31, 0].", $time);   
   ctrlBus <= {1'b0, 1'bx, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1};
   ALUOp   <= 3'b010;   
   Daddr9  <= 0;
   Rd      <= 30;
   Rn      <= 31;
   @(posedge clk);   
   $display("%t Reading Reg Rn = X30, (Output @ Da)", $time);
   ctrlBus <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
   ALUOp   <= 3'b010;
   Rn      <= 30;   
   @(posedge clk);
   $display("%t SUBS X5, X31, X30", $time);
   ctrlBus <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ALUOp   <= 3'b011;
   Rd <= 5;
   Rn <= 31;   
   Rm <= 30;
   @(posedge clk);   
   $display("%t reading Reg Rm = X5, (Output @ Db)", $time);
   ctrlBus[2] <= 0; // RegWrite
   Rm <= 5;
   @(posedge clk);   
   // ***************
   // END PRELIMINARY
   // ***************
   
   
   
   
   $stop;
   end
endmodule