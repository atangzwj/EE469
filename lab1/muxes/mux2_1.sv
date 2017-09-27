module mux2_1(
   output logic out;
   input  logic i0, il, sel;
   );

   // Wires
   logic out0, out1, notSel;

   not  n(notSel, sel);
   and a1(out0, i1, sel);
   and a2(out1, i0, notSel);

   or(out, out0, out1);

endmodule


