`timescale 1ns / 1ps


module tb_k2;
    logic clk;
    logic reset_n;
    logic en;
    logic [3:0] prog_count;
    logic [7:0] RA, RB, RO;
    parameter N=9;
    Top_k2  #(.N(N))dut
    (
        .clk(clk),
        .reset_n(reset_n),
        .en(en),
        .pc(prog_count),
        .RA(RA),
        .RB(RB),
        .RO(RO)
    );  
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 time units clock period
    end
    // Test sequence
    initial begin
        $display("                Time   | Reset | Enable |     PC     |      RA      |      RB      |        RO");
        $display("             ---------------------------------------------------------------------------------------");
        $monitor("%t   |   %b   |    %b   |    %b   |    %b   |   %b   |      %b", $time, reset_n, en, prog_count, RA, RB, RO);
        reset_n = 1;
        // Initialize
        reset_n = 0; en = 0; #3;
        en = 1; reset_n = 1; #110;
        en = 0; #10
        en = 1; #220;
        // Reset
        reset_n = 0; #10;
        reset_n = 1; #10;
          
        
        $stop;
    end
   
endmodule
