`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/2/2015 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.sv"

module vgadisplaydriver #(
    parameter bmem_init = "bmem.txt"
)(
    input wire clk,
    input wire [3:0] charcode,
    output logic [10:0] screenAddr, 
    output wire [11:0] rgb,
    output wire hsync, vsync
    );

   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   wire [10:0] col, row;
   wire activevideo;
   wire [3:0] red, green, blue;
   wire [11:0] bmemAddr;
   
   vgatimer myvgatimer(clk, hsync, vsync, activevideo, x, y);
   bmem #(12,12,3072,bmem_init) bitmapMemory(bmemAddr, {red, green, blue});
    
   assign col = x >> 4;
   assign row = y >> 4; 
   assign screenAddr = (row << 5) + (row << 3) + (col); 
   assign bmemAddr = {charcode, y[3:0], x[3:0]};
   assign rgb = (activevideo == 1'b1) ? {red, green, blue} : 12'b000000000000;
endmodule