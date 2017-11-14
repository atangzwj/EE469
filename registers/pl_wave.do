onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipelineRegs_testbench/clk
add wave -noupdate /pipelineRegs_testbench/reset
add wave -noupdate -group {Output Control} /pipelineRegs_testbench/MemToReg
add wave -noupdate -group {Output Control} /pipelineRegs_testbench/RegWrite
add wave -noupdate -group {Output Control} /pipelineRegs_testbench/MemWrite
add wave -noupdate -group {Output Control} /pipelineRegs_testbench/MemRead
add wave -noupdate -group {Output Control} /pipelineRegs_testbench/xferByte
add wave -noupdate -group {Output Control} /pipelineRegs_testbench/ALUOp
add wave -noupdate -group Stages /pipelineRegs_testbench/dut/stage1
add wave -noupdate -group Stages /pipelineRegs_testbench/dut/stage2
add wave -noupdate -group Stages /pipelineRegs_testbench/dut/stage2b
add wave -noupdate -group Stages /pipelineRegs_testbench/dut/stage3
add wave -noupdate -group Stages /pipelineRegs_testbench/dut/stage4
add wave -noupdate -group {Input Control} /pipelineRegs_testbench/MemToReg_0
add wave -noupdate -group {Input Control} /pipelineRegs_testbench/RegWrite_0
add wave -noupdate -group {Input Control} /pipelineRegs_testbench/MemWrite_0
add wave -noupdate -group {Input Control} /pipelineRegs_testbench/MemRead_0
add wave -noupdate -group {Input Control} /pipelineRegs_testbench/xferByte_0
add wave -noupdate -group {Input Control} /pipelineRegs_testbench/ALUOp_0
add wave -noupdate -group {Output Data} /pipelineRegs_testbench/Db_ALU
add wave -noupdate -group {Output Data} /pipelineRegs_testbench/Da
add wave -noupdate -group {Output Data} /pipelineRegs_testbench/Db
add wave -noupdate -group {Output Data} /pipelineRegs_testbench/ALU_out
add wave -noupdate -group {Output Data} /pipelineRegs_testbench/Dw
add wave -noupdate -group {Output Data} /pipelineRegs_testbench/Rd
add wave -noupdate -group {Input Data} /pipelineRegs_testbench/Db_ALU_0
add wave -noupdate -group {Input Data} /pipelineRegs_testbench/Da_0
add wave -noupdate -group {Input Data} /pipelineRegs_testbench/Db_0
add wave -noupdate -group {Input Data} /pipelineRegs_testbench/ALU_out_0
add wave -noupdate -group {Input Data} /pipelineRegs_testbench/Dw_0
add wave -noupdate -group {Input Data} /pipelineRegs_testbench/Rd_0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22953 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 346
configure wave -valuecolwidth 71
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {23040 ps} {153958 ps}
