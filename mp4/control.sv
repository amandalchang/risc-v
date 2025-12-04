// Control Unit
// given the op code, funct3, and funct7, outputs control signals to the rest of the processor

`include "alu_decoder.sv"
`include "instr_decoder.sv"


module control(
    output logic    pc_write,
    output logic    adr_src,
    output logic    mem_write,
    output logic    ir_write,
    input logic     clk,
    input [31:0]    instr,
    input logic     zero,
    input logic     carry,
    input logic     sign,
    input logic     overflow,
    output logic    [1:0] result_src,
    output logic    [2:0] alu_control,
    output logic    [1:0] alu_src_b,
    output logic    [1:0] alu_src_a,
    output logic    [1:0] imm_src,
    output logic    reg_write
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    logic pc_update = 1'b0;
    logic branch = 1'b0;
    logic [1:0] alu_op;
    // State variables; naming is defined by starting color
    localparam [2:0] FETCH = 3'b000;
    localparam [2:0] DECODE = 3'b001;

    localparam [2:0] EXECUTE = 3'b010;
    localparam [6:0] MEMADR = 7'b0_00011;
    localparam [6:0] EXECUTE_R = 7'b0110011;
    localparam [6:0] EXECUTE_L = 7'b0010011;
    localparam [6:0] JAL = 7'b1101111;
    localparam [6:0] BRANCH = 7'b1100011;

    localparam [2:0] MEMORY = 3'b011;
    localparam [6:0] MEMREAD = 7'b0000011;
    localparam [6:0] MEMWRITE = 7'b0100011;
    // localparam [6:0] ALUWB = 
    // 1100011 Non ALUWB codes
    // 0000011
    // 0100011
    
    // 0110011 These are the ALUWB codes
    // 0010011
    // 1101111

    localparam [2:0] WRITE_BACK = 3'b100;
    localparam [6:0] MEMWB = MEMREAD;
    
    // Declare state variables
    logic [2:0] current_state = FETCH;

    // Thus, the N (Negative) flag is connected to the most significant bit of the ALU output, Result31. 
// The Z (Zero) flag is asserted when all of the bits of Result are 0, as detected by the N-bit NOR gate in Figure 5.17. 
// The C (Carry out) flag is asserted when the adder produces a carry out
//          and the ALU is performing addition or subtraction (indicated by ALUControl1 = 0).
// logic zero;
// logic carry;
// logic sign;
// WHEN THESE 3 THINGS ARE TRUE
// (1) the ALU is performing addition or subtraction (ALUControl1 = 0)
// (2) A and Sum have opposite signs, as detected by the XOR gate
// (3) overflow is possible. That is, as detected by the XNOR gate, either A and B have the same sign 
//          and the adder is performing addition (ALUControl0 = 0) or A and B have opposite signs 
//          and the adder is performing subtraction (ALUControl0 = 1). 
    

    always_comb begin
        if (pc_update) begin
            pc_write = 1'b1;
        end
        else if (branch) begin
            case (funct3)
                3'b000: pc_write = zero; // BEQ
                3'b001: pc_write = !zero; // BNEQ
                3'b100: pc_write = overflow ? ~sign: sign; // BLT
                3'b101: pc_write = overflow ? sign: ~sign; // BGE
                3'b110: pc_write = carry; // BLTU
                3'b111: pc_write = !carry; // BGEU
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == WRITE_BACK) begin
            current_state <= FETCH;
        end else begin
            current_state <= current_state + 1'b1;
        end
    end

    always_comb begin
        // if it's time to increment
        case (current_state) // increment based on state
            FETCH: begin
                // reset enables
                reg_write <= 1'b0;
                mem_write <= 1'b0;
                branch <= 1'b0;
                // state logic
                adr_src <= 1'b0;
                ir_write <= 1'b1;
                alu_src_a <= 2'b00; // pc
                alu_src_b <= 2'b10; // 4
                alu_op <= 2'b00; // ADD
                result_src <= 2'b10; // from ALUResult
                pc_update <= 1'b1; // prep for jump/branch
            end
            DECODE: begin
                // reset enables
                ir_write <= 1'b0;
                pc_update <= 1'b0;
                // state logic
                alu_src_a <= 2'b01;
                alu_src_b <= 2'b01;
                alu_op <= 2'b00;
            end
            EXECUTE: begin
                case(opcode)
                    MEMADR: begin
                        // state logic
                        alu_src_a <= 2'b10;
                        alu_src_b <= 2'b01;
                        alu_op <= 2'b00;
                    end
                    EXECUTE_R: begin
                        // state logic
                        alu_src_a <= 2'b10;
                        alu_src_b <= 2'b00;
                        alu_op <= 2'b10;
                    end
                    EXECUTE_L: begin
                        // state logic
                        alu_src_a <= 2'b10;
                        alu_src_b <= 2'b01;
                        alu_op <= 2'b10;
                    end
                    JAL: begin
                        // state logic
                        alu_src_a <= 2'b01;
                        alu_src_b <= 2'b10;
                        alu_op <= 2'b00;
                        result_src <= 2'b00;
                        pc_update <= 1'b1;
                    end
                    BRANCH: begin
                        // state logic
                        alu_src_a <= 2'b10;
                        alu_src_b <= 2'b00;
                        alu_op <= 2'b01;
                        result_src <= 2'b00;
                        branch <= 1'b1;
                    end
                endcase
            end
            MEMORY: begin
                case(opcode)
                    MEMREAD: begin
                        result_src <= 2'b00;
                        adr_src <= 1'b1;
                    end
                    MEMWRITE: begin
                        result_src <= 2'b00;
                        adr_src <= 1'b1;
                        mem_write <= 1'b1;
                    end
                    EXECUTE_R, EXECUTE_L, JAL: begin // ALUWB
                        result_src <= 2'b00;
                        reg_write <= 1'b1;
                    end
                endcase
            end
            WRITE_BACK: begin
                case(opcode)
                    MEMWB: begin
                        result_src <= 2'b01;
                        reg_write <= 1'b1;
                    end
                    default: begin
                        // do nothing
                    end
                endcase
            end
        endcase
    end

    ALU_decoder u0 (
        .clk            (clk), 
        .funct3         (funct3),
        .op_5           (opcode[5]),
        .funct7_5       (funct7[5]),
        .alu_op         (alu_op),
        .alu_control    (alu_control)

    );

    instruction_decoder u1 (
        .clk            (clk), 
        .op             (opcode),
        .imm_src        (imm_src)
    );

endmodule