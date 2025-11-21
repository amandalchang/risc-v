// Control Unit
// given the op code, funct3, and funct7, outputs control signals to the rest of the processor

`include "alu_decoder.sv"
`include "instr_decoder.sv"


module control(
    output logic pc_write,
    output logic adr_src,
    output logic mem_write,
    output logic ir_write
    input [31:0] instr,
    input logic zero,
    output [1:0] result_src,
    output [2:0] alu_control,
    output [1:0] alu_src_b,
    output [1:0] alu_src_a,
    output [1:0] imm_src,
    output logic reg_write
);
    // State variables; naming is defined by starting color
    localparam [3:0] FETCH = 4'b0000;
    localparam [3:0] DECODE = 4'b0001;
    localparam [3:0] MEMADR = 4'b0010;
    localparam [3:0] MEMREAD = 4'b0011;
    localparam [3:0] EXECUTE_R = 4'b0100;
    localparam [3:0] EXECUTE_L = 4'b0101;
    localparam [3:0] ALUWB = 4'b0110;
    localparam [3:0] BRANCH = 4'b0111;
    localparam [3:0] JAL = 4'b1000;
    
    // Declare state variables
    localparam [3:0] current_state = FETCH;

    ALU_decoder u0 (
        .clk            (clk), 
        .funct3         (),
        .op_5           (),
        .funct7_5       (),
        .alu_op         (),
        .alu_control    ()

    );

    instruction_decoder u1 (
        .clk            (clk), 
        .op             (),
        .immsrc         ()
    );
    
endmodule