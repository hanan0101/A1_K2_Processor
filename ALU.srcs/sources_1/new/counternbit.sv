`timescale 1ns / 1ps



module counternbit#(
    parameter n = 4
)(
    input  logic clk,
    input  logic resetn,
    input  logic load, //c&carry 1 0 j 
    input  logic en,
    input logic clr,
    input  logic [n - 1: 0] d, // custim value  
    output logic [n - 1: 0] count 
);
    logic [n-1 : 0] counter;
    
    always @(posedge clk or negedge resetn) begin 
        if (~resetn) begin
            counter <= 0; // Reset count to 0 on active-low reset
       end else if (clr) begin 
            counter <= 0;
       end  else if (load) // Load value d into count if load is high
                counter <= d;
         else if (en) begin
           counter <= counter +1;
    end
end 
 assign counter = count ;
endmodule
 
