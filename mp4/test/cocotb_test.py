# test file example from cocotb quickstart

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def two_clk_cycles(dut):
    """Try accessing the design."""

    for _ in range(2):
        dut.clk.value = 0
        await Timer(1, unit="ns")
        dut.clk.value = 1
        await Timer(1, unit="ns")

    cocotb.log.info("current state is %s", dut.current_state.value)
    assert dut.current_state.value == 0b001
