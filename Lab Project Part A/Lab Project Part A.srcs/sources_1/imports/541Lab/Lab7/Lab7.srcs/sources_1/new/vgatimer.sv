`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2015 05:04:25 PM
// Design Name: 
// Module Name: vgatimer
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


module vgatimer(
    input wire clk,
    output wire hsync, vsync, activevideo,
    output wire [`xbits-1:0] x, 
    output wire [`ybits-1:0] y
    );
    
    logic [1:0] clk_count = 0;
    always_ff @(posedge clk)
        clk_count <= clk_count +2'b01; 
        
    logic Every2ndTick, Every4thTick;
    assign Every2ndTick = (clk_count[0] == 1'b1);
    assign Every4thTick = (clk_count[1:0] == 2'b11);
    
    xycounter #(`WholeLine, `WholeFrame) xy(clk, Every4thTick, x, y); 
    
    //Generate the monitor signals 
    assign hsync = (x >= `hSyncStart && x <= `hSyncEnd) ? ~`hSyncPolarity : `hSyncPolarity;
    assign vsync = (y >= `vSyncStart && y <= `vSyncEnd) ? ~`vSyncPolarity : `vSyncPolarity; 
    assign activevideo = (x >= `hVisible || y >= `vVisible) ? 1'b0 : 1'b1; 
    
    
endmodule
