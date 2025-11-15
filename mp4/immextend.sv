module extend (
    input [31:0] instr,
    output [31:0] imm_ext
);
    // 7 bit opcodes decoded
    localparam [6:0] UTYPE  = 7'b0110111;
    localparam [6:0] ITYPEL = 7'b0010011;
    localparam [6:0] ITYPEA = 7'b0000011;
    localparam [6:0] STYPE  = 7'b0100011;
    localparam [6:0] BTYPE  = 7'b1100011;
    localparam [6:0] JTYPE  = 7'b1101111;
    localparam [6:0] RTYPE  = 7'b0110011;

    always_comb begin
        case (instr[6:0]) // read the opcode
            UTYPE: imm_ext <= {instr[31:12], {12{1'b0}}};
            ITYPEL: imm_ext <= {{20{instr[31]}}, instr[31:20]};
            ITYPEA: imm_ext <= {{27{1'b0}}, instr[24:20]};
            STYPE:  imm_ext <= {{20{instr[31]}}, instr[31:25], instr[11:7]};
            BTYPE:  imm_ext <= {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            JTYPE:  imm_ext <= {{12{instr[31]}}, instr[19:12], instr[11], instr[30:20], 1'b0};
            RTYPE:  imm_ext <= {32{1'b0}};
            default:
        endcase
        $display("%b", imm_ext);
    end

endmodule

// iverilog -g2012 -o immextend.vvp immextend.sv && vvp immextend.vvp