// given op, creates immSrc to control the immediate extender
/*
Textbook Reference (NOT WHAT WE INCORPORATED): Table 7.6
immSrc  |   op    | instruction
  00    | 0000011 |    lw //
  00    | 0010011 |    I-type ALU
  01    | 0100011 |    sw
  10    | 1100011 |    beq
  11    | 1101111 |    jal
  xx    | 0110011 |    R-type

To incorporate U-type, we make imm_src 3 bits and prepend
existing imm_src codes with a 0. Our table is therefore:
  000    | 0010011 |    I-type ALU
  000    | 0000011 |    I-type Load
  001    | 0100011 |    S-type
  010    | 1100011 |    B-type
  011    | 1101111 |    J-type
  100    | 0110111 |    U-type // New addition!
  111    | 0110011 |    R-type 
  We change R-type from xx to 111 to make the imm_ext 32 0s

*/

module instruction_decoder(
    input logic clk,
    input logic [6:0] op,
    output logic [2:0] imm_src
);
    localparam [6:0] ITYPEA = 7'b0010011;
    localparam [6:0] ITYPEL = 7'b0000011;
    localparam [6:0] JALR = 7'b1100111;
    localparam [6:0] STYPE  = 7'b0100011;
    localparam [6:0] BTYPE  = 7'b1100011;
    localparam [6:0] JTYPE  = 7'b1101111;
    localparam [6:0] LUI  = 7'b0110111;
    localparam [6:0] AUIPC = 7'b0010111;
    localparam [6:0] RTYPE  = 7'b0110011;

    always_comb begin
      case (op) // read the opcode
        ITYPEA, ITYPEL, JALR: imm_src = 3'b000;
        STYPE:  imm_src = 3'b001;
        BTYPE:  imm_src = 3'b010;
        JTYPE:  imm_src = 3'b011;
        LUI:  imm_src = 3'b100;
        AUIPC: imm_src = 3'b100;
        RTYPE:  imm_src = 3'b111;
        default: imm_src = 3'bXXX;
      endcase
    end

    

endmodule