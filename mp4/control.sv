// Control Unit
//
module control(
    input [31:0] instr,
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

    module aludecoder(
        input [2:0] funct3,
        input []
    )



