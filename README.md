# Fifo
# Parameterized Asynchronous FIFO in Verilog

This project implements a parameterized asynchronous FIFO (First-In, First-Out) buffer in Verilog. It supports independent clock domains, full and empty detection, and safe synchronization using Gray code and double-flop synchronizers.

## ✅ Features

- Dual-clock support (read and write clocks are independent)
- Gray-coded pointers for safe clock domain crossing
- Full and empty condition detection
- Parameterized data width and FIFO depth
- Modular and reusable Verilog design
- Includes two testbenches for simulation and verification

## 📁 Modules

| File            | Description                              |
|-----------------|------------------------------------------|
| `top.v`         | Top-level integration of FIFO            |
| `Fifo_memory.v` | Dual-port RAM for FIFO storage           |
| `w_ptr.v`       | Write pointer and full logic             |
| `r_ptr.v`       | Read pointer and empty logic             |
| `sync_w2r.v`    | Write-to-read pointer synchronizer       |
| `sync_r2w.v`    | Read-to-write pointer synchronizer       |

## 🧪 Testbenches

| File        | Purpose                                                        |
|-------------|----------------------------------------------------------------|
| `test_1.v`  | Writes and reads to/from FIFO, checks full and empty flags     |
| `test_2.v`  | Extended test to verify pointer wraparound and edge conditions |
