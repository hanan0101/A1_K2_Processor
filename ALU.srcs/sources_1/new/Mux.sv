`timescale 1ns / 1ps


module Mux#(parameter n =4)(
    input logic  [n-1:0]custim_vale,
    input logic  [n-1:0]data,  // alu output 
    input logic s_reg,
    output logic [n-1:0]out 
    );
    
 
always @(custim_vale,data ,s_reg) begin 
       if(s_reg)
       out =  custim_vale;
       else 
       out =data;    
    end 
endmodule
