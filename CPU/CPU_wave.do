onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_testbench/clk
add wave -noupdate /datapath_testbench/reset
add wave -noupdate -radix decimal /datapath_testbench/dut/instructAddr
add wave -noupdate -radix decimal /datapath_testbench/dut/nextAddr
add wave -noupdate /datapath_testbench/dut/instruction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9714 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 240
configure wave -valuecolwidth 202
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {628608 ps}
