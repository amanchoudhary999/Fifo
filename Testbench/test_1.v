`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 21:20:57
// Design Name: 
// Module Name: test_1
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


module test_1;

  parameter DSIZE = 8;
  parameter ASIZE = 4;

  // Clock and reset
  reg wclk, rclk, wrst_n, rrst_n;
  reg [DSIZE-1:0] wdata;
  reg winc, rinc;
  wire [DSIZE-1:0] rdata;
  wire wfull, rempty;

  // Instantiate the DUT
  top #(8, 4) dut (
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
  initial begin
    // Reset
    wrst_n = 0; rrst_n = 0;
    winc = 0; rinc = 0;
    wdata = 8'h00;
    #20;
    wrst_n = 1; rrst_n = 1;

    // Write 10 values
    repeat (10) begin
      @(posedge wclk);
      if (!wfull) begin
        wdata <= wdata + 1;
        winc <= 1;
      end else begin
        winc <= 0;
      end
    end
    winc <= 0;

    // Wait before reading
    #30;

    // Read 10 values
    repeat (10) begin
      @(posedge rclk);
      if (!rempty) rinc <= 1;
      else rinc <= 0;
    end
    rinc <= 0;

    // Finish
    #100;
    $finish;
  end

  // Monitor
  initial begin
    $dumpfile("test_1.vcd");
    $dumpvars(0, test_1);
    $display("Time  wdata winc  wfull | rdata rinc rempty");
    forever begin
      @(posedge wclk);
      $display("%4t   %h    %b     %b   |  %h    %b     %b",
        $time, wdata, winc, wfull, rdata, rinc, rempty);
    end
  end

endmodule

