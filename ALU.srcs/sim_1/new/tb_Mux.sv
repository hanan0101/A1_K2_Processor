`timescale 1ns / 1ps
module tb_Mux;
    // Parameter for width
    parameter n = 4;
    // Signals for the DUT (Device Under Test)
    logic [n-1:0] custim_vale; // Input custom value
    logic [n-1:0] data;        // Input data
    logic s_reg;               // Select signal
    logic [n-1:0] out;         // Output of the Mux

    // Instantiate the Mux module
    Mux #(n) dut (
        .custim_vale(custim_vale),
        .data(data),
        .s_reg(s_reg),
        .out(out)
    );
    // Test procedure
    initial begin
        // Monitor changes
        $monitor("Time: %0t | custim_vale: %b | data: %b | s_reg: %b | out: %b", 
                 $time, custim_vale, data, s_reg, out);  
        // Test cases
        // Case 1: s_reg = 0, should select data
        custim_vale = 4'b1010; data = 4'b0101; s_reg = 1'b0; #10;
        
        // Case 2: s_reg = 0, should select data
        custim_vale = 4'b1111; data = 4'b0000; s_reg = 1'b0; #10;

        // Case 3: s_reg = 1, should select custim_vale
        custim_vale = 4'b1010; data = 4'b0101; s_reg = 1'b1; #10;

        // Case 4: s_reg = 1, should select custim_vale
        custim_vale = 4'b1100; data = 4'b0011; s_reg = 1'b1; #10;

        // Case 5: s_reg = 0, should select data
        custim_vale = 4'b0011; data = 4'b1111; s_reg = 1'b0; #10;

        // Case 6: s_reg = 1, should select custim_vale
        custim_vale = 4'b0000; data = 4'b1111; s_reg = 1'b1; #10;

        // End simulation
        $finish;
    end
endmodule

