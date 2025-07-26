`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 21:34:00
// Design Name: 
// Module Name: test_2
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


// =============================================================
// Extended Testbench for fifo1 (tests full and empty)
// =============================================================

`timescale 1ns / 1ps

module test_2;

  parameter DSIZE = 8;
  parameter ASIZE = 4;
  localparam DEPTH = 1 << ASIZE;

  // Clock and reset
  reg wclk, rclk, wrst_n, rrst_n;
  reg [DSIZE-1:0] wdata;
  reg winc, rinc;
  wire [DSIZE-1:0] rdata;
  wire wfull, rempty;

  // Instantiate the DUT
  top #(DSIZE, ASIZE) dut (
    .rdata(rdata),
    .wfull(wfull),
    .rempty(rempty),
    .wdata(wdata),
    .winc(winc),
    .wclk(wclk),
    .wrst_n(wrst_n),
    .rinc(rinc),
    .rclk(rclk),
    .rrst_n(rrst_n)
  );

  // Clock generation
  initial begin
    wclk = 0; forever #5 wclk = ~wclk; // 100 MHz
  end

  initial begin
    rclk = 0; forever #7 rclk = ~rclk; // ~71.4 MHz
  end

  // Stimulus
  integer i;
  initial begin
    $dumpfile("test_2.vcd");
    $dumpvars(0, test_2);

    wrst_n = 0; rrst_n = 0;
    winc = 0; rinc = 0;
    wdata = 8'h00;
    #20;
    wrst_n = 1; rrst_n = 1;

    // Fill FIFO completely
    for (i = 0; i < DEPTH; i = i + 1) begin
      @(posedge wclk);
      if (!wfull) begin
        wdata <= i;
        winc <= 1;
        $display("[%0t] WRITE: wdata=%h | wfull=%b", $time, wdata, wfull);
      end else begin
        winc <= 0;
        $display("[%0t] WRITE BLOCKED: FIFO FULL", $time);
      end
    end
    winc <= 0;

    // Wait before reading
    repeat (10) @(posedge wclk);

    // Empty FIFO completely
    for (i = 0; i < DEPTH; i = i + 1) begin
      @(posedge rclk);
      if (!rempty) begin
        rinc <= 1;
        $display("[%0t] READ: rdata=%h | rempty=%b", $time, rdata, rempty);
      end else begin
        rinc <= 0;
        $display("[%0t] READ BLOCKED: FIFO EMPTY", $time);
      end
    end
    rinc <= 0;

    // Finish
    #100;
    $finish;
  end

endmodule
