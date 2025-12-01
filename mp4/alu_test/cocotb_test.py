"""
test ALU module

input logic [2:0] alu_control,
input logic [31:0] src_a,
input logic [31:0]] src_b,
output logic [31:0] alu_result,
output logic zero,
output logic carry,
output logic sign,
output logic overflow
"""

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_alu_add(dut):
    """Try accessing the design."""

    dut.alu_control.value = 0b000
    dut.src_a.value = 2
    dut.src_b.value = 3

    # IMPORTANT: allow signals to propagate
    await Timer(1, units="ns")

    cocotb.log.info("alu_control: %s", dut.alu_control.value)
    cocotb.log.info("2 + 3 = %s", int(str(dut.alu_result.value), 2))
    cocotb.log.info(
        "Zero: %s, Carry: %s, Sign: %s, Overflow: %s",
        dut.zero.value,
        dut.carry.value,
        dut.sign.value,
        dut.overflow.value,
    )


@cocotb.test()
async def test_alu_sub_pos(dut):
    """Test ALU subtraction function with 2 positive values that result in a positive number."""

    dut.alu_control.value = 0b001
    dut.src_a.value = 5
    dut.src_b.value = 3

    # IMPORTANT: allow signals to propagate
    await Timer(1, units="ns")

    cocotb.log.info("alu_control: %s", dut.alu_control.value)
    cocotb.log.info(
        "5 - 3 = %s", dut.alu_result.value
    )  # int(str(dut.alu_result.value), 2)
    cocotb.log.info(
        "Zero: %s, Carry: %s, Sign: %s, Overflow: %s",
        dut.zero.value,
        dut.carry.value,
        dut.sign.value,
        dut.overflow.value,
    )


@cocotb.test()
async def test_alu_sub_neg(dut):
    """Test ALU subtraction function with 2 positive values that result in a negative number."""

    dut.alu_control.value = 0b001
    dut.src_a.value = 2
    dut.src_b.value = 3

    # IMPORTANT: allow signals to propagate
    await Timer(1, units="ns")

    cocotb.log.info("alu_control: %s", dut.alu_control.value)
    cocotb.log.info(
        "2 - 3 = %s", dut.alu_result.value
    )  # int(str(dut.alu_result.value), 2)
    cocotb.log.info(
        "Zero: %s, Carry: %s, Sign: %s, Overflow: %s",
        dut.zero.value,
        dut.carry.value,
        dut.sign.value,
        dut.overflow.value,
    )


@cocotb.test()
async def test_alu_and(dut):
    """Test ALU and function."""

    dut.alu_control.value = 0b010
    dut.src_a.value = 2
    dut.src_b.value = 3

    # IMPORTANT: allow signals to propagate
    await Timer(1, units="ns")

    cocotb.log.info("alu_control: %s", dut.alu_control.value)
    cocotb.log.info("2 & 3 = %s", dut.alu_result.value)
    cocotb.log.info(
        "Zero: %s, Carry: %s, Sign: %s, Overflow: %s",
        dut.zero.value,
        dut.carry.value,
        dut.sign.value,
        dut.overflow.value,
    )


@cocotb.test()
async def test_alu_or(dut):
    """Test ALU and function."""

    dut.alu_control.value = 0b011
    dut.src_a.value = 0
    dut.src_b.value = 0

    # IMPORTANT: allow signals to propagate
    await Timer(1, units="ns")

    cocotb.log.info("alu_control: %s", dut.alu_control.value)
    cocotb.log.info("2 | 3 = %s", dut.alu_result.value)
    cocotb.log.info(
        "Zero: %s, Carry: %s, Sign: %s, Overflow: %s",
        dut.zero.value,
        dut.carry.value,
        dut.sign.value,
        dut.overflow.value,
    )
