/* ALU module

References
- harris and harris pg402
- harris and harris pg250 alu design, and TABLE 5.3

*/

module alu(
    input [2:0] alu_control,
    input [0:31] scr_a,
    input [0:31] src_b,
    output [0:31] alu_result,
    output zero
);

// ALUControl is 000 for addition, 001 for subtraction, 010 for AND, 011 for OR, and 101 for set less than.
localparam ADD = 3'b000;
localparam SUB = 3'b001;
localparam AND = 3'b010;
localparam OR = 3'b011;
localparam SLT = 3'b101; // SET_LESS_THAN

logic [0:31] alu_result;
logic zero;

always_comb begin
    case (alu_control):
        ADD:
            alu_result = scr_a + src_b;
        SUB:
            alu_result = scr_a - src_b;
        AND: 
            alu_result = scr_a & src_b; // HELP
        OR:
            alu_result = scr_a | src_b; // HELP
        SLT:
            alu_result = scr_a < src_b; // HELP

        default: alu_result = 32'b0;
    endcase

    zero = (alu_control == 32'b0);
end


endmodule