`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2015 09:17:12 PM
// Design Name: 
// Module Name: fulladder
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


module fulladder(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
    );
    
    wire t1, t2, t3;
    xor x1(t1, A, B);
    xor x2(Sum, Cin, t1); 
    and a1(t2, A, B);
    and a2(t3, Cin, t1);
    or o1(Cout, t3, t2);
    
endmodule
