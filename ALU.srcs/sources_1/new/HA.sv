`timescale 1ns / 1ps


module HA(
input a,
input b, output sum,
output carry);
xor (sum,a,b);
and (carry,a,b);
endmodule

