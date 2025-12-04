// Immediate Extender
//
module imm_extend (
    input [31:0] instr,
    input [2:0] imm_src,
    output [31:0] imm_ext
);
    // 7 bit opcodes decoded
    localparam [2:0] ITYPE = 3'b000;
    localparam [2:0] STYPE = 3'b001;
    localparam [2:0] BTYPE = 3'b010;
    localparam [2:0] JTYPE = 3'b011;
    localparam [2:0] UTYPE = 3'b100;
    localparam [2:0] RTYPE = 3'b111;

    always_comb begin
        case (imm_src) // read the opcode
            ITYPE: imm_ext <= {{20{instr[31]}}, instr[31:20]}; //sign extend imm so it can be added to rs1 to get memory address
            STYPE:  imm_ext <= {{20{instr[31]}}, instr[31:25], instr[11:7]};
            BTYPE:  imm_ext <= {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            JTYPE:  imm_ext <= {{12{instr[31]}}, instr[19:12], instr[11], instr[30:20], 1'b0};
            UTYPE: imm_ext <= {instr[31:12], {12{1'b0}}};
            RTYPE:  imm_ext <= {32{1'b0}};
            default:
        endcase
        $display("%b", imm_ext);
    end

endmodule

// iverilog -g2012 -o immextend.vvp immextend.sv && vvp immextend.vvp