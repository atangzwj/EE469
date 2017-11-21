`timescale 1ns/10ps

module datapath_testbench ();
   logic        clk, reset;
   // Data fields
   logic  [4:0]  Rd, Rm, Rn;
   logic  [8:0]  Daddr9;
   logic [11:0]  Imm12;
   logic  [1:0]  Shamt;
   logic [15:0]  Imm16;
   logic  [2:0]  flags;
   logic         zeroFlag;
   // Control Logic
   logic        Reg2Loc;
   logic        ALUSrc;
   logic        MemToReg;
   logic        RegWrite;
   logic        MemWrite;
   logic        MemRead;
   logic        ChooseImm;
   logic        xferByte;
   logic        ChooseMovk;
   logic        ChooseMovz;
   logic  [2:0] ALUOp;
   
   logic  [9:0] ctrlBus;
   
   datapath dut (.clk, .reset,
                 .flags,
                 .zeroFlag,
                 .Rd, .Rm, .Rn,
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
                 .ALUOp);
   
   assign ChooseMovz = ctrlBus[9];
   assign ChooseMovk = ctrlBus[8];
   assign xferByte   = ctrlBus[7];              
   assign ChooseImm  = ctrlBus[6];
   assign Reg2Loc    = ctrlBus[5];
   assign ALUSrc     = ctrlBus[4];
   assign MemToReg   = ctrlBus[3];
   assign RegWrite   = ctrlBus[2];
   assign MemWrite   = ctrlBus[1];
   assign MemRead    = ctrlBus[0];
   
   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end
   
   integer CONST = 512;
   integer i;
   initial begin
   reset <= 1'b1; @(posedge clk);
   reset <= 1'b0; @(posedge clk);
   
   // ****************
   // PRELIMINARY TEST
   // ****************
      // Step  1. ADDI X0, X31, #CONST  -- Add CONST into X0
      // Step  2. STUR X0, [X31, 0]     -- Store CONST into address 0 in datamem
      // Step  3. LDUR X30, [X31, 0]    -- Load CONST from address 0 into X30
      // Step  4. SUBS X5, X31, X30     -- Compute 0 - CONST = -COSNT into X5
      // Step  5. STURB X5, [X31, #16]  -- Store 8 bits from X5 into Addr 16
      // Step  6. LDURB X9, [X31, #16]  -- Load value from Addr 16 into X9
      // Step  7. MOVK X0, FFFF, LSL 16 -- Write in 16b'1s into X0[16:31]
      // Step  8. MOVK X0, rand, LSL 32 -- Write in 16 bit random value into X0[47:32]
      // Step  9. MOVK X0, rand, LSL 48 -- Write in 16 bit random value into X0[63:48]
      // Step 10. MOVZ X0, rand, LSL 32 -- Write in rand value into X0[47, 32] and zero everything else
   
   $display("%t ADDI X0, X31, #CONST", $time);   
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ALUOp   <= 3'b010;
   Rn      <= 31;
   Rd      <= 0;
   Imm12   <= CONST;
   @(posedge clk);
   $display("%t Reading Reg Rm = X0, (Output @ Db)", $time);
   ctrlBus[2] <= 0; // RegWrite
   Rm <= 0;
   @(posedge clk);   

   $display("%t STUR X0, [X31, 0].", $time);   
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx, 1'b0, 1'b1, 1'b0};
   ALUOp   <= 3'b010;
   Daddr9  <= 0;
   Rd      <= 0;
   Rn      <= 31;
   @(posedge clk);   

   $display("%t LDUR X30, [X31, 0].", $time);   
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1};
   ALUOp   <= 3'b010;   
   Daddr9  <= 0;
   Rd      <= 30;
   Rn      <= 31;
   @(posedge clk);   
   $display("%t Reading Reg Rn = X30, (Output @ Da)", $time);
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
   ALUOp   <= 3'b010;
   Rn      <= 30;   
   @(posedge clk);
   $display("%t SUBS X5, X31, X30", $time);
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ALUOp   <= 3'b011;
   Rd <= 5;
   Rn <= 31;   
   Rm <= 30;
   @(posedge clk);   
   $display("%t reading Reg Rm = X5, (Output @ Db)", $time);
   ctrlBus[2] <= 0; // RegWrite
   Rm <= 5;
   @(posedge clk);
   $display("%t STURB X5, [X31, #16]", $time);
   ctrlBus <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'bx, 1'b0, 1'b1, 1'b0};
   ALUOp   <= 3'b010;   
   Daddr9  <= 16;
   Rd      <= 5;
   Rn      <= 31;
   @(posedge clk);   
   $display("%t LDURB X9, [X31, #16].", $time);   
   ctrlBus <= {1'b0, 1'b0, 1'b1, 1'b0, 1'bx, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1};
   ALUOp   <= 3'b010;   
   Daddr9  <= 16;
   Rd      <= 9;
   Rn      <= 31;
   @(posedge clk);   
   $display("%t reading Reg Rm = X9, (Output @ Db)", $time);
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ctrlBus[2] <= 0; // RegWrite
   Rm <= 9;   
   @(posedge clk);
   //MOVK Rd, Imm16, LSL Shamt: Reg[Rd][16*Shamt+15:16*Shamt] = Imm16.
   $display("%t MOVK X0, FFFF, LSL 16", $time);
   ctrlBus <= {1'b0, 1'b1, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ALUOp   <= 3'b000;
   Shamt   <= 2'b01;
   Imm16   <= 16'hFFFF;
   Rd      <= 0;
   @(posedge clk);
   $display("%t reading Reg Rm = X0, (Output @ Db)", $time);
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ctrlBus[2] <= 0; // RegWrite
   Rm <= 0;   
   @(posedge clk);
   $display("%t MOVK X0, $random, LSL 32", $time);
   ctrlBus <= {1'b0, 1'b1, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ALUOp   <= 3'b000;
   Shamt   <= 2'b10;
   Imm16   <= $random();
   Rd      <= 0;
   @(posedge clk);
   $display("%t reading Reg Rm = X0, (Output @ Db)", $time);
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ctrlBus[2] <= 0; // RegWrite
   Rm <= 0;   
   @(posedge clk);
   $display("%t MOVK X0, $random, LSL 48", $time);
   ctrlBus <= {1'b0, 1'b1, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ALUOp   <= 3'b000;
   Shamt   <= 2'b11;
   Imm16   <= $random();
   Rd      <= 0;
   @(posedge clk);
   $display("%t reading Reg Rm = X0, (Output @ Db)", $time);
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ctrlBus[2] <= 0; // RegWrite
   Rm <= 0;   
   @(posedge clk);
   $display("%t MOVZ X0, $random, LSL 32", $time);
   ctrlBus <= {1'b1, 1'b0, 1'bx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ALUOp   <= 3'b000;
   Shamt   <= 2'b10;
   Imm16   <= $random();
   Rd      <= 0;
   @(posedge clk);
   $display("%t reading Reg Rm = X0, (Output @ Db)", $time);
   ctrlBus <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
   ctrlBus[2] <= 0; // RegWrite
   Rm <= 0;   
   @(posedge clk);      
   $stop;
   end
endmodule