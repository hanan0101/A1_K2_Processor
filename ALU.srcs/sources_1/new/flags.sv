`timescale 1ns / 1ps

module flags#(parameter n=8)(
      input logic  [n-1:0] inst ,
      output  logic J, C,D0 ,D1,Sreg ,S,
      output logic [2:0]imm
    );
    
always @(*) begin
    imm <= inst[2:0];      // Extract immediate value from the first 3 bits
    S <= inst[2]; // select add or sub 
    C <= inst[6];         // if ther is carry 
    Sreg <= inst[3];       // select between custom value or output alu 
    D0 <= inst[4];         // for  decoder 
    D1 <= inst[5];         // for decoder 
    J <= inst[7];         // jump
end
endmodule

