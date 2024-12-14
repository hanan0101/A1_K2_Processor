`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2024 12:20:30 PM
// Design Name: 
// Module Name: microprocessor_v2
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


module microprocessor_v2#(
        parameter DATA_WIDTH = 8
        
)(
        input logic clk,
        input logic reset_n,
        input logic en,
        output logic [3:0] prog_count,
        output logic [DATA_WIDTH-1:0] A, B, Out

    );
    
    localparam INST_WIDTH = 8;
    localparam INST_DEPTH = 16;
    localparam IMM_WIDTH = 3;
    localparam DATA_DEPTH = 2 ** IMM_WIDTH; // 2^(number of imm bits)
    
    logic [INST_WIDTH-1:0] inst;
    logic J, C, D1, D0, Sreg, S;
    logic [2:0] imm;
    
    // INSTRUCTION MEMORY
    
    instruction_memory inst_memory (
        .address(prog_count),
        .instruction(inst)
    );
         
     // INSTRUCTION DECODER
     
     inst_decoder#(.n(INST_WIDTH)) inst_decoder(
        .inst(inst),
        .J(J),
        .C(C),
        .D1(D1),
        .D0(D0),
        .Sreg(Sreg),
        .S(S),
        .imm(imm)
    );
    
    logic [3:0] imm_ext;
    assign imm_ext = {1'b0, imm}; // Extended version of imm to input to the program counter
    
    // DATA MEMORY
    
    logic Wen;
    assign Wen = Sreg & C;
    logic [DATA_WIDTH-1:0] data_out;
    
    data_memory #(
        .WIDTH(DATA_WIDTH),   
        .DEPTH(DATA_DEPTH)    
    ) datamem (
        .clk(clk),
        .reset_n(reset_n),
        .address(imm),
        .data_in(A),
        .Wen(Wen),
        .data_out(data_out)
    );
    
    // PROGRAM COUNTER

    logic load2counter;
    mod_n_counter#(.N(INST_DEPTH)) PC (
        .clk(clk),
        .areset(reset_n),
        .en(en & !load2counter), // en OR !load2counter
        .load(load2counter),
        .d(imm_ext),
        .q(prog_count)
     );
    
    // ALU
    
    logic Cout;
    logic [DATA_WIDTH-1:0] alu_out;
    
    adder_subtractor_nbit #(.WIDTH(DATA_WIDTH)) alu (
        .A(A),
        .B(B),
        .M(S),
        .Cout(Cout),
        .S(alu_out)
    );
    
    // Program counter logic for jump
    logic Cout_ff;
    
    register_nbit #(.n(1)) ff_carry(
        .clk(clk),
        .areset(reset_n),
        .en(1'b1), 
        .d(Cout),
        .q(Cout_ff) 
    );
    
    logic jump_out, Z;
    logic [1:0] jump_sel;
    assign jump_sel = {J, C};
    assign Z = ~|alu_out;
    
    mux3_1 #(.WIDTH_IN(1)) mux_jump (
        .A(Cout_ff), // JC
        .B(1'b1), // J
        .C(Z), // JZ
        .S(jump_sel),
        .Y(jump_out)
    );
    
    assign load2counter = jump_out & ~Sreg;
    
    // MULTIPLEXER 1
    
    logic [((IMM_WIDTH > DATA_WIDTH) ? IMM_WIDTH : DATA_WIDTH)-1:0] mux1_out;
     
    mux2_1 #(.WIDTH1(IMM_WIDTH), .WIDTH2(DATA_WIDTH)) mux1 (
        .A(imm),
        .B(alu_out), 
        .S(Sreg),
        .Y(mux1_out)
    );
    
    // MULTIPLEXER 2
    
    logic [DATA_WIDTH-1:0] mux2_out;
    logic mux2_sel;
    assign mux2_sel = Sreg & ~C & J;
     
    mux2_1 #(.WIDTH1(DATA_WIDTH), .WIDTH2(DATA_WIDTH)) mux2 (
        .A(data_out),
        .B(mux1_out), 
        .S(mux2_sel),
        .Y(mux2_out)
    );
    
    // REGISTER DE-MULTIPLEXING
    
    logic en_A, en_B, en_Out;
    assign en_A = ~D1 & ~D0 & en;
    assign en_B = ~D1 & D0 & en;
    assign en_Out = D1 & ~D0 & en;
    
    // REGISTERS
    
    register_nbit #(.n(DATA_WIDTH)) reg_A(
        .clk(clk),
        .areset(reset_n),
        .en(en_A), 
        .d(mux2_out),
        .q(A) 
    );
    
    register_nbit #(.n(DATA_WIDTH)) reg_B(
        .clk(clk),
        .areset(reset_n),
        .en(en_B), 
        .d(mux2_out),
        .q(B) 
    );
    
    register_nbit #(.n(DATA_WIDTH)) reg_Out(
        .clk(clk),
        .areset(reset_n),
        .en(en_Out), 
        .d(A),
        .q(Out) 
    );

endmodule