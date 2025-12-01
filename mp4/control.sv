// Control Unit
// given the op code, funct3, and funct7, outputs control signals to the rest of the processor

`include "alu_decoder.sv"
`include "instr_decoder.sv"


module control(
    output logic    pc_write,
    output logic    adr_src,
    output logic    mem_write,
    output logic    ir_write
    input [31:0]    instr,
    input logic     zero,
    output logic    [1:0] result_src,
    output logic    [2:0] alu_control,
    output logic    [1:0] alu_src_b,
    output logic    [1:0] alu_src_a,
    output logic    [1:0] imm_src,
    output logic    [1:0] reg_write
);

    logic pc_update = 1'b0;
    logic branch = 1'b0;
    // State variables; naming is defined by starting color
    localparam [3:0] FETCH = 4'b0000;
    localparam [3:0] DECODE = 4'b0001;
    localparam [3:0] MEMADR = 4'b0010;
    localparam [3:0] EXECUTE_R = 4'b0100;
    localparam [3:0] EXECUTE_L = 4'b0101;
    localparam [3:0] BRANCH = 4'b0111;
    localparam [3:0] JAL = 4'b1000;
    localparam [3:0] MEMREAD = 4'b0011;
    localparam [3:0] MEMWRITE = 4'b1001;
    localparam [3:0] ALUWB = 4'b0110;
    localparam [3:0] MEMWB = 4'b1010;

    localparam [1:0] A_PC = 2'b00;
    localparam [1:0] 
    
    // Declare state variables
    logic [3:0] current_state = FETCH;

    always_ff @(posedge clk) begin
        // if it's time to increment
        case (current_state) // increment based on state
            FETCH: begin
                // reset enables
                reg_write = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                // state logic
                adr_src = 1'b0;
                ir_write = 1'b1;
                alu_src_a = 2'b00; // pc
                alu_src_b = 2'b10; // 4
                alu_op = 2'b00; // ADD
                result_src = 2'b10; // from ALUResult
                pc_update = 1'b1; // prep for jump/branch
            end
            DECODE: begin
                // reset enables
                ir_write = 1'b0;
                pc_update = 1'b0;
                // state logic
                alu_src_a = 2'b01;
                alu_src_b = 2'b01;
                alu_op = 2'b00;
            end
            EXECUTE: begin
            case(opcode)
                MEMADR: begin
                    // state logic
                    alu_src_a = 2'b10;
                    alu_src_b = 2'b01;
                    alu_op = 2'b00;
                end
                EXECUTE_R: begin
                    // state logic
                    alu_src_a = 2'b10;
                    alu_src_b = 2'b00;
                    alu_op = 2'b10;
                end
                EXECUTE_L: begin
                    // state logic
                    alu_src_a = 2'b10;
                    alu_src_b = 2'b01;
                    alu_op = 2'b10;
                end
                JAL: begin
                    // state logic
                    alu_src_a = 2'b01;
                    alu_src_b = 2'b10;
                    alu_op = 2'b00;
                    result_src = 2'b00;
                    pc_update = 1'b1;
                end
                BRANCH: begin
                    // state logic
                    alu_src_a = 2'b10;
                    alu_src_b = 2'b00;
                    alu_op = 2'b01;
                    result_src = 2'b00;
                    branch = 1'b1;
                end
            endcase
            end
            READ_WRITE: begin
            case(opcode)
                MEMREAD: begin
                    result_src = 2'b00;
                    adr_src = 1'b1;
                end
                MEMWRITE: begin
                    result_src = 2'b00;
                    adr_src = 1'b1;
                    mem_write = 1'b1;
                end
                ALUWB: begin
                    result_src = 2'b00;
                    reg_write = 1'b1;
                end
            endcase
            end
            REG_WRITE: begin
            case(opcode)
                MEMWB:
                    result_src = 2'b01;
                    reg_write = 1'b1;
                default:
                    continue
            endcase
            end

        endcase
    end

endmodule

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