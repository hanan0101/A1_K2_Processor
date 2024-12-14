`timescale 1ns / 1ps

module tb_memory;
    // Parameters
    parameter size = 16;
    parameter n = 8;

    // Signals for the DUT (Device Under Test)
    logic [$clog2(size)-1:0] address;  // Address for the Memory
    logic [n-1:0] instruction;           // Output instruction
    // Instantiate the Memory module
    Memory #(size, n) dut (
        .address(address),
        .instruction(instruction)
    );
    // Test procedure
    initial begin
        // Monitor changes
        $monitor("Time: %0t | Address: %0d | Instruction: %b", $time, address, instruction);
        
        // Test all addresses
        for (int i = 0; i < size; i++) begin
            address = i;  // Set address
            #10;          // Wait for 10 ns
        end

        // End simulation
        $finish;
    end

endmodule