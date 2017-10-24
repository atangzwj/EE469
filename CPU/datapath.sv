`timescale 1ns/10ps

module datapath (
   input  logic       clk, reset,
   output logic       zeroFlag,
   // Data fields
   input  logic  [4:0] Rd, Rm, Rn,
   input  logic  [8:0] Daddr9,
   input  logic [11:0] Imm12,
   // Control Logic
   input  logic        Reg2Loc,
   input  logic        ALUSrc,
   input  logic        MemToReg,
   input  logic        RegWrite,
   input  logic        MemWrite,
   input  logic        MemRead, // TEMPORARY?   
   input  logic        ChooseImm,   
   input  logic  [2:0] ALUOp
   );
   
   // Gate delay
   parameter DELAY = 0.05;
   
   // Selects between Rd and Rm to output to address Ab in regfile
   // If Reg2Loc == 0, instruction was STUR 
   logic [4:0] Ab_in;
   selectData #(.TOP_BIT(4)) intoAb (
                       .out(Ab_in),
                       .A(Rd),
                       .B(Rm),
                       .sel(Reg2Loc));  
   
   // Regfile for holding and writing the values into the 32 Registers
   logic [63:0] Dw, Da, Db;
   regfile rf (.clk, // to be inverted in Lab4
               .ReadData1(Da),
               .ReadData2(Db),
               .WriteData(Dw),
               .ReadRegister1(Rn),
               .ReadRegister2(Ab_in),
               .WriteRegister(Rd),
               .RegWrite
               );
   
   // Sign extends Daddr_9 to a 64bit number
   logic [63:0] Daddr9_SE;
   assign Daddr9_SE = {{55{Daddr9[8]}}, Daddr9};
   
   // Selects between Db from regfile and the sign extended Daddr9
   // Output goes into the Immediate Constant Mux
   logic [63:0] Db_Imm;   
   selectData intoImmMux (.out(Db_Imm),
                          .A(Db),
                          .B(Daddr9_SE),
                          .sel(ALUSrc));
   
   // Zero extends the Immediate Constant Imm12 to a 64bit number
   logic [63:0] Imm12_ZE, Db_ALU;
   assign Imm12_ZE = {52'b0, Imm12};
   
   // Selects between the output from Db_Imm (which is either Db from regfile
   // or from address offset Daddr9), or the immediate constant
   // Output goes into ALU
   selectData intoALU (.out(Db_ALU),
                       .A(Db_Imm),
                       .B(Imm12_ZE),
                       .sel(ChooseImm));   

   // ALU used for arithmetic between the outputs of the regfile
   // or as an address offset from DAddr9 (from STUR or LDUR)
   logic [63:0] ALU_out;    
   alu op (.result(ALU_out),
           .negative(),
           .zero(zeroFlag), // output to be used for cond branch in CPU_64
           .overflow(),
           .carry_out(),
           .A(Da),
           .B(Db_ALU),
           .cntrl(ALUOp));
   

   // Data Memory
   logic [63:0] Dmem_out;
   not #DELAY n1 (NOTMemWrite, MemWrite);
   datamem dm (.clk,
               .read_data(Dmem_out),
               .address(ALU_out),
               .write_enable(MemWrite),
               //.read_enable(NOTMemWrite),
               .read_enable(MemRead),               
               .write_data(Db),
               .xfer_size(4'b1)
               );
   
   // selects between the output from the ALU and from the data memory
   // writes this selected value into the register
   selectData intoReg (.out(Dw),
                       .A(ALU_out),
                       .B(Dmem_out),
                       .sel(MemToReg));
endmodule

// Used to select data for Reg2Loc, ALUSrc, MemToReg muxes 
module selectData #(parameter TOP_BIT = 63) (
   output logic [TOP_BIT:0] out, 
   input  logic [TOP_BIT:0] A,
   input  logic [TOP_BIT:0] B,
   input  logic             sel
   );

   genvar i;
   generate
      for (i = 0; i < TOP_BIT + 1; i++) begin : muxing
         mux2_1 m (.out(out[i]),
                   .i0(A[i]),
                   .i1(B[i]),
                   .sel);
      end
   endgenerate
endmodule


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
   Reg2Loc   <= 1;
   ALUSrc    <= 0;
   MemToReg  <= 0;
   MemWrite  <= 0;
   MemRead   <= 0;
   ChooseImm <= 1;
   ALUOp <= 3'b010;
   
   RegWrite <= 1;
   Rn <= 31;
   Rd <= 0;
   Imm12 <= 420;
   @(posedge clk);
   RegWrite <= 0;
   Rm <= 0;
   @(posedge clk);

   // ADDI to all registers with random values   
   /*
   for (i = 0; i < 31; i = i+1) begin
      RegWrite <= 0;
      Rn       <= 31;
      Rd       <= i;
      Rm       <= i - 1;      
      Imm12    <= $random();
      @(posedge clk);
      RegWrite <= 1;      
      @(posedge clk);
   end
   */
   
   /*
   $display("%t ADD X10, X5, X3.", $time);   
   Reg2Loc   <= 1;
   ALUSrc    <= 0;
   MemToReg  <= 0;
   MemWrite  <= 0;
   ChooseImm <= 0;
   ALUOp <= 3'b010;
   
   // ADD X10, X5, X3
   RegWrite <= 1;   
   Rd       <= 10;   
   Rn       <= 5;
   Rm       <= 3;
   @(posedge clk);
   RegWrite <= 0;
   Rm <= 10;
   @(posedge clk);   
   */
   
   // STUR values from registers to data memory
   $display("%t STUR at address 0.", $time);   
   Reg2Loc   <= 0;
   ALUSrc    <= 1;
   MemToReg  <= 1'bx;
   RegWrite  <= 0;   
   ChooseImm <= 0;
   ALUOp <= 3'b010;
   Rd        <= 0;
   Rn        <= 31;   
   Daddr9    <= 0;
   MemWrite  <= 1;
   @(posedge clk);   
   
   // LDUR value from address 0 (X31 + SE(0))
   $display("%t testing LDUR command from addr 0 into X30.", $time);   
   MemRead   <= 1;
   Reg2Loc   <= 1'bx;
   ALUSrc    <= 1;
   MemToReg  <= 1;
   RegWrite  <= 1;
   MemWrite  <= 0;   
   ChooseImm <= 0;
   ALUOp <= 3'b010;   
   Rn        <= 31;
   Daddr9    <= 0;
   Rd        <= 30;
   @(posedge clk);   
   RegWrite  <= 0;
   Rm        <= 30;
   @(posedge clk);    
   
   /*
   for (i = 0; i < 31; i++) begin
      Rd <= i - 0;
      Daddr9 <= i * 8;
      MemWrite <= 1;
      #100;
   end
   */
      
   
      
   // for (i = 0; i < 31; i++) begin
      // Rd <= i - 0;
      // Daddr9 <= i * 8;
      // @(posedge clk);
   // end   
   
   $stop;
   end
   
   
endmodule