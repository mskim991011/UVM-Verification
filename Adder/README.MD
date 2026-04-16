# UVM Verification: 8-bit Combinational Adder

![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-00599C?style=flat-square)
![UVM](https://img.shields.io/badge/Methodology-UVM_1.2-4CAF50?style=flat-square)
![Simulator](https://img.shields.io/badge/Simulator-Synopsys_VCS-purple?style=flat-square)

> A foundational UVM-based verification environment for an 8-bit adder, focused on establishing a robust Factory-based architecture and Analysis Port communication.

##  Project Overview
This project serves as the entry point to UVM-based verification. Although the DUT is a simple combinational adder, the testbench is architected to demonstrate the core principles of the Universal Verification Methodology: **Object-oriented stimulus generation, transaction-level modeling (TLM), and automated data integrity checking.**

##  Code Implementation Details

### 1. RTL Design Analysis (`adder.sv`)
- **Type:** 8-bit Combinational Adder.
- **Logic:** Uses a simple continuous assignment (`assign y = a + b;`). 
- **Bit-width Consideration:** The output `y` is defined as 9-bit (`[8:0]`) to accommodate the maximum possible sum of two 8-bit values ($255 + 255 = 510$), ensuring no overflow or carry-loss during the verification process.

### 2. UVM Testbench Architecture (`tb_adder.sv`)
- **Factory Registration:** Every class (Sequence Item, Monitor, Driver, etc.) is registered with the `uvm_factory` using macros like `` `uvm_object_utils `` or `` `uvm_component_utils ``, allowing for easy component overrides and dynamic object creation.
- **TLM (Transaction Level Modeling):** - The `adder_monitor` samples the physical interface and broadcasts the data through a `uvm_analysis_port`.
    - The `adder_scoreboard` receives this data through a `uvm_analysis_imp` and performs the golden model comparison.
- **Constraint-Driven Stimulus:** The `adder_sequence` utilizes the `repeat(100)` loop to generate a high volume of randomized transactions, ensuring that various combinations of inputs are tested automatically without manual test vectors.

##  How to Run (Linux / Synopsys VCS)
The simulation is fully automated via the `Makefile`.

```bash
# 1. Run the entire simulation flow (Compile -> Sim)
make run

# 2. To change the randomization seed for different test vectors
make run SEED= ????

# 3. Clean all build artifacts
make clean
```

##  Expected Output Log
The Scoreboard logs each transaction and validates the result. The test will finalise with an "Objection Test Message" indicating a clean shutdown of the simulation phases.

```text
UVM_INFO @ 0: reporter [RNTST] Running test adder_test...
UVM_INFO tb_adder.sv(110) @ 10000: uvm_test_top.ENV.SCB [SCB] PASS! -> a:124 + b:89 = y:213
UVM_INFO tb_adder.sv(110) @ 20000: uvm_test_top.ENV.SCB [SCB] PASS! -> a:45 + b:210 = y:255
...
UVM_INFO tb_adder.sv(154) @ 1000000: uvm_test_top [ADDER_TEST] Objection Test Message!
```
