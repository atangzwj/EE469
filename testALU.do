# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./registers/regstim.sv"
vlog "./registers/regfile.sv"
vlog "./registers/reg64.sv"
vlog "./D_FF.sv"

vlog "./decoders/decoder2_4.sv"
vlog "./decoders/decoder3_8.sv"
vlog "./decoders/decoder5_32.sv"

vlog "./muxes/mux2_1.sv"
vlog "./muxes/mux4_1.sv"
vlog "./muxes/mux8_1.sv"
vlog "./muxes/mux16_1.sv"
vlog "./muxes/mux32_1.sv"
vlog "./muxes/mux64x32_64.sv"

vlog "./alu/alustim.sv"
vlog "./alu/alu_1bit.sv"
vlog "./alu/alu.sv"
vlog "./alu/adders/adder_full.sv"
vlog "./alu/adders/adder_half.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
#vsim -voptargs="+acc" -t 1ps -lib work regstim
vsim -voptargs="+acc" -t 1ps -lib work alustim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.

#do registers/regstim_wave.do
do alu/alustim_wave.do


# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
