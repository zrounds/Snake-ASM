`timescale 1ns / 1ps
`default_nettype none

module screenmem #(
   parameter Abits = 11,     
   parameter Dbits = 4,     
   parameter Nloc = 1200,
   parameter smem_init="smem.txt"
)(

   input wire clock,
   input wire wr,
   input wire [31:0] Addr,
   input wire [Abits-1 : 0] DisplayAddr,
   input wire [31:0] WriteData,
   output logic [Dbits-1 : 0] ReadData, DisplayData
   );

   logic [Dbits-1:0] rf [Nloc - 1: 0];  
   initial $readmemh(smem_init, rf, 0, Nloc - 1); 

   wire [Abits-1:0] addr_trimmed;
   wire [Dbits-1:0] write_data_trimmed;
   
   assign addr_trimmed = Addr[Abits-1:0];
   assign write_data_trimmed = WriteData[Dbits-1:0]; 
   
   always_ff @(posedge clock)
      if(wr)
         rf[addr_trimmed] <= write_data_trimmed;
   
   assign ReadData = rf[addr_trimmed];
   assign DisplayData = rf[DisplayAddr];
   
endmodule