`timescale 1ns / 1ps


module Register #(
    parameter n = 4 // Width of the register
)(
    input logic [n-1:0] d,    // 4-bit input data
    input logic clk,        // Clock signal
    input logic rst_n,      // Asynchronous active-low reset
    input logic en,   // 
    output logic [n-1:0] q    // 4-bit output
);
always @(posedge clk , negedge rst_n)
begin 
  if (~rst_n)  //active low   
    q <= 1'b0;
      
  else if(en)
      q<= d;
end        
endmodule