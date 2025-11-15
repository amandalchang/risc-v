// Register file module

// REFERENCES
// fig 6.1 pg.303 harris and harris
// pg.395 harris and harris

module register_file(
    input clk,
    input instra,
    input we3, // RegWrite from controller
    input result, // Result from ALUOut
    output rd1,
    output rd2
);

logic [0:31] reg_data [32];

logic [0:4] a1 = instra[19:15]; // Rs1
logic [0:4] a2 = instra[24:20]; // Rs2
logic [0:4] a3 = instra[11:7];  // Rd

// write data
logic [0:31] wd3 = result;

logic [0:31] rd1 = reg_data[a1];
logic [0:31] rd2 = reg_data[a2];

always_comb begin
    a1 <= instra[19:15]; // Rs1
    a2 <= instra[24:20]; // Rs2
    a3 <= instra[11:7];  // Rd

    // write data
    wd3 = result;

    // get read data using addresses
    rd1 <= reg_data[a1];
    rd2 <= reg_data[a2];
end

// we3 high: write wd3 data into a3 destination
always_ff @(posedge clk) (
    if (we3) begin
        reg_data[a3] <= wd3;
    end
);

endmodule