`timescale 1ns / 1ps

module tb_Register;
    parameter N = 4 ;
    logic clk;
    logic rst_n;
    logic en;
    logic [N-1:0] d;
    logic [N-1:0] q;    // Outputdataflow model 
 Register#(N) DUT(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .d(d),
        .q(q)
    );
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        rst_n = 0;
        en = 0;
        d = 4'b0000;#10;
        rst_n = 1;#10;
        // Test enable
        en = 1;
        d = 4'b1010;  #10;
        en = 1;
        d = 4'b1010;#10;
        en = 0;
        d = 4'b1000;#10;
        en = 1;
        d = 4'b1100;#10;
        en = 0;
        d = 4'b1010; #10;
        en = 1;
        d = 4'b0110;#10;        
        // Test reset while enabled
        rst_n = 0;#10;
        $finish;
    end
    // Monitor changes
    initial begin
        $monitor("Time=%0t rst_n=%b en=%b d=%b q=%b ",
                 $time, rst_n, en, d, q);
    end
endmodule

