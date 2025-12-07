
# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Always force a rebuild of the simulation binary
SIM_BUILD := sim_build_$(shell date +%s)

VERILOG_SOURCES += top.sv
# use VHDL_SOURCES for VHDL files

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = top

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = test_top

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

reset:
	rm -rf sim_build* __pycache__ *.vcd *.fst *.xml results.xml
