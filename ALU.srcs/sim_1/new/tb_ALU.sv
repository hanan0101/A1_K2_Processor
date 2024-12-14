`timescale 1ns / 1ps
module tb_ALU;
     parameter n =8;
    logic  [n-1:0] a;
    logic  [n-1:0] b;
    logic  cin;       
    logic  [n-1:0] sum;
    logic  carry;  
          
ALU_Nbit#(n) alu(
        .a(a),
        .b(b),
        .s(cin),
        .sum(sum),
        .cout(carry)      
);
 initial begin 
  $display("time\t a  b cin  sum carry");
  a= 4'b0010; b=4'b1001; cin =1;  #10;//sub  
 $display("%0t\t %b %b %b  %b  %b", $time, a, b, cin, sum, carry);
 a= 4'b0010; b=4'b1001; cin =0;#10; //add 
 $display("%0t\t %b %b %b  %b  %b", $time, a, b, cin, sum, carry);
  a= 4'b1001; b=4'b1101; cin =1; #10;//sub  
 $display("%0t\t %b %b %b  %b  %b", $time, a, b, cin, sum, carry);
  a= 4'b0110; b=4'b1010; cin =1; #10;//sub  
 $display("%0t\t %b %b %b  %b  %b", $time, a, b, cin, sum, carry);
   a= 4'b1001; b=4'b1101; cin =0; #10;//add  
 $display("%0t\t %b %b %b  %b  %b", $time, a, b, cin, sum, carry);
  a= 4'b0110; b=4'b1010; cin =0; #10;//add  
 $display("%0t\t %b %b %b  %b  %b", $time, a, b, cin, sum, carry);
  
 $finish;
 end
 endmodule  
  

