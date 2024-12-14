`timescale 1ns / 1ps

module Memory#(parameter size =16, parameter n=8)(
    input logic [$clog2(size)-1:0] address,  // Address width based on size
     output logic [n-1:0]instruction

          );
    
    logic [n-1:0] loc[0:size-1];

    initial begin
     loc[0] =8'b00001000;//load zero to A
     loc[1] =8'b00011001;  //load 1 to B
     loc[2] =8'b00100000; //push A to output
     loc[3] =8'b00010000; //Add A to B
     loc[4] =8'b01110000;  //If A+B produce carry jump to start
     loc[5] =8'b00000000; //Swap A and B
     loc[6] =8'b00010100; //Swap A and B; 
     loc[7] =8'b00000100;  //RA = RA - RB 
     loc[8] =8'b10110010; //8 J = 2 
     // Initialize remaining locations as needed
     loc[9] = 8'b00000000; // Example initialization
     loc[10] = 8'b00000000; // Example initialization
     loc[11] = 8'b00000000; // Example initialization
     loc[12] = 8'b00000000; // Example initialization
     loc[13] = 8'b00000000; // Example initialization
     loc[14] = 8'b00000000; // Example initialization
     loc[15] = 8'b00000000; // Example initialization
end     
  always@(*) begin
    instruction = loc[address]; // Output the instruction at the given address
    $display("Fetching instruction at address %b: %b", address, instruction);
end

endmodule
