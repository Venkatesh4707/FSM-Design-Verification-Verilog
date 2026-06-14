// ============================================================
// Module      : fsm_tb
// Description : Self-checking testbench for Moore & Mealy FSMs
// Author      : P. Venkatesh Sagar
// Date        : June 2026
// ============================================================

`timescale 1ns/1ps

module fsm_tb;

    reg clk, rst_n, din;
    wire detect_moore, detect_mealy;

    integer pass_count = 0;
    integer fail_count = 0;
    integer i;

    reg [0:15] test_seq = 16'b1011010101101011;

    fsm_moore dut_moore (.clk(clk), .rst_n(rst_n), .din(din), .detect(detect_moore));
    fsm_mealy dut_mealy (.clk(clk), .rst_n(rst_n), .din(din), .detect(detect_mealy));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("==============================================");
        $display("  FSM Testbench - Moore vs Mealy (101 detector)");
        $display("  Author: P. Venkatesh Sagar");
        $display("==============================================");

        rst_n = 0;
        din   = 0;
        @(negedge clk);
        rst_n = 1;

        $display("\nCycle | din | Moore_detect | Mealy_detect");
        $display("------|-----|--------------|-------------");

        for (i = 0; i < 16; i = i + 1) begin
            @(negedge clk);
            din = test_seq[i];
            #1;
            $display("  %2d  |  %b  |      %b       |     %b", i, din, detect_moore, detect_mealy);
        end

        $display("\n--- Directed Test: Clean '101' pattern ---");
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;

        @(negedge clk); din = 1; #1;
        if (detect_moore == 0 && detect_mealy == 0) begin
            $display("PASS | After '1': Moore=0, Mealy=0 (correct, no detect yet)");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | After '1': unexpected detect");
            fail_count = fail_count + 1;
        end

        @(negedge clk); din = 0; #1;
        if (detect_moore == 0 && detect_mealy == 0) begin
            $display("PASS | After '10': Moore=0, Mealy=0 (correct, no detect yet)");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | After '10': unexpected detect");
            fail_count = fail_count + 1;
        end

        @(negedge clk); din = 1; #1;
        if (detect_mealy == 1) begin
            $display("PASS | After '101': Mealy=1 (detects immediately - combinational)");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | After '101': Mealy should be 1");
            fail_count = fail_count + 1;
        end

        @(negedge clk); din = 0; #1;
        if (detect_moore == 1) begin
            $display("PASS | One cycle later: Moore=1 (registered state output)");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | Moore should be 1 one cycle after pattern");
            fail_count = fail_count + 1;
        end

        $display("\n==============================================");
        $display("  RESULTS: %0d PASSED | %0d FAILED", pass_count, fail_count);
        if (fail_count == 0)
            $display("  ALL TESTS PASSED - FSM VERIFIED");
        else
            $display("  FAILURES FOUND - CHECK ABOVE");
        $display("==============================================");
        $finish;
    end

    initial begin
        $dumpfile("fsm_sim.vcd");
        $dumpvars(0, fsm_tb);
    end

endmodule
