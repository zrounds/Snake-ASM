`timescale 1ns / 1ps
`default_nettype none

module memIO #(
   parameter Abits = 32,     
   parameter Dbits = 32,     
   parameter Nloc = 8192,
   parameter dmem_init = "dmem.txt",
   parameter smem_init = "smem.txt"
)(

   input wire clock,
   input wire wr,
   input wire [Abits-1 : 0] Addr,
   input wire [10:0] screenAddr,
   input wire [Dbits-1 : 0] WriteData,
   input wire [Dbits-1:0] keyb_char,
   output logic [Dbits-1 : 0] ReadData,
   output logic [3:0] charcode
   );


   wire datawr, screenwr;
   wire [3:0] screenData;
   wire [Dbits-1:0] dmemData;
   screenmem #(11,4,1200, smem_init) smem(clock, screenwr, Addr, screenAddr, WriteData, screenData, charcode);
   dmem #(13,32,8192, dmem_init) dmem(clock, datawr, Addr, WriteData, dmemData);
   
        assign datawr = ((wr) && (Addr[14:13] == 2'b01)) ? 1'b1 : 1'b0;
             
        assign screenwr = ((wr) && (Addr[14:13] == 2'b10)) ? 1'b1 : 1'b0;
        
        assign ReadData = (Addr[14:13] == 2'b11) ? keyb_char :
                          (Addr[14:13] == 2'b01) ? dmemData : 
                          (Addr[14:13] == 2'b10) ? screenData : {32{1'b0}};
endmodule