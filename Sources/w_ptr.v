`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 21:14:51
// Design Name: 
// Module Name: w_ptr
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


module w_ptr #(parameter ADDRSIZE = 4)
  (output reg wfull,
   output [ADDRSIZE-1:0] waddr,
   output reg [ADDRSIZE  :0] wptr,
   input   [ADDRSIZE  :0] wq2_rptr,
   input    winc, wclk, wrst_n);

  reg  [ADDRSIZE:0] wbin;
  wire [ADDRSIZE:0] wgraynext, wbinnext;
  wire              wfull_val;

  assign wbinnext  = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;
  assign waddr     = wbin[ADDRSIZE-1:0];
  assign wfull_val = (wgraynext == {~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wbin, wptr} <= 0;
    else         {wbin, wptr} <= {wbinnext, wgraynext};

  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wfull <= 1'b0;
    else         wfull <= wfull_val;
endmodule