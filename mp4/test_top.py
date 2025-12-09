import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer

STATE_NAMES = {
    0b000: "FETCH",
    0b001: "DECODE",
    0b010: "EXECUTE",
    0b011: "MEMORY",
    0b100: "WRITEBACK"
}

@cocotb.test()
async def test_cpu(dut):
    """Run CPU and print registers every cycle."""
    verbose = True # prints out everything if true, if false only prints regfile
    # line 59 is beq x15 branch true (first time the comparison is 0)
    line = 21 # x15 = 0x8 line 33, right before jal second run
    line = 21 # How many instructions in we are (line*5 = clock cycles)

    def try_hex(val):
        try:
            return hex(val.value)
        except:
            return val.value

    dut.clk.value = 0
    await Timer(83.3, unit="ns")
    clock = Clock(dut.clk, 100, unit="ns")
    cocotb.start_soon(clock.start())
    regfile = dut.register_file.reg_data

    for j in range(line*5):
        await ClockCycles(dut.clk, 1)

        isolated_line = j in range((line - 1) * 5, line * 5) # prints the output of that specific line
        up_to_line = j <= (line*5 - 1) # prints the output of everything up until that command

        if (isolated_line): # Change what's in here to pick out what you're printing to
            state_val = int(dut.control.current_state.value)
            state_name = STATE_NAMES.get(state_val, "UNKNOWN")
            print(f"\n\n=========== FSM: {state_name} ==========")
            # ------ Register file always printed ------
            print(f"\n------ Cycle {j} ------")
            for i in range(32):
                try:
                    print(f"Register {i}: {hex(regfile.value[i])}")
                except:
                    print(f"Register {i}: {regfile.value[i]}")

            # ------ Optional verbose prints ------
            if verbose: 
                print(f"\n------ Mux Selects ------")
                print(f"adr_src: {dut.control.adr_src.value}")
                print(f"result src: {dut.control.result_src.value}") 

                print(f"\n------ PC Signals & Vals ------")
                print(f"pc write: {dut.control.pc_write.value}")
                print(f"pc: {try_hex(dut.pc)}")
                print(f"old pc: {try_hex(dut.old_pc)}")
                print(f"pc next: {try_hex(dut.pc_next)}") 

                print(f"\n------ IMEM/DMEM ------")            
                print(f"ir_write: {dut.control.ir_write.value}")
                print(f"mem write: {dut.mem_write.value}")                
                print(f"imem_address: {try_hex(dut.imem_address)}")            
                print(f"dmem_address: {try_hex(dut.dmem_address)}")
                print(f"imem/dmem WD: {try_hex(dut.rd2_data)}")
                print(f"imem data out: {try_hex(dut.imem_data_out)}")
                print(f"store instr: {try_hex(dut.store_instr)}")
                print(f"dmem data out: {try_hex(dut.dmem_data_out)}") 
                
                print(f"\n------ ALU Signals & Vals ------")            
                print(f"alu op: {dut.control.ALU_decoder.alu_op.value}")            
                print(f"alu result wide: {dut.alu.wide_result.value}")
                print(f"alu result: {try_hex(dut.alu_result)}")
                print(f"alu control: {dut.alu.alu_control.value}")            
                print(f"alu src a: {dut.control.alu_src_a.value}")
                print(f"alu src b: {dut.control.alu_src_b.value}")
                print(f"src a: {try_hex(dut.src_a)}")
                print(f"src b: {try_hex(dut.src_b)}")
            
                print(f"\n------ Immediate Extend ------")
                print(f"imm_src: {dut.imm_src.value}")
                print(f"imm ext: {try_hex(dut.imm_ext)}")            

                print(f"\n------ Reg File ------")
                print(f"reg write: {dut.reg_write.value}")  
                print(f"rd: {dut.register_file.a3.value}")   
                print(f"result (WD3): {try_hex(dut.result)}")

                print(f"\n------ Branch Flags ------")
                print(f"branch: {dut.control.branch.value}")
                print(f"zero: {dut.zero.value}")
                print(f"carry: {dut.carry.value}")
                print(f"negative: {dut.negative.value}")
                print(f"overflow: {dut.overflow.value}")
                
                print(f"\n------ DMEM Last Word ------")
                # Print the last four bytes of dmem for store/load testing
                dmem_ffc = [
                    hex(dut.memory.dmem0.memory[0b1111111111].value),
                    hex(dut.memory.dmem1.memory[0b1111111111].value),
                    hex(dut.memory.dmem2.memory[0b1111111111].value),
                    hex(dut.memory.dmem3.memory[0b1111111111].value),
                ]
                print(f"data memory 0xffc: {dmem_ffc}\n")