/* ALU module

References
- harris and harris pg402
- harris and harris pg250 alu design, and TABLE 5.3

*/

module alu(
    input logic [3:0] alu_control,
    input logic [31:0] src_a,
    input logic [31:0] src_b,
    output logic [31:0] alu_result,
    output logic zero,
    output logic carry,
    output logic sign,
    output logic overflow
);

// ALUControl is 000 for addition, 001 for subtraction, 010 for AND, 011 for OR, and 101 for set less than.
localparam ADD = 4'b0000;
localparam SUB = 4'b0001;
localparam AND = 4'b0010;
localparam OR = 4'b0011;
localparam XOR = 4'b1100;
localparam SLT = 4'b0101; // SET_LESS_THAN
localparam SLTU = 4'b1101;
localparam PASS = 4'b0111;
localparam SHIFT_RIGHT_LOGIC = 4'b1000;
localparam SHIFT_RIGHT_ARITH = 4'b1001;
localparam SHIFT_LEFT = 4'b1010;

// logic [31:0] alu_result;
logic [32:0] wide_result;
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
logic overflow_possible;
// logic overflow;

always_comb begin
    alu_result = 32'b0;
    wide_result = 33'b0;
    case (alu_control)
        ADD: begin
                wide_result = {1'b0, src_a} + {1'b0, src_b};
                alu_result = wide_result[31:0];
            end
        SUB: begin
                wide_result = {1'b0, src_a} - {1'b0, src_b};
                alu_result = wide_result[31:0];
            end
        AND: 
            alu_result = (src_a & src_b);
        OR:
            alu_result = (src_a | src_b);
        SLT:
            alu_result = ($signed(src_a) < $signed(src_b));
        SLTU:
            alu_result = (src_a < src_b); // HELP
        PASS:
            alu_result = src_b;
        XOR:
            alu_result = src_a ^ src_b;
        SHIFT_RIGHT_LOGIC:
            alu_result = (src_a >> src_b);
        SHIFT_RIGHT_ARITH:
            alu_result = $signed(src_a) >>> (src_b & 5'b11111);
        SHIFT_LEFT:
            alu_result = (src_a << src_b);
        default: alu_result = 32'hXXXXXXXX;
    endcase

    overflow_possible = (((src_a[31] == src_b[31]) & alu_control == ADD) | ((src_a[31] != src_b[31]) & alu_control == SUB));

    zero = (alu_result == 32'b0);
    carry = ((alu_control == (ADD | SUB)) & (wide_result[32] == 1));
    sign = (alu_result[31] == 1);
    overflow = ((alu_control == (ADD | SUB)) & (src_a[31] != (src_a + src_b)) & (overflow_possible == 1));
end
endmodule
