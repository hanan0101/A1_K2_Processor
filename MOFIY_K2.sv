`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2024 01:49:32 PM
// Design Name: 
// Module Name: K2_processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module K2_processor /*#(parameter n=4)*/(
    input clk,
    input reset,
    output logic [7:0]reg_a, 
    output logic [7:0]reg_b, 
    output logic [7:0]reg_o, 
    output logic [3:0]PC
    );
    
    //logic [3:0] PC; //pc to IM
    logic [7:0] sum, mux_out1, mux_out2, musk_out; //length of the bits
    logic and1, and2, in0;  //for the new decoder
    logic j,c,d1,d0,sreg,carry_dff,carry;  // instrucation memory
    logic [2:0] s; // imm val                      ues
    logic [3:0] d_out;// to en registers
    logic mflag; // to control the second mux wether chosseing first mux or data memory
    logic dout_mem ; // memory output
    logic out_dff; // it's the output of the new decoder 
    logic w_en_input; //enable the data memory
    logic sum_jz; //dff_jz
    
    assign mflag = j & ~c & sreg;
    assign and1 = ~sreg & carry_dff; // C
    assign and2 = ~sreg & j; // jc
    assign musk_out = ((~sum[0])&~sum[1]&(~sum[2])&~sum[3]&(~sum[4])&~sum[5]&(~sum[6])&~sum[7]); //musk for jz
    //musk_out was one ~ at the begining , now befor each bit anded 
    assign in0 =0; // assign one of the new decoder value to zero not sure why 
    assign w_en_input = sreg & c; // control the enable of data memory

    ////////////////////////////////////////////////////////////////////////////////
     instruction_memory #( .width(8) ,  .depth(16)) mem(
    .address({4'b0,PC}), 
    .instruction({j,c,d1,d0,sreg,s}) 
    );
////////////////////////////////////////////////////////////////////////////////////
     program_counter prog_count(
    .clk(clk), 
    .reset(reset),
    .en(1'b1),
    .load_en(out_dff),//enabled by the output of jc decoder
    .load({1'b0,s}), //it was only s
    .count(PC)
    );
    
 /////////////////////////////////////////////////////////////////////////////////   
    ALU alu_unit(
    .a(reg_a),
    .b(reg_b),
    .s(s[2]),
    .sum(sum),
    .carry_alu(carry)
    );
  ////////////////////////////////////////////////////////////////////////////////  
    register RA (
    .clk(clk),
    .en(d_out[0]), //{1'b0,s}*******
    .reset(reset),
    .data_in(mux_out2), //change
    .data_out(reg_a)
    );
  ////////////////////////////////////////////////////////////////////////////////  
     register RB (
    .clk(clk),
    .en(d_out[1]), //********
    .reset(reset),
    .data_in(mux_out2),//change
    .data_out(reg_b)
    );
       
 /////////////////////////////////////////////////////////////////////////////////  
    register RO (
    .clk(clk),
    .en(d_out[2]), //**********
    .reset(reset),
    .data_in(reg_a),//from Ra
    .data_out(reg_o)
       );
   
 /////////////////////////////////////////////////////////////////////////////////
   register DFF (
    .clk(clk),
    .en( 1'b1),
    .reset(reset),
    .data_in(carry),//
    .data_out(carry_dff)
       );
 ////////////////////////////////////////////////////////////      
   register DFF_jz (
    .clk(clk),
    .en( 1'b1),
    .reset(reset),
    .data_in(musk_out),//
    .data_out(sum_jz) //carry_dff
       );
      
 /////////////////////////////////////////////////////////////////////////////////   
 Mux MUX_1(
    .A({5'b00000,s}),
    .B(sum),
    .S(sreg),
    .Z(mux_out1) 
    );
 //////////////////////////////////////////////////////////////////////////////////   
 Decoder dec(
    .d0(d0),
    .d1(d1),
    .dout(d_out[3:0])
    );
    /////////////////////////////////////////////////////////////////////////////////
     Mux Mux_2(
    .A(dout_mem),
    .B(mux_out1), //data memory
    .S(mflag),
    .Z(mux_out2) 
    );
    ///////////////////////////////////////////////////////////////////////////////////
                               
Data_memory Data_memory
(
    .address({5'b0,s}),       ///
    .data_in(reg_a), 
    .en(1'b1),     //d_out[4]           
    .reset(reset),               
    .clk(clk),                 
    .we(w_en_input), //sreg & c                
    .data_out(dout_mem)
 ); 
 //////////////////////////////////////////////////////////////////////////////////////
 
mux_jc Mux_3 //for Jz Mux
(
    .in1(and1),   //~sreg & carry
    .in2(and2), // ~sreg & j
    .in3(sum_jz), //  output DFF_jz 
    .s1(j),
    .s2(c),      
    .out_m(out_dff)
 );
     
endmodule
