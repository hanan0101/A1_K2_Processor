`timescale 1ns / 1ps

module tb_ff;

    logic clk;
    logic rst_n;
    logic d;  // 4-bit data input
    logic q;  // 4-bit output from the DFF

    // D Flip-Flop instantiation
    DFF dff (
        .d(d),        
        .clk(clk),      // Clock input
        .rst_n(rst_n),  // Active-low reset
        .q(q)           // Output
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle clock every 5 ns
    end

    initial begin
        rst_n = 0;    // Assert reset
        #10 rst_n = 1; // Deassert reset

        d = 6; #10; // Set d and wait
        d = 7; #10; // Change d
        d = 0; #10; // Change d
        rst_n = 0; #10;   // Assert reset
        rst_n = 1; #10;   // Deassert reset

        d = 1; #10; // Change d
        d = 6; #10; // Change d
        d = 4; #10; // Change d
        
        // Test reset while enabled
        rst_n = 0; #10;   // Assert reset
        $finish;          // End simulation
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t rst_n=%b d=%b q=%b ",
                 $time, rst_n, d, q);
    end
    
endmodule