`timescale 1ns / 1ps
module tb_flags;
// Parameters
parameter n = 8;
// Signals
logic [n-1:0] inst; // Input to the flags module
logic J, C, D0, D1, Sreg, S;
logic [2:0] imm;     // Outputs

// Instantiate the flags module
flags #(n) uut (
    .inst(inst),
    .J(J),
    .C(C),
    .D0(D0),
    .D1(D1),
    .Sreg(Sreg),
    .S(S),
    .imm(imm)
);
// Test procedure
initial begin
    // Monitor signals
    $monitor("Time: %0t | inst: %b | J: %b | C: %b | D0: %b | D1: %b | Sreg: %b | S: %b | imm: %b", 
             $time, inst, J, C, D0, D1, Sreg, S, imm);  
    // Test cases
    inst = 8'b00000000; #10; // All zeros
    inst = 8'b11111111; #10; // All ones
    inst = 8'b10101010; #10; // Mixed values
    inst = 8'b11001100; #10; // Another mixed case
    inst = 8'b00110101; #10; // Specific values for testing
    inst = 8'b10110010; #10; // Another specific pattern

    // End the simulation
    $finish;
end
endmodule
