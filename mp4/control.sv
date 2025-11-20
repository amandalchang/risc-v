// Control Unit
// given the op code, funct3, and funct7, outputs control signals to the rest of the processor

`include "alu_decoder.sv"
`include "instr_decoder.sv"



module control(
    output logic pcwrite,
    output logic adrsrc,
    output logic memwrite,
    output logic irwrite
    input [31:0] instr,
    input logic zero,
    output [1:0] resultsrc,
    output [2:0] alucontrol,
    output [1:0] alusrcb,
    output [1:0] alusrca,
    output [1:0] immsrc,
    output logic regwrite
);
    // 7 bit opcodes decoded
    localparam [6:0] UTYPE  = 7'b0110111;
    localparam [6:0] ITYPEA = 7'b0010011;
    localparam [6:0] ITYPEL = 7'b0000011;
    localparam [6:0] STYPE  = 7'b0100011;
    localparam [6:0] BTYPE  = 7'b1100011;
    localparam [6:0] JTYPE  = 7'b1101111;
    localparam [6:0] RTYPE  = 7'b0110011;

    localparam [2:0]

    ALU_decoder u0 (
        .clk            (clk), 
        .funct3         (),
        .op_5           (),
        .funct7_5       (),
        .alu_op         (),
        .alu_control    ()

    );

    instruction_decoder u1 (
        .clk            (clk), 
    );
    
endmodule