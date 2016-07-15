`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2015 10:58:08 PM
// Design Name: 
// Module Name: datapath_test
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


module datapath_tester();

    logic clk = 1'b0, reset, sext, bsel, werf;
    logic [31:0] pc = 32'b0;
    logic [31:0] pcPlusFour;
    logic [31:0] instr = 32'b0;
    logic [1:0] pcsel = 2'b00, wasel = 2'b00, wdsel = 2'b00, asel = 2'b00;
    logic [4:0] alufn = 5'b0;
    logic [31:0] mem_addr, mem_writedata; 
    logic [31:0] mem_readdata; 
    logic Z;
    
    datapath #(5, 32, 32) dp(.clk(clk), .reset(reset), 
                  .pc(pc), .pcPlusFour(pcPlusFour), .instr(instr),
                  .pcsel(pcsel), .wasel(wasel[1:0]), .sext(sext), .bsel(bsel), 
                  .wdsel(wdsel), .alufn(alufn), .werf(werf), .asel(asel),
                  .Z(Z), .mem_addr(mem_addr), .mem_writedata(mem_writedata), .mem_readdata(mem_readdata));
    
    initial begin
        #0.5 clk = 0;
        forever
        #0.5 clk = ~clk;
    end
        
    initial begin
       #50 $finish;
    end
    
endmodule
