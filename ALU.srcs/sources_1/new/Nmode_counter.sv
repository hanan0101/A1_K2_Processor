`timescale 1ns / 1ps
module Nmode_Counter #(
    parameter N = 100,                        
    localparam WIDTH = $clog2(N)              
) (
    input  logic clk,                         
    input  logic resetn,                      
    input  logic load,                      
    input  logic en, 
    input logic clr,                        
    input  logic up_down,                    
    input  logic [WIDTH - 1:0] d,           
    output logic [WIDTH - 1:0] count 
);

  logic intr_clr; // Internal clear signal

    // Instantiate the nbit_counter
    counternbit #(.n(WIDTH)) dut (
        .clk(clk),
        .resetn(resetn),
        .load(load),
        .en(1'b1),
        .clr(intr_clr),
        .d(d),
        .count(count)                  
    );

    /// Mod-N logic to handle wrapping behavior
    always_ff @(*) 
    begin
        if (clr) begin    
            intr_clr = 1;                   
        end else if (count == N - 1) begin
            intr_clr = 1;                                   
        end else begin
            intr_clr = 0;                   
        end
    end

    
endmodule