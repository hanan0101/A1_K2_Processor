`timescale 1ns / 1ps

module dflip_flop(
 input  logic D, clk, rst, en,  // Added enable input
    output logic Q, Qn
);
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            Q  <= 0;
            Qn <= 1;
        end 
        else if (en) begin  // Only update when enable is high
            Q  <= D;
            Qn <= ~D;
        end
        // When en is low, Q and Qn maintain their previous values
    end
endmodule
    
    
