/* ALU module

References
- harris and harris pg402
- harris and harris pg250 alu design, and TABLE 5.3

*/

module alu(
    input logic [2:0] alu_control,
    input logic alu_op,
    input logic [0:31] scr_a,
    input logic [0:31] src_b,
    output logic [0:31] alu_result,
    output logic zero
);

// ALUControl is 000 for addition, 001 for subtraction, 010 for AND, 011 for OR, and 101 for set less than.
localparam ADD = 3'b000;
localparam SUB = 3'b001;
localparam AND = 3'b010;
localparam OR = 3'b011;
localparam SLT = 3'b101; // SET_LESS_THAN

// Branching functions if alu_op is true (1)
localparam BEQ = 3'b000; // equal
localparam BNE = 3'b001; // not equal
localparam BLT = 3'b100; // less than
localparam BGTOE = 3'b101; // greater than or equal
localparam BLTU = 3'b110; // less than unsigned
localparam BGTOEU = 3'b111; // greater than or equal unsigned


logic [0:31] alu_result;
logic zero;
logic alu_op;

always_comb begin
    case (alu_control):
        if (alu_op) begin
            // add BRANCHING FUNCTIONS
            BEQ:
                alu_result = (scr_a == src_b);
            BNE:
                alu_result = (scr_a != src_b);
            BLT:
                alu_result = (scr_a <= src_b);
            BGTOE:
                alu_result = ((src_a > src_b) | (scr_a == src_b));
            BLTU:
                alu_result = // HELP WHA UNSIGNED????!!!
            BGTOEU:
                alu_result = // HELPPPP

        end else begin
            ADD:
                alu_result = scr_a + src_b;
            SUB:
                alu_result = scr_a - src_b;
            AND: 
                alu_result = (scr_a & src_b); // HELP
            OR:
                alu_result = (scr_a | src_b); // HELP
            SLT:
                alu_result = (scr_a < src_b); // HELP
        end

        default: alu_result = 32'b0;
    endcase

    zero = (alu_control == 32'b0);
end


endmodule