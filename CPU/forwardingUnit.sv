`timescale 1ns/10ps

// Used to select one of two buses 
module fowardingUnit (
   output logic [63:0] ALU_out_mem,
   output logic [63:0] ALU_out_exe,
   output logic  [4:0] Rd_mem,
   output logic  [4:0] Rd_exe,
   output logic  [1:0] MuxDa_Sel,
   output logic  [1:0] MuxDb_Sel,
   
   input  logic [63:0] ALU_out_mem_0, // alu out in mem stage
   input  logic [63:0] ALU_out_exe_0, // alu out in exe stage
   input  logic  [4:0] Rd_mem_0,      // destination register in exe stage
   input  logic  [4:0] Rd_exe_0       // destination register in mem stage 
   );
   
   
   
   
endmodule
