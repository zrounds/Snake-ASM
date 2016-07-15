`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2015 02:26:54 PM
// Design Name: 
// Module Name: comparator
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


module comparator(
    input FlagN, FlagV, FlagC, bool0, 
    output comparison
    );
    //bool0 = 1 => unsigned
    assign comparison = (bool0)? ~FlagC : ((FlagN && ~FlagV) || (~FlagN && FlagV)) ; 
    
endmodule
