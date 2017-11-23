`timescale 1ns/10ps

// Used to select one of two buses 
module forwardingUnit (
   output logic  [1:0] MuxDa_Sel,
   output logic  [1:0] MuxDb_Sel,
   
   input  logic  [4:0] Rd_mem,       // destination register in exe stage
   input  logic  [4:0] Rd_exe,       // destination register in mem stage
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
      if (Rn == 5'b11111)                   MuxDa_Sel = 2'b0x;
      else if (Rn == Rd_exe & RegWrite_exe) MuxDa_Sel = 2'b11;
      else if (Rn == Rd_mem & RegWrite_mem) MuxDa_Sel = 2'b10;
      else                                  MuxDa_Sel = 2'b0x;

      if (Rmd == 5'b11111)                   MuxDb_Sel = 2'b0x;
      else if (Rmd == Rd_exe & RegWrite_exe) MuxDb_Sel = 2'b11;
      else if (Rmd == Rd_mem & RegWrite_mem) MuxDb_Sel = 2'b10;
      else                                   MuxDb_Sel = 2'b0x;
   end
endmodule
