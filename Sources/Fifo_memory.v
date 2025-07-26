`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 21:10:46
// Design Name: 
// Module Name: Fifo_memory
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


module Fifo_memory #(parameter DATASIZE = 8, parameter ADDRSIZE = 4)
  (output [DATASIZE-1:0] rdata,
   input  [DATASIZE-1:0] wdata,
   input  [ADDRSIZE-1:0] waddr, raddr,
   input  wclken, wfull, wclk);

  localparam DEPTH = 1<<ADDRSIZE;
  reg [DATASIZE-1:0] mem [0:DEPTH-1];

  assign rdata = mem[raddr];

  always @(posedge wclk)
    if (wclken && !wfull)
      mem[waddr] <= wdata;
endmodule
