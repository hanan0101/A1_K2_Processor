`timescale 1ns / 1ps


module FULL_ADD(input logic a, b, cin, output logic sum, carry);  
   
   
    logic sum1, carry1, carry2;
    HA HA1(.a(a), .b(b), .sum(sum1), .carry(carry1));
    HA HA2(.a(sum1), .b(cin), .sum(sum), .carry(carry2)); 
    
    
    
    or(carry, carry1, carry2);
    
    endmodule

