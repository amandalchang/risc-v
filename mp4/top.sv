`include "memory.sv"
`include "immextend.sv"
`include "register_file.sv"
`include "control.sv"

module top (
    input logic clk, 
    output logic LED, 
    output logic RGB_R, 
    output logic RGB_G, 
    output logic RGB_B
);
    localparam [31:0] pc_next = 32'h1000;
    localparam [31:0] pc; // beginning of imem addresses
    localparam [31:0] old_pc = 32'h0;
    localparam [31:0] store_instr = 32'h0;
    localparam [31:0] store_data = 32'h0;
    localparam [31:0] rd1_data = 32'h0;
    localparam [31:0] rd2_data = 32'h0;
    localparam [31:0] alu_reg = 32'h0;


    logic [2:0] funct3 = 3'b010;
    logic dmem_wren = 1'b0;
    logic [31:0] dmem_address = 31'd0;
    logic [31:0] dmem_data_in = 31'd0;
    logic [31:0] dmem_data_out;
    logic [31:0] imem_address = 31'h1000;
    logic [31:0] imem_data_out;

    logic reset;
    logic led;
    logic red;
    logic green;
    logic blue;

    // always_ff @(negedge clk) begin
    //     pc <= pc + 1;
    // end

    always_ff @(posedge clk) begin
        pc <= pc_next;

        if (!adr_src)
            imem_address <= pc;
        else imem_address <= result;
        if (ir_write)
            store_instr <= imem_data_out;
            old_pc <= pc;
        else store_data <= dmem_data_out;

        rd1_data <= rd1
        rd2_data <= rd2

        case alu_src_a:
            2'b00: src_a <= pc;
            2'b01: src_a <= old_pc;
            2'b10: src_a <= rd1_data;
            default:
            $error("Error: Unexpected alu_src_a %b detected!", alu_src_a);
        endcase

        case alu_src_b:
            2'b00: src_b <= rd2_data;
            2'b01: src_b <= imm_ext;
            2'b10: src_b <= 31'h4;
            default:
            $error("Error: Unexpected alu_src_b %b detected!", alu_src_b);
        endcase
        
        alu_reg <= alu_result;

        case result_src:
            2'b00: result <= alu_reg;
            2'b01: result <= store_data;
            2'b10: result <= alu_result;
            default:
            $error("Error: Unexpected result_src %b detected!", result_src);
        endcase

        if (pc_write)
            pc_next <= result;

    end

    memory #(
        .IMEM_INIT_FILE_PREFIX  ("rv32i_test")
    ) u1 (
        .clk            (clk), 
        .funct3         (funct3), 
        .dmem_wren      (mem_write), 
        .dmem_address   (dmem_address), 
        .dmem_data_in   (dmem_data_in), 
        .imem_address   (imem_address), 
        .imem_data_out  (imem_data_out), 
        .dmem_data_out  (dmem_data_out), 
        .reset          (reset), 
        .led            (led), 
        .red            (red), 
        .green          (green), 
        .blue           (blue)
    );

    control u2 (
        .clk             (clk),
        .pc_write        (pc_write),
        .adr_src         (adr_src),
        .mem_write       (mem_write),
        .ir_write        (ir_write),
        .result_src      (result_src),
        .alu_control     (alu_control),
        .alu_src_b       (alu_src_b),
        .alu_src_a       (alu_src_a),
        .imm_src         (imm_src),
        .reg_write       (reg_write)
    );

    register_file u3 (
        .clk             (clk),
        .instr           (instr),
        .write_en_3      (reg_write),
        .write_data_3    (result),
        .rd1             (rd1),
        .rd2             (rd2)
    )

    imm_extend u4 (
        .instr           (instr),
        .imm_src         (imm_src),
        .imm_ext         (imm_ext) // flows to alu_src_b multiplexer
    )

    alu u5 (
        .alu_control       (alu_control),
        .src_a             (src_a),
        .src_b             (src_b),
        .alu_result        (alu_result),
        .zero              (zero),
        .carry             (carry),
        .sign              (sign),
        .overflow          (overflow)
    );

    assign LED = ~led;
    assign RGB_R = ~red;
    assign RGB_G = ~green;
    assign RGB_B = ~blue;
endmodule
