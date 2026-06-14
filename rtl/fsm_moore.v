// ============================================================
// Module      : fsm_moore
// Description : Moore FSM - Sequence Detector (detects "101")
// Author      : P. Venkatesh Sagar
// Date        : June 2026
// ============================================================

module fsm_moore (
    input  wire clk,
    input  wire rst_n,
    input  wire din,
    output reg  detect
);

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    reg [1:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: next_state = din ? S1 : S0;
            S1: next_state = din ? S1 : S2;
            S2: next_state = din ? S3 : S0;
            S3: next_state = din ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    always @(*) begin
        detect = (state == S3);
    end

endmodule
