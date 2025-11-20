// ALU decoder - same as single cycle processor

/*
ALU op | funct3 | {op[5], funct7[5]}  ALUControl   Instruction
00     |    x   |        x            000             lw, sw
01     |    x   |        x            001             beq
10     |   000  |    00, 01, 10       000             add
       |   000  |        11           001             sub
       |   010  |        x            101             slt
       |   110  |        x            011             or
       |   111  |        x            010             and

ALU Control
000 = add
001 = subtract
101 = set less than
011 = or
010 = and

ALU op
00 = add
01 = subtract
10 = look at funct3, op[5], funct7[5]

*/

module ALU_decoder(
    input logic clk,
    input [2:0] funct3,
    input logic op_5,
    input logic funct7_5,
    input [1:0] alu_op,
    output [2:0] alu_control
);

    logic [2:0] alu_control = 3'bxxx;

    always_comb begin
        case (alu_op) // read the ALU opcode
            00: alu_control <= 3'b000;
            01: alu_control <= 3'b001;
            10: begin
                    case (funct3)
                        000: begin
                            case ({op_5, funct7_5})
                                11: alu_control <= 3'b000;
                                default: alu_control <= 3'b000; // 00, 01, 10
                            endcase
                        end
                        010: alu_control <= 3'b101;
                        110: alu_control <= 3'b011;
                        111: alu_control <= 3'b010;
                        default: alu_control <= 3'bxxx;
                    endcase
                end
            default: alu_control <= 3'bxxx;
        endcase
    end

endmodule