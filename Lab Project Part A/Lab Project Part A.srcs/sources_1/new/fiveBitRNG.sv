`timescale 1ns / 1ps
`default_nettype none

module fiveBitRNG
   #(parameter BITS = 5)
   (
    input wire clk,
    input wire reset,
    output reg [4:0] data
    );

   reg [4:0] data_next;
   always_comb begin
      data_next = data;
      repeat(BITS) begin
         data_next = {(data_next[4]^data_next[1]), data_next[4:1]};
      end
   end

   always_ff @(posedge clk or negedge reset) begin
      if(!reset)
         data <= 5'h1f;
      else
         data <= data_next;
   end

endmodule
