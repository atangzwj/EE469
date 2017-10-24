`timescale 1ns/10ps

module mux2_1 (
   output logic out,
   input  logic i0, i1, sel
   );
   
   parameter DELAY = 0.05;
   
   // Wires
   logic out0, out1, notSel;

   not #DELAY  n (notSel, sel);
   and #DELAY a1 (out0, i1, sel);
   and #DELAY a2 (out1, i0, notSel);

   or #DELAY o (out, out0, out1);

endmodule

module mux2_1_testbench ();
   logic i0, i1, sel;
   logic out;

   mux2_1 dut (.out, .i0, .i1, .sel);

   initial begin
      sel=0; i0=0; i1=0; #10;
      sel=0; i0=0; i1=1; #10;
      sel=0; i0=1; i1=0; #10;
      sel=0; i0=1; i1=1; #10;
      sel=1; i0=0; i1=0; #10;
      sel=1; i0=0; i1=1; #10;
      sel=1; i0=1; i1=0; #10;
      sel=1; i0=1; i1=1; #10;
   end
endmodule
