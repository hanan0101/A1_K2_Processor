`timescale 1ns / 1ps
module ALU(
    input logic [3:0] a,
    input logic [3:0] b,
    input logic s, //carry in        
    output logic [3:0] sum, //out 
    output logic cout
);
 

    logic cout1 , cout2 ,cout3;
     `timescale 1ns / 1ps


    // Correct the indexing of b to use the correct bit positions
    FULL_ADD a0(.sum(sum[0]), .carry(cout1), .a(a[0]), .b(b[0] ^ s), .cin(s));
    FULL_ADD a1(.sum(sum[1]), .carry(cout2), .a(a[1]), .b(b[1] ^ s), .cin(cout1));
    FULL_ADD a2(.sum(sum[2]), .carry(cout3), .a(a[2]), .b(b[2] ^ s), .cin(cout2));
    FULL_ADD a3(.sum(sum[3]), .carry(cout), .a(a[3]), .b(b[3] ^ s), .cin(cout3));

endmodule