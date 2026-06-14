// ============================================================
// Module      : fsm_mealy
// Description : Mealy FSM - Sequence Detector (detects "101")
// Author      : P. Venkatesh Sagar
// Date        : June 2026
// ============================================================

module fsm_mealy (
    input  wire clk,
    input  wire rst_n,
    input  wire din,
    output reg  detect
);

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        detect = 1'b0;
        case (state)
            S0: next_state = din ? S1 : S0;
            S1: next_state = din ? S1 : S2;
            S2: begin
                if (din) begin
                    next_state = S1;
                    detect     = 1'b1;
                end else begin
                    next_state = S0;
                end
            end
            default: next_state = S0;
        endcase
    end

endmodule
