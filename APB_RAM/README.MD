#  UVM Verification: AMBA APB Memory Controller

![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-00599C?style=flat-square)
![UVM](https://img.shields.io/badge/Methodology-UVM_1.2-4CAF50?style=flat-square)
![Simulator](https://img.shields.io/badge/Simulator-Synopsys_VCS-purple?style=flat-square)

> The flagship project of the suite: A complete UVM verification environment for a 32-bit RAM module controlled via the industry-standard **AMBA APB Protocol**, featuring multi-phase protocol driving and cross-coverage analysis.

##  Project Overview
[cite_start]This project validates a 64-depth, 32-bit RAM module integrated with an AMBA APB Slave interface[cite: 297, 299]. [cite_start]The primary objective is to verify strict adherence to the APB protocol's state transitions (IDLE → SETUP → ACCESS) while ensuring 100% data integrity during random and corner-case memory operations[cite: 358, 393].


##  Code Implementation Details

### 1. RTL Design Analysis (`apb_ram.sv`)
- [cite_start]**Standard Compliance**: Implements an APB Slave interface supporting `PSEL`, `PENABLE`, `PWRITE`, and `PREADY`[cite: 297, 298].
- [cite_start]**Memory Map**: Features a 32-bit wide memory array (`mem[0:63]`)[cite: 299].
- [cite_start]**Protocol Logic**: Operates on a zero-wait state (`PREADY = 1`) where data is captured at the memory array when `PSEL`, `PENABLE`, and `PWRITE` are all asserted[cite: 299, 300].

### 2. Advanced UVM Verification Architecture
- **Protocol-Aware Driver (`apb_ram_driver.sv`)**: 
    - [cite_start]Meticulously handles the APB two-phase handshake[cite: 358].
    - [cite_start]Driven signals are perfectly timed: `PSEL` and `PADDR` are asserted in the Setup phase, followed by `PENABLE` in the Access phase[cite: 358, 359].
- **Reference Model Scoreboard (`apb_ram_scoreboard.sv`)**:
    - [cite_start]Implements an internal memory model (`ref_mem`) to track the expected state[cite: 388].
    - [cite_start]**Address Mapping**: Automatically shifts addresses (`PADDR >> 2`) to handle word-aligned access verification[cite: 391, 392].
- **Multi-Dimensional Coverage (`apb_ram_coverage.sv`)**: 
    - [cite_start]**Address Ranges**: Tracks distribution across Low, Mid, and High address banks[cite: 334, 335].
    - [cite_start]**Data Patterns**: Monitors for specific patterns like `All Zeros`, `All Ones`, `Alternating Bits (0x55/0xAA)`, and `Large Values`[cite: 337, 338, 339, 340].
    - [cite_start]**Cross Coverage**: Uses `cx_addr_rw` to ensure every memory bank has been exercised for both read and write operations[cite: 345].

##  Execution Guide
[cite_start]Simulation and coverage analysis are fully automated via the provided `Makefile` using Synopsys VCS[cite: 419].

```bash
# 1. Run the default corner case test sequence
make sim

# 2. Run randomized stress testing (10 transactions)
make sim TC=apb_rand_test(one of the sequence tests)

# 3. Analyze 1000 consecutive Write-Read operations
make sim TC=apb_write_read_test

# 4. View Waveforms in Verdi
make verdi

# 5. Analyze detailed Protocol and Functional Coverage
make vc
```

##  Verification Results (Summary Report)
The scoreboard generates a final summary confirming the test status and operation counts[cite: 397, 398]:

```text
UVM_INFO apb_ram_monitor.sv(384) @ 155000: uvm_test_top.agt.mon [apb_monitor] mon tx: WRITE PADDR = 0x1c PWDATA = 0xdeadbeef PRDATA = 0x00000000
UVM_INFO apb_ram_scoreboard.sv(395) @ 205000: uvm_test_top.scb [apb_scoreboard] PASS!!! paddr = 0x1c expected = prdata = 0xdeadbeef
...
UVM_INFO apb_ram_scoreboard.sv(397) @ 1000000: uvm_test_top.scb [apb_scoreboard] **********************Summary Report ********************
UVM_INFO apb_ram_scoreboard.sv(398) @ 1000000: uvm_test_top.scb [apb_scoreboard] Result : ***************PASS***************
UVM_INFO apb_ram_scoreboard.sv(398) @ 1000000: uvm_test_top.scb [apb_scoreboard] write num : 50
UVM_INFO apb_ram_scoreboard.sv(398) @ 1000000: uvm_test_top.scb [apb_scoreboard] read num : 50
UVM_INFO apb_ram_scoreboard.sv(399) @ 1000000: uvm_test_top.scb [apb_scoreboard] error num : 0
```
