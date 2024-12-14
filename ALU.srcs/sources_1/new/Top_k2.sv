`timescale 1ns / 1ps

module Top_k2 #(parameter N =9) //data in 
(
input logic clk,
input logic reset_n,
input logic en,
output logic[N-1:0] RA,RB,RO,
output logic [3:0] pc

    );
    localparam Depth_inst=16; // memory size 
    localparam WIDTH_inst=8; // instraction width
    localparam address_size = $clog2(Depth_inst); // address size 
       
    logic [WIDTH_inst-1:0]instruction;
    
//memory        
   Memory #(.size(Depth_inst),.n(WIDTH_inst)) ROM(
      .address(pc), 
      .instruction(instruction)
    );
    logic [2:0]imm ;      
    logic S;
    logic C;         
    logic Sreg;       
    logic D0;         
    logic D1;         
    logic J;
    
    logic [7:0] custim_value ;
    assign custim_value= {5'b00000, imm}; // Extend length of imm to be 8 bit 
    
     flags#(.n(N)) flag(
        .inst(instruction) ,
         .J(J), .C(C),.D0(D0) ,.D1(D1),.Sreg(Sreg) ,.S(S),
         .imm(imm)
    );
    logic Cout ;
    logic [N-1:0]sum;

 ALU_Nbit#(.n(N))alu(
    .a(RA),
    .b(RB),
    .s(S),
    .cout(Cout) ,
    .sum(sum)
    );
    
  logic carry;
 // 1 bit D flip flop for stor the carry     
  DFF dff(
    .d(Cout),        // Data input
    .clk(clk),      
    .rst_n(reset_n),   
    .q(carry)        // Output
 );
 
logic Jump_logic; 
assign Jump_logic = ((carry&C)| J);
            
   /* counternbit#(.n(address_size)) count( // counter 4 bit 
    .clk(clk),
    .resetn(reset_n),
    .load(Jump_logic),
    .en(en),
    .d(custim_value), // immadiat value will be the data 
    .count(pc)
);*/
    
    logic clr;
 
    Nmode_Counter#(.N(N)) 
    Nmodecounter (
     .clk(clk),                         
     .resetn(reset_n),                      
     .load(Jump_logic),                      
     .en(en), 
     .clr(clr),                        
     .up_down(1'b0),                    
     .d(custim_value),           
     .count(pc) 
);

logic [N-1:0]mux_out;

 Mux#(.n(N)) mux(
    .custim_vale(custim_value),
    .data(sum),
    .s_reg(Sreg),
    .out(mux_out) 
    );
   
// Enable signals for registers
    logic enA, enB, eno,noop;
    // Decoder Instance
    Decoder decoder_inst (
        .op({D1,D0}),      
        .en({enA, enB, eno, noop})
    );  
//  logic [N-1:0] RB_in ,RA_in;
 Register #(.n(N))Areg(
    .d(mux_out),  
    .clk(clk),  
    .rst_n(reset_n),     
    .en(enA), 
     .q(RA)  
);       
 Register #(.n(N))Breg(
    .d(mux_out),   
    .clk(clk),  
    .rst_n(reset_n),    
    .en(enB), 
     .q(RB)    
);
    
         
 Register #(.n(N))out_reg(
    .d(RA), // output regesiter is concted with A register
    .clk(clk),      
    .rst_n(reset_n),    
    .en(eno), 
    .q(RO)    
);    

endmodule
