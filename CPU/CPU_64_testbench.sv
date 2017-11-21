`timescale 1ns/10ps

module CPU_64_testbench ();
   logic clk, reset;
   logic [10:0] OPCODE;
   logic [6*8:0]  OPstring;
   
   CPU_64 dut (.clk, .reset);

   parameter CLK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLK_PERIOD / 2) clk <= ~clk;
   end

   parameter
   B     = 11'b000_101x_xxxx,
   CBZ   = 11'b101_1010_0xxx,
   B_LT  = 11'b010_1010_0xxx,
   ADDS  = 11'b101_0101_1000,
   SUBS  = 11'b111_0101_1000,
   ADDI  = 11'b100_1000_100x,
   LDUR  = 11'b111_1100_0010,
   LDURB = 11'b001_1100_0010,
   STUR  = 11'b111_1100_0000,
   STURB = 11'b001_1100_0000,
   MOVK  = 11'b111_1001_01xx,
   MOVZ  = 11'b110_1001_01xx;
   integer i;
   initial begin
      reset <= 1'b0; @(posedge clk);
      reset <= 1'b1; @(posedge clk);
      reset <= 1'b0;
    
      forever begin
         @(negedge clk); // middle of the instruction when everything has settled
         OPCODE = dut.instruction[31:21];
         casex(OPCODE)
            B:       OPstring = "B";
            CBZ:     OPstring = "CBZ";
            B_LT:    OPstring = "B_LT";
            ADDS:    OPstring = "ADDS";
            SUBS:    OPstring = "SUBS";
            ADDI:    OPstring = "ADDI";
            LDUR:    OPstring = "LDUR";
            LDURB:   OPstring = "LDURB";
            STUR:    OPstring = "STUR";
            STURB:   OPstring = "STURB";
            MOVK:    OPstring = "MOVK";
            MOVZ:    OPstring = "MOVZ";                
            default: OPstring = "XXXX";                  
         endcase

         $display("%t %b %s", $time,  dut.instruction, OPstring);
         if (dut.instruction == 32'b00010100000000000000000000000000) begin
            $display("%t B HALT has been reached", $time);
            break;
         end
      end
      repeat(5) @(posedge clk);

      $stop;
   end
endmodule