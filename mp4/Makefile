
# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += top.sv
# use VHDL_SOURCES for VHDL files

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = top

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = test_top

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim





# filename = top
# pcf_file = ../common/iceBlinkPico.pcf

# build:
# 	yosys -p "synth_ice40 -top top -json $(filename).json" $(filename).sv
# 	nextpnr-ice40 --up5k --package sg48 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc
# 	icepack $(filename).asc $(filename).bin

# prog: #for sram
# 	dfu-util --device 1d50:6146 --alt 0 -D $(filename).bin -R

# clean:
# 	rm -rf $(filename).blif $(filename).asc $(filename).json $(filename).bin

# test:
# 	iverilog -g2012 -o $(testbench_filename) $(testbench_filename)_tb.sv && vvp $(testbench_filename) && gtkwave $(testbench_filename).vcd wave_style.gtkw

# show:
# 	gtkwave $(testbench_filename).vcd