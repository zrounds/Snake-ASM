`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2015 01:54:28 PM
// Design Name: 
// Module Name: ALU
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


module ALU #(parameter N =32) (
    input [N-1:0] A, B,
    output [N-1:0] R,
    input [4:0] ALUfn,
    output FlagZ
    );
    
    wire subtract, bool1, bool0, shft, math, FlagN, FlagC, FlagV;
    assign {subtract, bool1, bool0, shft, math} = ALUfn[4:0];
    
    wire [N-1:0] addsubResult, shiftResult, logicalResult;
    wire comparisonResult;
    
    addsub #(N) AS(A, B, subtract, addsubResult, FlagN, FlagC, FlagV);
    shifter #(N) S(B, A[$clog2(N)-1:0], ~bool1, ~bool0, shiftResult);
    logical #(N) L(A, B, {bool1, bool0}, logicalResult);
    comparator C(FlagN, FlagV, FlagC, bool0, comparisonResult);
    
    assign R = (~shft & math) ? addsubResult : 
               (shft & ~math) ? shiftResult :
               (~shft & ~math) ? logicalResult : {{(N-1){1'b0}}, comparisonResult};
    
    assign FlagZ = ~| R;
endmodule
