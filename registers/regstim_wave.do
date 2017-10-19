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
add wave -noupdate -radix decimal -childformat {{{/regstim/dut/gprConcat[31]} -radix hexadecimal} {{/regstim/dut/gprConcat[30]} -radix hexadecimal} {{/regstim/dut/gprConcat[29]} -radix hexadecimal} {{/regstim/dut/gprConcat[28]} -radix hexadecimal} {{/regstim/dut/gprConcat[27]} -radix hexadecimal} {{/regstim/dut/gprConcat[26]} -radix hexadecimal} {{/regstim/dut/gprConcat[25]} -radix hexadecimal} {{/regstim/dut/gprConcat[24]} -radix hexadecimal} {{/regstim/dut/gprConcat[23]} -radix hexadecimal} {{/regstim/dut/gprConcat[22]} -radix hexadecimal} {{/regstim/dut/gprConcat[21]} -radix hexadecimal} {{/regstim/dut/gprConcat[20]} -radix hexadecimal} {{/regstim/dut/gprConcat[19]} -radix hexadecimal} {{/regstim/dut/gprConcat[18]} -radix hexadecimal} {{/regstim/dut/gprConcat[17]} -radix hexadecimal} {{/regstim/dut/gprConcat[16]} -radix hexadecimal} {{/regstim/dut/gprConcat[15]} -radix hexadecimal} {{/regstim/dut/gprConcat[14]} -radix hexadecimal} {{/regstim/dut/gprConcat[13]} -radix hexadecimal} {{/regstim/dut/gprConcat[12]} -radix hexadecimal} {{/regstim/dut/gprConcat[11]} -radix hexadecimal} {{/regstim/dut/gprConcat[10]} -radix hexadecimal} {{/regstim/dut/gprConcat[9]} -radix hexadecimal} {{/regstim/dut/gprConcat[8]} -radix hexadecimal} {{/regstim/dut/gprConcat[7]} -radix hexadecimal} {{/regstim/dut/gprConcat[6]} -radix hexadecimal} {{/regstim/dut/gprConcat[5]} -radix hexadecimal} {{/regstim/dut/gprConcat[4]} -radix hexadecimal} {{/regstim/dut/gprConcat[3]} -radix hexadecimal} {{/regstim/dut/gprConcat[2]} -radix hexadecimal} {{/regstim/dut/gprConcat[1]} -radix hexadecimal} {{/regstim/dut/gprConcat[0]} -radix hexadecimal}} -expand -subitemconfig {{/regstim/dut/gprConcat[31]} {-radix hexadecimal} {/regstim/dut/gprConcat[30]} {-radix hexadecimal} {/regstim/dut/gprConcat[29]} {-radix hexadecimal} {/regstim/dut/gprConcat[28]} {-radix hexadecimal} {/regstim/dut/gprConcat[27]} {-radix hexadecimal} {/regstim/dut/gprConcat[26]} {-radix hexadecimal} {/regstim/dut/gprConcat[25]} {-radix hexadecimal} {/regstim/dut/gprConcat[24]} {-radix hexadecimal} {/regstim/dut/gprConcat[23]} {-radix hexadecimal} {/regstim/dut/gprConcat[22]} {-radix hexadecimal} {/regstim/dut/gprConcat[21]} {-radix hexadecimal} {/regstim/dut/gprConcat[20]} {-radix hexadecimal} {/regstim/dut/gprConcat[19]} {-radix hexadecimal} {/regstim/dut/gprConcat[18]} {-radix hexadecimal} {/regstim/dut/gprConcat[17]} {-radix hexadecimal} {/regstim/dut/gprConcat[16]} {-radix hexadecimal} {/regstim/dut/gprConcat[15]} {-radix hexadecimal} {/regstim/dut/gprConcat[14]} {-radix hexadecimal} {/regstim/dut/gprConcat[13]} {-radix hexadecimal} {/regstim/dut/gprConcat[12]} {-radix hexadecimal} {/regstim/dut/gprConcat[11]} {-radix hexadecimal} {/regstim/dut/gprConcat[10]} {-radix hexadecimal} {/regstim/dut/gprConcat[9]} {-radix hexadecimal} {/regstim/dut/gprConcat[8]} {-radix hexadecimal} {/regstim/dut/gprConcat[7]} {-radix hexadecimal} {/regstim/dut/gprConcat[6]} {-radix hexadecimal} {/regstim/dut/gprConcat[5]} {-radix hexadecimal} {/regstim/dut/gprConcat[4]} {-radix hexadecimal} {/regstim/dut/gprConcat[3]} {-radix hexadecimal} {/regstim/dut/gprConcat[2]} {-radix hexadecimal} {/regstim/dut/gprConcat[1]} {-radix hexadecimal} {/regstim/dut/gprConcat[0]} {-radix hexadecimal}} /regstim/dut/gprConcat
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 185
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
