import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer
import random

@cocotb.test()
async def test_cpu(dut):
    """Run CPU and print registers every cycle."""

    dut.clk.value = 0
    await Timer(83.3, unit="ns")
    clock = Clock(dut.clk, 83.3, unit="ns")
    cocotb.start_soon(clock.start())
    regfile = dut.register_file.reg_data
    pc_enable = dut.pc_write
    x1 = regfile[1]
    x2 = regfile[2]
    dmem = [
        dut.memory.dmem0.memory.value,
        dut.memory.dmem1.memory.value,
        dut.memory.dmem2.memory.value,
        dut.memory.dmem3.memory.value,
    ]
    pc = dut.pc


    await ClockCycles(dut.clk, 370)

    for i in range(32):
        print(f"Register {i}: {regfile.value[i]}")