import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer
import random

@cocotb.test()
async def test_cpu(dut):
    """Run CPU and print registers every cycle."""

    dut.clk.value = 0
    await Timer(83.3, unit="ns")
    clock = Clock(dut.clk, 100, unit="ns")
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

    for j in range(3):
        await ClockCycles(dut.clk, 1)

        for i in range(3):
            print(f"Register {i}: {regfile.value[i]}")
        print("\n")
        
        print(f"branch: {dut.control.branch.value}")
        print(f"src a: {dut.src_a.value}")
        print(f"src b: {dut.src_b.value}")
        print(f"adr_src: {dut.control.adr_src.value}")
        print(f"ir_write: {dut.control.ir_write.value}")
        print(f"alu src a: {dut.control.alu_src_a.value}")
        print(f"alu src b: {dut.control.alu_src_b.value}")
        print(f"alu op: {dut.control.ALU_decoder.alu_op.value}")
        print(f"alu control: {dut.control.ALU_decoder.alu_control.value}")
        print(f"alu result wide: {dut.alu.wide_result.value}")
        print(f"alu result: {dut.alu_result.value}")
        print(f"result src: {dut.control.result_src.value}")
        print(f"pc write: {dut.control.pc_write.value}")
        print(f"{dut.pc.value} pc")
        print(f"{dut.old_pc.value} old pc")
        print(f"{dut.pc_next.value} pc next")
        print(f"imem_address: {dut.imem_address.value}")
        print(f"reg_file instr: {dut.register_file.instr.value}")
        print(f"reg write: {dut.reg_write.value}")
        print(f"result (aka WD3): {dut.result.value}")
        print(f"Rd: {dut.register_file.a3.value}")
        print(f"FSM state: {dut.control.current_state.value}\n")