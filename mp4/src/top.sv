`include "./src/memory.sv"
`include "./src/immextend.sv"
`include "./src/register_file.sv"
`include "./src/control_module/control.sv"
`include "./src/alu.sv"

module top (
    input logic clk, 
    output logic LED, 
    output logic RGB_R, 
    output logic RGB_G, 
    output logic RGB_B
);
    logic [31:0] pc_next = 32'h1004;
    logic [31:0] pc = 32'h1000;
    logic [31:0] old_pc = 32'd0;
    logic [31:0] store_instr = 32'd0;
    logic [31:0] dmem_data_out;
    logic [31:0] rd1_data = 32'd0;
    logic [31:0] rd2_data = 32'd0;
    logic [31:0] alu_reg = 32'd0;


    logic [2:0] funct3 = 3'b010;
    logic dmem_wren = 1'b0;
    logic [31:0] dmem_address = 32'd0;
    logic [31:0] imem_address = 32'h1000;
    logic [31:0] imem_data_out;

    logic reset;
    logic led;
    logic red;
    logic green;
    logic blue;

    // submodule output variable declarations
    logic [31:0] src_a;
    logic [31:0] src_b;
    logic [1:0] result_src;
    logic [3:0] alu_control;
    logic [1:0] alu_src_a;
    logic [1:0] alu_src_b;
    logic [2:0] imm_src;
    logic [31:0] result;
    logic [31:0] rd1;
    logic [31:0] rd2;
    logic [31:0] imm_ext;
    logic [31:0] alu_result;
    logic pc_write;
    logic reg_write;

    memory #(
        .IMEM_INIT_FILE_PREFIX  ("assembly_test/rv32i_test")
    ) memory (
        .clk            (clk), 
        .funct3         (store_instr[14:12]), 
        .dmem_wren      (mem_write), 
        .dmem_address   (dmem_address), 
        .dmem_data_in   (rd2_data), 
        .imem_address   (imem_address), 
        .imem_data_out  (imem_data_out), 
        .dmem_data_out  (dmem_data_out), 
        .reset          (reset), 
        .led            (led), 
        .red            (red), 
        .green          (green), 
        .blue           (blue)
    );

    control control (
        .clk             (clk),
        .pc_write        (pc_write),
        .adr_src         (adr_src),
        .mem_write       (mem_write),
        .ir_write        (ir_write),
        .instr           (store_instr),
        .zero            (zero),
        .carry           (carry),
        .negative        (negative),
        .overflow        (overflow),
        .result_src      (result_src),
        .alu_control     (alu_control),
        .alu_src_b       (alu_src_b),
        .alu_src_a       (alu_src_a),
        .imm_src         (imm_src),
        .reg_write       (reg_write)
    );

    register_file register_file (
        .clk             (clk),
        .instr           (store_instr),
        .write_en_3      (reg_write),
        .write_data_3    (result),
        .rd1             (rd1),
        .rd2             (rd2)
    );

    imm_extend imm_extend (
        .instr           (store_instr),
        .imm_src         (imm_src),
        .imm_ext         (imm_ext) // flows to alu_src_b multiplexer
    );

    alu alu (
        .alu_control       (alu_control),
        .src_a             (src_a),
        .src_b             (src_b),
        .alu_result        (alu_result),
        .zero              (zero),
        .carry             (carry),
        .negative          (negative),
        .overflow          (overflow)
    );

    always_ff @(posedge clk) begin // registers
        pc <= pc_next;

        rd1_data <= rd1;
        rd2_data <= rd2;

        if (ir_write) begin
            store_instr <= imem_data_out;
            old_pc <= pc;
        end

        alu_reg <= alu_result;

        if (pc_write)
            pc_next <= result;

    end

    always_comb begin
        case (alu_src_a)
            2'b00: src_a = pc;
            2'b01: src_a = old_pc;
            2'b10: src_a = rd1_data;
        endcase

        case (alu_src_b)
            2'b00: src_b = rd2_data;
            2'b01: src_b = imm_ext;
            2'b10: src_b = 31'h4;
        endcase

        case (result_src)
            2'b00: result = alu_reg;
            2'b01: result = dmem_data_out;
            2'b10: result = alu_result;
        endcase

        imem_address <= pc;

        // data memory uses ALU result when adr_src = 1
        if (adr_src)
            dmem_address <= result;

    end


    assign LED = ~led;
    assign RGB_R = ~red;
    assign RGB_G = ~green;
    assign RGB_B = ~blue;
endmodule
