onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /datapath_testbench/dut/Rm
add wave -noupdate -radix unsigned /datapath_testbench/dut/Rd
add wave -noupdate -radix unsigned /datapath_testbench/dut/Rn
add wave -noupdate -radix unsigned /datapath_testbench/dut/Imm12
add wave -noupdate -radix decimal /datapath_testbench/dut/Da
add wave -noupdate -radix decimal /datapath_testbench/dut/Db
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {659780 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 230
configure wave -valuecolwidth 449
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
WaveRestoreZoom {0 ps} {666750 ps}
