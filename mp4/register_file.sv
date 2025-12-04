// Register file module

// REFERENCES
// table 6.1 pg.303 harris and harris
// pg.395 harris and harris

module register_file(
    input clk,
    input [31:0] instr,
    input write_en_3, // RegWrite from controller
    input [31:0] result, // Result from ALUOut
    output [31:0] rd1,
    output [31:0] rd2
);

logic [31:0] reg_data [32];

logic [4:0] a1 = instr[19:15]; // Rs1
logic [4:0] a2 = instr[24:20]; // Rs2
logic [4:0] a3 = instr[11:7];  // Rd

// write data
logic [31:0] write_data_3 = result;

logic [31:0] rd1 = reg_data[a1]; // prob don't need to declare this using logic [31:0]
logic [31:0] rd2 = reg_data[a2];


always_comb begin
    a1 = instr[19:15]; // Rs1
    a2 = instr[24:20]; // Rs2
    a3 = instr[11:7];  // Rd

    // write data
    write_data_3 = result;

    // get read data using addresses
    rd1 = reg_data[a1];
    rd2 = reg_data[a2];
end

// we3 high: write wd3 data into a3 destination
always_ff @(posedge clk) begin
    if (write_en_3) begin
        reg_data[a3] <= write_data_3;
    end
end

endmodule