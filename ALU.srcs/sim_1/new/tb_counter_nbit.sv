`timescale 1ns / 1ps
module tb_counter_nbit;
// Parameters
parameter n = 8;
// Signals
logic clk, resetn, load, en;
logic [n-1:0] d;
logic [n-1:0] count;
// Instantiate the counter
counternbit #(n) uut (
    .clk(clk),
    .resetn(resetn),
    .load(load),
    .en(en),
    .d(d),
    .count(count)
);
// Clock generation
initial clk = 0;
always #5 clk = ~clk; // 10 ns clock period

// Test procedure
initial begin
      resetn = 1;
    // Initialize signals
    resetn = 0; load = 0; en = 0; d = 0;
    #10 resetn = 1; // Deactivate reset
    // Test loading a value
    d = 8'b00001111; load = 1; #10; load = 0;
    // Count up
    en = 1; 
 #50;
  resetn = 0;
  resetn = 1; #50;
    // End the simulation
    $finish;
end

endmodule