// given op, creates immSrc to control the immediate extender
/*
table 7.6
immSrc  |   op    | instruction
  00    | 0000011 |    lw
  00    | 0010011 |    I-type ALU
  01    | 0100011 |    sw
  10    | 1100011 |    beq
  11    | 1101111 |    jal
  xx    | 0110011 |    R-type


*/

module instruction_decoder(
    input logic clk,
    input [6:0] op,
    output [1:0] immsrc
);

    

endmodule