module decoder5_32 (
   output logic [31:0] d,
   input  logic [4:0]  sel,
   input  logic        en
   );

   logic [3:0] en_mid;
   decoder2_4 d2_4 (.d(en_mid), .sel(sel[4:3]), .en);
   
   genvar i;
   generate
      for (i = 0; i < 4; i++) begin : decoders3_8
         decoder3_8 d3_8 (
            .d(d[i * 8 + 7 : i * 8]),
            .sel(sel[2:0]),
            .en(en_mid[i])
         );
      end
   endgenerate
endmodule

module decoder5_32_testbench ();
   logic [31:0] d;
   logic [4:0]  sel;
   logic        en;

   decoder5_32 dut (.d, .sel, .en);

   integer i;
   initial begin
      en = 1'b0;
      for (i = 0; i < 32; i++) begin
         sel = i; #10;
      end
      sel = 5'b00000;
      en = 1'b1;
      for (i = 0; i < 32; i++) begin
         sel = i; #10;
      end
   end
endmodule
