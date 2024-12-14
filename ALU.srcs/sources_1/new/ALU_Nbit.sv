`timescale 1ns / 1ps


module ALU_Nbit#(parameter n =8)(
    input logic [n-1:0]a,
    input logic [n-1:0]b,
    input logic s,
    output logic cout ,
    output logic [n-1:0]sum
     
    );
    
 
    always_comb begin
        // Perform addition or subtraction based on the value of s
        if (s) begin
            // Subtraction: a - b
            {cout, sum} <= a - b; // The result will be 5 bits, cout will be the MSB
        end else begin
            // Addition: a + b
            {cout, sum} <= a + b; // The result will be 5 bits, cout will be the MSB
        end
    end
endmodule