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
11 = passthrough

*/



module ALU_decoder(
    input logic clk,
    input logic [2:0] funct3,
    input logic op_5,
    input logic funct7_5,
    input logic [1:0] alu_op,
    output logic [3:0] alu_control
);

    // ALUControl is 000 for addition, 001 for subtraction, 010 for AND, 011 for OR, and 101 for set less than.
    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam AND = 4'b0010;
    localparam OR = 4'b0011;
    localparam XOR = 4'b1100;
    localparam SLT = 4'b0101; // SET_LESS_THAN
    localparam PASS = 4'b0111;
    localparam SHIFT_RIGHT_LOGIC = 4'b1000;
    localparam SHIFT_RIGHT_ARITH = 4'b1001;
    localparam SHIFT_LEFT = 4'b1010;
    
    always_comb begin
        case (alu_op) // read the ALU opcode
            2'b11: alu_control = PASS;
            2'b00: alu_control = ADD;
            2'b01: alu_control = SUB;
            2'b10: begin
                    case (funct3)
                        3'b000: begin
                            case ({op_5, funct7_5})
                                2'b11: alu_control = SUB;
                                default: alu_control = ADD; // 00, 01, 10
                            endcase
                        end
                        3'b010: alu_control = SLT;
                        3'b110: alu_control = OR;
                        3'b111: alu_control = AND;
                        3'b101: begin
                            if (funct7_5 == 1'b1) begin
                                alu_control = SHIFT_RIGHT_ARITH;
                            end else alu_control = SHIFT_RIGHT_LOGIC;
                        end
                        3'b001: alu_control = SHIFT_LEFT;
                        3'b100: alu_control = XOR;
                        default: alu_control = 4'bxxxx;
                    endcase
                end
            default: alu_control = 4'bxxxx;
        endcase
    end

endmodule