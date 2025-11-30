// just the state changing part of control

module control(
    input logic clk,
    output [3:0] current_state
);

    localparam [3:0] FETCH = 4'b0000;
    localparam [3:0] DECODE = 4'b0001;
    localparam [3:0] MEMADR = 4'b0010;
    localparam [3:0] MEMREAD = 4'b0011;
    localparam [3:0] EXECUTE_R = 4'b0100;
    localparam [3:0] EXECUTE_L = 4'b0101;
    localparam [3:0] ALUWB = 4'b0110;
    localparam [3:0] BRANCH = 4'b0111;
    localparam [3:0] JAL = 4'b1000;


// Register the next state of the FSM
    always_ff @(posedge clk)
        current_state <= next_state;

    // Compute the next state of the FSM
    always_comb begin
        next_state = 4'bxxxx;
        case (current_state)
            FETCH: next_state <= DECODE;
            DECODE: next_state <= MEMADR;
            MEMADR: next_state <= EXECUTER;
            EXECUTER: next_state <= EXECUTEL;
            EXECUTEL: next_state <= JAL;
            JAL: next_state <= FETCH;
        endcase
    end

endmodule