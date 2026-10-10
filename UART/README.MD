#  UVM Verification: UART Protocol IP

![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-00599C?style=flat-square)
![UVM](https://img.shields.io/badge/Methodology-UVM_1.2-4CAF50?style=flat-square)
![Simulator](https://img.shields.io/badge/Simulator-Synopsys_VCS-purple?style=flat-square)

> A robust UVM-based verification suite for a Universal Asynchronous Receiver/Transmitter (UART) IP, featuring internal loopback testing, asynchronous timing validation via Baud Rate Generation, and detailed Functional Coverage analysis.

##  Project Overview
This project validates a full-duplex UART module designed for 100MHz system clocks and 9600 Baud rate communication. The verification environment employs a **Loopback Configuration** (`assign u_if.rx = u_if.tx`) to verify that serialized data transmitted by the TX module is accurately reconstructed by the RX module without frame errors or data corruption.

##  Code Implementation Details

### 1. RTL Design Analysis
- **Baud Rate Generator (`baud_rate_gen.sv`)**: Divides the 100MHz system clock to generate a precise `tick` signal for oversampling (16x Baud Rate), ensuring stable data sampling in the middle of the bit period.
- **UART TX/RX FSMs**: Both modules utilize Finite State Machines (FSMs) with `IDLE`, `START`, `DATA`, and `STOP` states.
    - **TX**: Converts 8-bit parallel `tx_data` into a serial bitstream.
    - **RX**: Features a synchronization stage (`rx_q1`, `rx_q2`) to prevent metastability and uses oversampling to detect the `START` bit edge accurately.

### 2. UVM Verification Features
- **Loopback Scoreboarding (`uart_scoreboard.sv`)**: The scoreboard captures the original `tx_data` from the Driver/Monitor and compares it against the `rx_data` sampled by the Monitor upon `rx_valid` assertion. It tracks successful matches and reports any bit-level mismatches.
- **Functional Coverage (`uart_coverage.sv`)**: A specialized `covergroup` is implemented to ensure the stimulus exercises critical data patterns:
    - **Corner Cases**: `zero` (8'h00), `max` (8'hFF).
    - **Pattern Checks**: Alternating bits (`alt_01`: 8'h55, `alt_10`: 8'hAA) and single-bit triggers (`lsb_only`, `msb_only`).
    - **Range Analysis**: Validates distribution across `low`, `med`, and `high` data ranges.
- **Reactive Driver (`uart_driver.sv`)**: The driver monitors the `tx_busy` signal, ensuring transactions are only driven when the hardware is ready to accept new data, thus respecting the hardware backpressure.

##  How to Run (Linux / Synopsys VCS)
The simulation is fully automated via the provided `Makefile`, which includes coverage collection and VCS-specific optimizations.

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
The scoreboard will print a summary of the data matches. The log also shows the functional coverage percentage achieved during the run.

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
