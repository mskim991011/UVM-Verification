#  UVM Verification: Synchronous Single-Port RAM

![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-00599C?style=flat-square)
![UVM](https://img.shields.io/badge/Methodology-UVM_1.2-4CAF50?style=flat-square)
![Simulator](https://img.shields.io/badge/Simulator-Synopsys_VCS-purple?style=flat-square)

> A production-grade UVM verification suite for a 256x16-bit Synchronous RAM, featuring Coverage-Driven Verification (CDV), precise Timing Control via Clocking Blocks, and multiple randomized test scenarios.

##  Project Overview
This project validates a synchronous RAM module with a focus on **Data Integrity** and **Verification Completeness**. The environment is built to be highly scalable, using a base-test architecture to support various test scenarios (Random, All-Address, Burst). It particularly emphasizes professional verification techniques such as using **Associative Arrays** for reference modeling and **Cross-Coverage** to ensure every address bank is thoroughly exercised.

##  Code Implementation Highlights

### 1. RTL Design Analysis (`ram.sv`)
- **Memory Map:** 256 words x 16-bit per word ($2^8 \times 16$).
- **Control Logic:** Synchronous write-enable (`wr`) signal. Data is sampled on the positive clock edge.
- **Data Path:** Features a dedicated 16-bit write data bus (`wdata`) and a 16-bit read data bus (`rdata`), allowing for clear separation of stimulus and monitoring.

### 2. Advanced UVM Verification Features
- **Precise Timing Control (`ram_interface.sv`):** - Implements `clocking blocks` (`drv_cb`, `mon_cb`) to define exact input/output skews.
    - This eliminates **Simulation Race Conditions** and ensures the Driver and Monitor operate in sync with the hardware's setup/hold time requirements.
- **Reference Model Scoreboard (`ram_scoreboard.sv`):** - Uses a SystemVerilog **Associative Array** as a Golden Reference Model to mirror the DUT's memory state.
    - Automatically cross-checks every `rdata` against the predicted value in the `report_phase`, providing a final Match/Mismatch summary.
- **Coverage-Driven Verification (`ram_coverage.sv`):** - **Covergroup `cg_ram`:** Tracks command distribution (`wr` vs `rd`) and address range hit rates.
    - **Cross Coverage:** Defines `cross_wr_addr` to ensure that every address in the specified range has undergone both a Write and a subsequent Read operation.

### 3. Hierarchical Test Scenarios (`ram_test.sv` & `ram_sequence.sv`)
The environment supports multiple test classes inherited from `ram_base_test`:
- **`ram_write_read_test`:** Performs a direct write-then-read sequence for functional basic check.
- **`ram_all_write_read_test`:** Iterates through all 256 addresses to ensure full memory decoding logic is functional.
- **`ram_random_test`:** Stress tests the memory with 100% randomized address and data patterns using constrained randomization.

##  Execution Guide (Linux / Synopsys VCS)
The simulation and debugging flow is fully automated via the `Makefile`.

```bash
# 1. Run the standard Write-Read functional test
make sim

# 2. Run a specific test (e.g., Random Stress Test)
make sim TC=ram_random_test

# 3. Execute simulation and launch Verdi for Waveform debugging
make verdi

# 4. Clean all build artifacts and logs
make clean
```

##  Verification Results (Sample Log)
The Scoreboard automatically validates each transaction and generates a report at the end of the simulation:

```text
UVM_INFO @ 0: reporter [RNTST] Running test ram_write_read_test...
UVM_INFO ram_scoreboard.sv(42) @ 45000: uvm_test_top.scb [ram_scoreboard] WRITE: addr=0x05, data=0xABCD (Stored in Ref Model)
UVM_INFO ram_scoreboard.sv(48) @ 95000: uvm_test_top.scb [ram_scoreboard] PASS: addr=0x05, expected=0xABCD, actual=0xABCD
...
UVM_INFO ram_scoreboard.sv(60) @ 500000: uvm_test_top.scb [ram_scoreboard] ============= Scoreboard Summary =============
UVM_INFO ram_scoreboard.sv(61) @ 500000: uvm_test_top.scb [ram_scoreboard] Total Transactions : 50
UVM_INFO ram_scoreboard.sv(62) @ 500000: uvm_test_top.scb [ram_scoreboard] MATCH : 50 | MISMATCH : 0
UVM_INFO ram_test.sv(28) @ 500100: uvm_test_top [TEST] ram test Complete!
```
