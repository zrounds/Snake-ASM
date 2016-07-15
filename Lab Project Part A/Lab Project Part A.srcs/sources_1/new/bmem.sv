`timescale 1ns / 1ps
`default_nettype none

module bmem#(
   parameter Abits = 12,
   parameter Dbits = 12,
   parameter Nloc = 1024,
   parameter bmem_init = "bmem.txt"
)(
    input wire [Abits - 1:0] addr,  
    output logic [Dbits-1:0] value
    );
    
    logic [Dbits-1:0] rf [Nloc - 1: 0];  
    initial $readmemh(bmem_init, rf, 0, Nloc - 1); 
    
    assign value = rf[addr]; 
    
endmodule
