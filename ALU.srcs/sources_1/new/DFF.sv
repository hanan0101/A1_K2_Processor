`timescale 1ns / 1ps


module DFF (
    input logic d,   //cout alu      // Data input
    input logic clk,      // Clock input
    input logic rst_n,    // Active-low reset
    output logic q     //carry   // Output
);

    // Behavioral description of D flip-flop
    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            q <= 1'b0; // Reset output to 0
        end else begin
            q <= d; // Capture input on clock edge
        end
    end

endmodule

