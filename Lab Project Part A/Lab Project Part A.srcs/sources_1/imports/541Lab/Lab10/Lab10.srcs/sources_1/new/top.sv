//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/30/2015 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="imem.txt",
    parameter dmem_init="dmem.txt",
    parameter smem_init="smem.txt",
    parameter bmem_init="bmem.txt"
)(
    input wire clk, reset,
    input wire ps2_data,
    input wire ps2_clk,
    output wire hsync, vsync, 
    output wire [3:0] red, green, blue
);
   
   wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr, keyb_char;
   wire mem_wr;
   wire clk100, clk50, clk25, clk12;
   wire [3:0] charcode;
   wire [10:0] screen_addr;
   
   clockdivider_Nexys4 clockdiv(clk, clk100, clk50, clk25, clk12);
   //assign clk100=clk; assign clk50=clk; assign clk25=clk; assign clk12=clk;

   mips mips(clk12, reset, pc, instr, mem_wr, mem_addr, mem_writedata, mem_readdata);
   imem #(32, 32, 500, imem_init) imem(pc[31:0], instr);
   memIO #(32, 32, 8192, dmem_init, smem_init) memIO(clk12, mem_wr, mem_addr, screen_addr, mem_writedata, keyb_char, mem_readdata, charcode);
   vgadisplaydriver #(bmem_init) display(clk100, charcode, screen_addr, {red, green, blue},hsync, vsync);
   keyboard keyb(clk100, ps2_clk, ps2_data, keyb_char);
    
endmodule