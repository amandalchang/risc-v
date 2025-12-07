// Register file module

// REFERENCES
// table 6.1 pg.303 harris and harris
// pg.395 harris and harris

module register_file(
    input logic clk,
    input logic [31:0] instr,
    input logic write_en_3, // RegWrite from controller
    input logic [31:0] write_data_3, // Result from ALUOut
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

logic [31:0] reg_data [0:31];

initial begin
    integer i;
    for (i = 0; i < 32; i = i + 1)
        reg_data[i] = 32'h0;
end

logic [4:0] a1 = instr[19:15]; // Rs1
logic [4:0] a2 = instr[24:20]; // Rs2
logic [4:0] a3 = instr[11:7];  // Rd


always_ff @(posedge clk) begin
    a1 = instr[19:15]; // Rs1
    a2 = instr[24:20]; // Rs2
    a3 = instr[11:7];  // Rd

    // get read data using addresses
    rd1 = reg_data[a1];
    rd2 = reg_data[a2];

// we3 high: write wd3 data into a3 destination
    if (write_en_3) begin
        reg_data[a3] <= write_data_3;
    end
end

endmodule