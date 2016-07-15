`timescale 1ns / 1ps
`default_nettype none

module rng(
    input wire clk,
    input wire reset, 
    output logic [31:0] data
    );
    
    wire [4:0] fivebitrng, fivebitrng2;
    
    fiveBitRNG fivebit(clk, reset, fivebitrng);
    fiveBitRNG fivebit2(clk, reset, fivebitrng2); 
    
    assign data[5:0] = (fivebitrng) + (fivebitrng2[2:0]);
    assign data[31:6] = {26{1'b0}};
    
endmodule
