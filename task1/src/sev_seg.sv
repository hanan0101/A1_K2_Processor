    module sev_seg_top(
    input wire CLK100MHZ,    // using the same name as pin names
    input wire CPU_RESETN,   
    output wire CA, CB, CC, CD, CE, CF, CG, DP,
    output wire [7:0] AN,    
    input wire [15:0] SW     
);

logic reset_n;
logic clk;
assign reset_n = CPU_RESETN;
assign clk = CLK100MHZ;

// Seven segments Controller
wire [6:0] Seg;
wire [3:0] digits[0:7];

localparam N = 100000000;
localparam WIDTH = $clog2(N);
logic [3:0] pc;

localparam DATA_WIDTH = 8;
logic [DATA_WIDTH-1:0] RA, RB, RO;

// CLOCK DIVIDER    
logic clk_div;    
clk_divider #(.N(N)) clk_div_inst (
         .clk(clk),
         .reset(reset_n),
         .pulses(clk_div)
     );
     
     
 Top_k2 #(.N(16)) K2(
  .clk(clk_div),
 .reset_n(reset_n),
 .en(SW[0]),
 .RA(RA),
 .RB(RB),
 .RO(RO),
 .pc(pc)
   );

assign digits[0] = pc[3:0];
assign digits[1] = 4'b1111;
assign digits[2] = RA[3:0];
assign digits[3] = RA[7:4];
assign digits[4] = RB[3:0];
assign digits[5] = RB[7:4];
assign digits[6] = RO[3:0];
assign digits[7] = RO[7:4];

sev_seg_controller ssc(
    .clk(clk),
    .resetn(reset_n),
    .digits(digits),
    .Seg(Seg),
    .AN(AN)
);
assign CA = Seg[0];
assign CB = Seg[1];
assign CC = Seg[2];
assign CD = Seg[3];
assign CE = Seg[4];
assign CF = Seg[5];
assign CG = Seg[6];
assign DP = 1'b1; // turn off the dot point on seven segs
endmodule : sev_seg_top