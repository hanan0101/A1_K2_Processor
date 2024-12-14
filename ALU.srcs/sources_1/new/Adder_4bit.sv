`timescale 1ns / 1ps


module Adder_4bit(

    input  [3:0] a,
    input  [3:0] b,
    input  cin,        // cin should be 1 bit, not 4 bits
    output  [3:0] sum,
    output  carry      // Final carry should be 1 bit, not 4 bits
);
    wire  [2:0] c;         // Internal carries between FAs
    // Instantiate 4 full adders
    FULL_ADD fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .carry(c[0])
    );
    FULL_ADD fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(c[0]),
        .sum(sum[1]),
        .carry(c[1])
    );
    FULL_ADD fa2(
        .a(a[2]),
        .b(b[2]),
        .cin(c[1]),
        .sum(sum[2]),
        .carry(c[2])
    );
    FULL_ADD fa3(
        .a(a[3]),
        .b(b[3]),
        .cin(c[2]),
        .sum(sum[3]),
        .carry(carry)
    );
endmodule

