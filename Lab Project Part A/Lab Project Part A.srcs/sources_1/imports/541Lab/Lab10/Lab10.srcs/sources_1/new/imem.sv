`timescale 1ns / 1ps
`default_nettype none

module imem#(
   parameter Abits = 32,
   parameter Dbits = 32,
   parameter Nloc = 64,
   parameter imem_init = "sqr_imem.txt"
)(
    input wire [31:0] pc,  
    output logic [31:0] instr
    );
    
    logic [Dbits-1:0] rf [Nloc - 1: 0];  
    initial $readmemh(imem_init, rf, 0, Nloc - 1);
    
    wire [Dbits - 1:0] addr_trimmed = {2'b00, pc[Abits-1:2]}; 
    
    assign instr = rf[addr_trimmed]; 
    
endmodule
