#  UVM Verification: UART Protocol IP

![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-00599C?style=flat-square)
![UVM](https://img.shields.io/badge/Methodology-UVM_1.2-4CAF50?style=flat-square)
![Simulator](https://img.shields.io/badge/Simulator-Synopsys_VCS-purple?style=flat-square)

> A robust UVM-based verification suite for a Universal Asynchronous Receiver/Transmitter (UART) IP, featuring internal loopback testing, asynchronous timing validation via Baud Rate Generation, and detailed Functional Coverage analysis.

##  Project Overview
[cite_start]This project validates a full-duplex UART module designed for 100MHz system clocks and 9600 Baud rate communication[cite: 185, 191]. [cite_start]The verification environment employs a **Loopback Configuration** (`assign u_if.rx = u_if.tx`) to verify that serialized data transmitted by the TX module is accurately reconstructed by the RX module without frame errors or data corruption[cite: 298].

##  Code Implementation Details

### 1. RTL Design Analysis
- [cite_start]**Baud Rate Generator (`baud_rate_gen.sv`)**: Divides the 100MHz system clock to generate a precise `tick` signal for oversampling (16x Baud Rate), ensuring stable data sampling in the middle of the bit period[cite: 185, 186].
- [cite_start]**UART TX/RX FSMs**: Both modules utilize Finite State Machines (FSMs) with `IDLE`, `START`, `DATA`, and `STOP` states[cite: 195, 220]. 
    - [cite_start]**TX**: Converts 8-bit parallel `tx_data` into a serial bitstream[cite: 230].
    - [cite_start]**RX**: Features a synchronization stage (`rx_q1`, `rx_q2`) to prevent metastability and uses oversampling to detect the `START` bit edge accurately[cite: 197, 203].

### 2. UVM Verification Features
- [cite_start]**Loopback Scoreboarding (`uart_scoreboard.sv`)**: The scoreboard captures the original `tx_data` from the Driver/Monitor and compares it against the `rx_data` sampled by the Monitor upon `rx_valid` assertion[cite: 262, 278]. [cite_start]It tracks successful matches and reports any bit-level mismatches[cite: 267].
- [cite_start]**Functional Coverage (`uart_coverage.sv`)**: A specialized `covergroup` is implemented to ensure the stimulus exercises critical data patterns[cite: 254]:
    - **Corner Cases**: `zero` (8'h00), `max` (8'hFF).
    - [cite_start]**Pattern Checks**: Alternating bits (`alt_01`: 8'h55, `alt_10`: 8'hAA) and single-bit triggers (`lsb_only`, `msb_only`)[cite: 255].
    - [cite_start]**Range Analysis**: Validates distribution across `low`, `med`, and `high` data ranges[cite: 256].
- [cite_start]**Reactive Driver (`uart_driver.sv`)**: The driver monitors the `tx_busy` signal, ensuring transactions are only driven when the hardware is ready to accept new data, thus respecting the hardware backpressure[cite: 283, 284].

##  How to Run (Linux / Synopsys VCS)
[cite_start]The simulation is fully automated via the provided `Makefile`, which includes coverage collection and VCS-specific optimizations[cite: 301].

```bash
# 1. Compile and run the UART random test
make sim

# 2. Run with a custom seed for randomization diversity
make sim SEED= ????

# 3. View detailed coverage results in Verdi
make vc

# 4. Clean build logs and simulation binaries
make clean
```

##  Expected Output Log
The scoreboard will print a summary of the data matches. [cite_start]The log also shows the functional coverage percentage achieved during the run[cite: 260, 267].

```text
UVM_INFO @ 0: reporter [RNTST] Running test uart_rand_test...
UVM_INFO uart_scoreboard.sv(265) @ 105000: uvm_test_top.env.scb [uart_scoreboard] MATCH Success!! tx_data = 0xa5 rx_data = 0xa5
UVM_INFO uart_scoreboard.sv(265) @ 210000: uvm_test_top.env.scb [uart_scoreboard] MATCH Success!! tx_data = 0x55 rx_data = 0x55
...
UVM_INFO uart_coverage.sv(260) @ 500000: uvm_test_top.env.cov [uart_coverage] Coverage: cg_data= 87.5%
UVM_INFO uart_scoreboard.sv(266) @ 500000: uvm_test_top.env.scb [uart_scoreboard] =============Scoreboard Summary==========
UVM_INFO uart_scoreboard.sv(267) @ 500000: uvm_test_top.env.scb [uart_scoreboard] Total transaction: 10
UVM_INFO uart_scoreboard.sv(267) @ 500000: uvm_test_top.env.scb [uart_scoreboard] MATCH: 10
UVM_INFO uart_scoreboard.sv(269) @ 500000: uvm_test_top.env.scb [uart_scoreboard] TEST PASSED!!!! 10 complete
```
