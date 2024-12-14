`timescale 1ns / 1ps
module tb_decoder;
// Parameters
parameter n = 4; // Number of outputs
parameter W = $clog2(n); // Number of input bits

// Signals
logic [W-1:0] op; // Input to the decoder
logic [n-1:0] en;  // Output from the decoder

// Instantiate the Decoder
Decoder #(n) uut (
    .op(op),
    .en(en)
);

// Test procedure
initial begin
    // Monitor signals
    $monitor("Time: %0t | op: %b | en: %b", $time, op, en);
    
    // Test all possible inputs
    op = 2'b00; #10; // Enable RA
    op = 2'b01; #10; // Enable RB
    op = 2'b10; #10; // Enable RC
    op = 2'b11; #10; // Enable RD (or all zeros)

    // End the simulation
    $finish;
end

endmodule

