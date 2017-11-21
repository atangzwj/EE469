`timescale 1ns/10ps

// Used to select one of two buses 
module fowardingUnit (
   output logic  [1:0] MuxDa_Sel,
   output logic  [1:0] MuxDb_Sel,
   
   input  logic [63:0] ALU_out_mem_0, // alu out in mem stage
   input  logic [63:0] ALU_out_exe_0, // alu out in exe stage
   input  logic  [4:0] Rd_mem_0,      // destination register in exe stage
   input  logic  [4:0] Rd_exe_0       // destination register in mem stage
   input  logic  [4:0] Rn,
   input  logic  [4:0] Rmd,
   input  logic        RegWrite_mem,
   input  logic        RegWrite_exe
   );
   
   // Compare Rn and Rmd with Rd_mem_0 and Rd_exe_0
   // ADD X0, X1, X2
   // ADD .., X0, ..
   // ADD .., .., X0 <-- Checks value
   
   // If RegWrite_mem is false, then two instructions before we weren't going to write to regfile
   // If RegWrite_exe is false, then one instruction before ....
   
   // If Rn and/or Rmd is X31, don't forward anything
   
   // Output the control which selects between original value, 
   // value forwarded from mem stage, and value from exe stage   
   
   always_comb begin
      case()
   
      endcase
   end
   
endmodule
