`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2015 06:53:30 PM
// Design Name: 
// Module Name: datapath
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


module datapath#(
   parameter Abits = 5,          // Number of bits in address
   parameter Dbits = 32,         // Number of bits in data
   parameter Nloc = 32           // Number of memory locations
)(
    input wire clk, reset, sext, bsel, werf,
    output logic [31:0] pc = 32'b0,
    input wire [31:0] instr, 
    input wire [1:0] pcsel, wasel, wdsel, asel,
    input wire [4:0] alufn,  
    output logic [Dbits-1 : 0] mem_addr, mem_writedata, 
    input logic [Dbits-1 : 0] mem_readdata, 
    output logic Z
    );
    
    logic [Abits-1:0] reg_writeaddr;
    logic [31:0] reg_writedata, ReadData1, ReadData2, ALUResult;
    logic [31:0] pcPlusFour, newPC, JT, BT, signImm, aluA, aluB;
    
    register_file #(Abits, Dbits, Nloc) rf(clk, werf, instr[25:21], instr[20:16], reg_writeaddr, reg_writedata, ReadData1, ReadData2);
        
    ALU #(Dbits) myALU(aluA, aluB, ALUResult, alufn, Z); 
    
    
        assign pcPlusFour = pc + 4; 
    
    
       assign newPC = (reset == 1'b1) ? 32'b0 : 
                       (pcsel == 2'b00) ? pcPlusFour : 
                       (pcsel == 2'b01) ? BT : 
                       (pcsel == 2'b10) ? {pc[31:28], instr[25:0], 2'b00} : JT;
    
    always_ff@(posedge clk)
        pc <= newPC;
    
    always_comb
        reg_writeaddr <= (wasel == 2'b00) ? instr[15:11] :
                               (wasel == 2'b01) ? instr[20:16] : 5'b11111; 
                               
    always_comb
        reg_writedata <= (wdsel == 2'b00) ? pcPlusFour : 
                               (wdsel == 2'b01) ? ALUResult : mem_readdata;
    
    always_comb
        mem_addr <= ALUResult;
    
    always_comb 
        mem_writedata <= ReadData2;
        
    always_comb
        JT <= ReadData1;
        
    always_comb
        aluA <= (asel == 2'b00) ? ReadData1 : 
                      (asel == 2'b01) ? {27'b0, instr[10:6]} : {28'b0,4'b1111};
                      
    always_comb
        signImm <= (sext == 1'b1) ? {{16{instr[15]}}, instr[15:0]} : {{16{1'b0}}, instr[15:0]};
                      
    always_comb
        aluB <= (bsel == 1'b0) ? ReadData2 : signImm;
        
    always_comb
        BT <= pcPlusFour + (signImm << 2);
endmodule
