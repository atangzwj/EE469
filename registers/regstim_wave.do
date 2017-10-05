onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label ReadRegister1 /regstim/ReadRegister1
add wave -noupdate -label ReadRegister2 /regstim/ReadRegister2
add wave -noupdate -label WriteRegister /regstim/WriteRegister
add wave -noupdate -label WriteData /regstim/WriteData
add wave -noupdate -label RegWrite /regstim/RegWrite
add wave -noupdate -label clk /regstim/clk
add wave -noupdate -label ReadData1 /regstim/ReadData1
add wave -noupdate -label ReadData2 /regstim/ReadData2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 181
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {966 ps}
