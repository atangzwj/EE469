`timescale 1ns/10ps

// Used to select one of two buses 
module fowardingUnit (
   output logic [63:0] ALU_out_mem,
   output logic [63:0] ALU_out_exe,
   output logic  [4:0] Rd_mem,
   output logic  [4:0] Rd_exe,
   
   input  logic [63:0] ALU_out_mem_0, // alu out in mem stage
   input  logic [63:0] ALU_out_exe_0, // alu out in exe stage
   input  logic  [4:0] Rd_mem_0,      // destination register in exe stage
   input  logic  [4:0] Rd_exe_0       // destination register in mem stage   
   );
   
   register #(.WIDTH(5)) Rd_mem_Reg (
      .clk,
      .reset,
      .dOut(Rd_1),
      .WriteData(Rd_mem_0),
      .wrEnable(1'b1)
   );
   
   register #(.WIDTH(5)) Rd_exe_Reg (
      .clk,
      .reset,
      .dOut(Rd_exe),
      .WriteData(Rd_exe_0),
      .wrEnable(1'b1)
   );   

endmodule
