`timescale 1ns / 1ps
`default_nettype none

module dmem #(
   parameter Abits = 32,     
   parameter Dbits = 32,     
   parameter Nloc = 32,
   parameter dmem_init="sqr_dmem.txt"
)(

   input wire clock,
   input wire wr,
   input wire [31:0] Addr, 	
   input wire [Dbits-1 : 0] WriteData,
   output logic [Dbits-1 : 0] ReadData
   );

   logic [Dbits-1:0] rf [Nloc - 1: 0];  
   initial $readmemh(dmem_init, rf, 0, Nloc - 1); 

   wire [Abits - 1:0] addr_trimmed;
   
   assign addr_trimmed = Addr[Abits-1:0]; 

   always_ff @(posedge clock)
      if(wr)
         rf[addr_trimmed] <= WriteData;
   
   assign ReadData = rf[addr_trimmed];
   
endmodule