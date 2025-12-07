// Immediate Extender
//
module imm_extend (
    input logic [31:0] instr,
    input logic [2:0] imm_src,
    output logic [31:0] imm_ext
);
    // 7 bit opcodes decoded
    localparam [2:0] ITYPE = 3'b000;
    localparam [2:0] STYPE = 3'b001;
    localparam [2:0] BTYPE = 3'b010;
    localparam [2:0] JTYPE = 3'b011;
    localparam [2:0] UTYPE = 3'b100;

    // initializing precomputed wires for continuous assignment
    wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
    wire [31:0] imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};
    wire [31:0] imm_b = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
    wire [31:0] imm_j = {{12{instr[31]}}, instr[19:12], instr[11], instr[30:20], 1'b0};
    wire [31:0] imm_u = {instr[31:12], 12'b0};

    // select immediate using continuous assignment
    assign imm_ext = (imm_src == ITYPE) ? imm_i :
                     (imm_src == STYPE) ? imm_s :
                     (imm_src == BTYPE) ? imm_b :
                     (imm_src == JTYPE) ? imm_j :
                     (imm_src == UTYPE) ? imm_u :
                     32'b0;  // default for RTYPE or unknown

endmodule

// iverilog -g2012 -o immextend.vvp immextend.sv && vvp immextend.vvp