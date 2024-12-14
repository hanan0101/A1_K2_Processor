`timescale 1ns / 1ps

module clk_divider #(
    parameter N = 100,                     // Division factor
    localparam WIDTH = $clog2(N/2)         // Calculate bit width for N/2
) (
    input logic clk,                       // Clock input
    input logic reset,                     // Active-high reset
    output logic pulses                    // Output divided clock pulses
);
   logic en;
    // Internal signals
   // logic en_count = 1'b1;                 // Enable counting
    logic pulse_out;                       // Pulse output from counter
    logic [WIDTH-1:0] count;               // Counter value
    logic load;
    
    assign load = 0;
    
    Nmode_Counter #(.N(N/2)
    ) clock_divider (
        .clk(clk),
        .resetn(reset),                   // Active-low reset
        .load(load),
        .d('dz),
        .en(en),
        .up_down(1'b0),                    
        .clr(pulse_out),                   // Clear signal from pulse logic
        .count(count)                // Output counter value
    );    
    assign pulse_out = (count == (N/2) - 1); // Counter reaches N/2-1
    // Flip-flop to generate the final pulse signal
    dflip_flop ff (
        .clk(clk),
        .rst(reset),                       
        .en(pulse_out),                    // Enable on pulse_out
        .D(~pulses),                        // Toggle output
        .Q(pulses)                          // Final pulse output
    );
    
    
   
endmodule

