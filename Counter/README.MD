# UVM Verification: 4-bit Sequential Counter

![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-00599C?style=flat-square)
![UVM](https://img.shields.io/badge/Methodology-UVM_1.2-4CAF50?style=flat-square)
![Simulator](https://img.shields.io/badge/Simulator-Synopsys_VCS-purple?style=flat-square)

> A robust UVM-based verification environment for a 4-bit synchronous up-counter, focusing on asynchronous reset recovery, enable-based counting logic, and real-time self-checking.

##  Project Overview
This project validates a sequential counter module. Unlike combinational circuits, sequential logic requires precise clock-edge synchronization and reset state verification. The testbench is designed to stress the DUT (Device Under Test) using randomized enable signals and varied clock cycle delays between transactions.

##  Code Implementation Details

### 1. RTL Design Analysis (`counter.sv`)
- **Type:** 4-bit Synchronous Up-Counter.
- **Reset Logic:** Implements an **Asynchronous Active-Low Reset** (`resetn`). The use of `always_ff @(posedge clk, negedge resetn)` ensures the counter returns to zero immediately when reset is asserted, regardless of the clock.
- **Functionality:** Increments the `count` value only when the `en` (enable) signal is high on the rising edge of the clock, demonstrating a typical gated-clock control behavior.

### 2. UVM Testbench Architecture (`tb_counter.sv`)
- **Self-Checking Monitor:** Instead of a separate Scoreboard, the `counter_monitor` implements an internal reference model. It tracks the `expected_count` and handles the 4-bit wrap-around logic (`count + 1` at 15 returns to 0) to verify the DUT output at every active clock edge.
- **Phased Sequences:**
    - `counter_reset_seq`: Specifically targets the reset recovery phase to ensure the DUT initializes to `4'h0`.
    - `counter_count_seq`: Utilizes a `cycles` constraint (`[1:50]`) in the `seq_item` to simulate irregular intervals between enable toggles, mimicking real-world system bursts.
- **Config DB:** Demonstrates the use of `uvm_config_db` to seamlessly pass the virtual interface (`vif`) from the top-level module down to the Driver and Monitor.

##  How to Run (Linux / Synopsys VCS)
The environment is optimized for Synopsys VCS and supports automated simulation runs via the included `Makefile`.

```bash
# 1. Compile the RTL and TB, then run the simulation
make sim

# 2. To run with a specific seed for randomization
make sim SEED=????

# 3. Clean up all generated simulation files
make clean
```

##  Expected Output Log
Upon execution, the monitor will report matching results for each enable pulse, and the test will conclude with a final pass verdict:

```text
UVM_INFO @ 0: reporter [RNTST] Running test counter_test...
UVM_INFO tb_counter.sv(71) @ 45000: uvm_test_top.env.agt.mon [counter_monitor] SUCCESS! count = 1 (en=1)
UVM_INFO tb_counter.sv(71) @ 85000: uvm_test_top.env.agt.mon [counter_monitor] SUCCESS! count = 2 (en=1)
UVM_INFO tb_counter.sv(71) @ 125000: uvm_test_top.env.agt.mon [counter_monitor] SUCCESS! count = 3 (en=1)
...
UVM_INFO tb_counter.sv(85) @ 315000: uvm_test_top [counter_test] =================TEST PASS ! ===================
```
