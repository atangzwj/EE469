module datapath (
   output logic ????;
   input  logic Reg2Loc,
                ALUSrc,
                MemToReg,
                RegWrite,
                MemWrite,
                BrTaken,
                UncondBr,
                ALUOp
                
                );
   
   // 5 2_1 muxes
   
   // 3 ALUs (2 only adders)

   // Instruction Memory instantiation
   // Input a 64bit adx and outputs 32bit instruction
   instructmem name (.clk, .instruction(),
                        .address());
   
   // Data Memory instantiation
	datamem name (.clk, .read_data(),
                  .address(),
                  .write_enable(),
                  .write_data(),
                  .xfer_size());
   
   
endmodule