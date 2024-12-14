`timescale 1ns / 1ps


module Decoder(
input logic [1:0]op,
output logic [3:0]en

    );
 
    always_comb begin
        case(op)
            2'b00: en = 4'b1000;  // Enable RA
            2'b01: en = 4'b0100;  // Enable RB
            2'b10: en = 4'b0010;  // Enable RO
            2'b11: en = 4'b0001; 
        endcase
    end
endmodule
  