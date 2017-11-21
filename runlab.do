# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

#Registers
vlog "./registers/register.sv"
vlog "./registers/regfile.sv"
vlog "./registers/pipelineRegs.sv"
vlog "./D_FF.sv"

#Decoders
vlog "./decoders/decoder2_4.sv"
vlog "./decoders/decoder3_8.sv"
vlog "./decoders/decoder5_32.sv"

#Muxes
vlog "./muxes/mux2_1.sv"
vlog "./muxes/mux4_1.sv"
vlog "./muxes/mux8_1.sv"
vlog "./muxes/mux16_1.sv"
vlog "./muxes/mux32_1.sv"
vlog "./muxes/mux64x32_64.sv"

#ALU
vlog "./alu/alu_1bit.sv"
vlog "./alu/alu.sv"
vlog "./alu/adders/adder_full.sv"
vlog "./alu/adders/adder_half.sv"

#CPU building blocks
vlog "./CPU/main_control.sv"
vlog "./CPU/datapath.sv"
vlog "./CPU/datapath_testbench.sv"
vlog "./CPU/memory/instructmem.sv"
vlog "./CPU/memory/datamem.sv"
vlog "./CPU/selectdata.sv"
vlog "./CPU/math.sv"

#CPU
vlog "./CPU/CPU_64.sv"
vlog "./CPU/CPU_64_testbench.sv"
vlog "./CPU/forwardingUnit.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work CPU_64_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.

do CPU/cpu_wave.do


# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
