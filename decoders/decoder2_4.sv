`timescale 1ns/10ps

module decoder2_4 (
   output logic [3:0] d,
   input  logic [1:0] sel,
   input  logic       en
   );

   parameter DELAY = 0.05;
   
   logic [1:0] seln;
   not #DELAY n0 (seln[0], sel[0]);
   not #DELAY n1 (seln[1], sel[1]);

   and #DELAY d0 (d[0], en, seln[1], seln[0]);
   and #DELAY d1 (d[1], en, seln[1], sel[0]);
   and #DELAY d2 (d[2], en, sel[1],  seln[0]);
   and #DELAY d3 (d[3], en, sel[1],  sel[0]);
endmodule

module decoder2_4_testbench ();
   logic [3:0] d;
   logic [1:0] sel;
   logic       en;

   decoder2_4 dut (.d, .sel, .en);

   integer i;
   initial begin
      en = 1'b0;
      for (i = 0; i < 4; i++) begin
         sel = i; #10;
      end
      sel = 2'b00;
      en = 1'b1;
      for (i = 0; i < 4; i++) begin
         sel = i; #10;
      end
   end
endmodule 
