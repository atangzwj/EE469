onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label ReadRegister1 -radix unsigned /regstim/ReadRegister1
add wave -noupdate -label ReadRegister2 -radix unsigned /regstim/ReadRegister2
add wave -noupdate -label WriteRegister -radix unsigned /regstim/WriteRegister
add wave -noupdate -label WriteData -radix hexadecimal /regstim/WriteData
add wave -noupdate -label RegWrite /regstim/RegWrite
add wave -noupdate -label clk /regstim/clk
add wave -noupdate -label ReadData1 -radix hexadecimal /regstim/ReadData1
add wave -noupdate -label ReadData2 -radix hexadecimal /regstim/ReadData2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 130
configure wave -valuecolwidth 110
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {501375 ns}
