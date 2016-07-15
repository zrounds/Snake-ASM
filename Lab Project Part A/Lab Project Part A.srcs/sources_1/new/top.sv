`timescale 1ns / 1ps
`default_nettype none

module top(
    input clk,
    output hsync, vsync,
    output [11:0] RGB
    );
    
    wire [3:0] red, green, blue;
    wire hsync, vsync;
    
    vgadisplaydriver myDriver(clk, red, green, blue, hsync, vsync); 
    
endmodule
