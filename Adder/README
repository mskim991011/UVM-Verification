# UVM Verification: Combinational Adder

This directory contains the foundational UVM (Universal Verification Methodology) testbench for an 8-bit combinational adder. 

While the Device Under Test (DUT) is a simple combinational logic circuit, the primary objective of this project is to construct a **complete, from-scratch UVM verification topology** and establish a standard Transaction Level Modeling (TLM) communication flow between components.

##  Architecture & Features
- **DUT:** 8-bit Adder (`y = a + b` where output `y` is 9-bit to prevent overflow).
- **UVM Topology:** Standard hierarchical structure (`uvm_env` → `uvm_agent` & `uvm_scoreboard`).
- **Constraint-Driven Randomization:** Generates 100 randomized transaction items to provide robust stimulus to the DUT.
- **Automated Checking:** The scoreboard receives broadcasted transactions via `uvm_analysis_port` and verifies data integrity.

##  How to Run (Linux / Synopsys VCS)
The simulation environment is fully automated using GNU Make.
```bash
# Compile and Run the simulation
make run

# Clean build files and logs
make clean
```
*(Note: Running the simulation will automatically dump the waveform into `build/wave.fsdb` for Verdi debugging.)*

##  Expected Output Log
When the simulation runs successfully, the UVM Scoreboard will evaluate the results and print the matching status:
```text
UVM_INFO @ 0: reporter [RNTST] Running test adder_test...
UVM_INFO tb/tb_adder.sv(110) @ 10000: uvm_test_top.ENV.SCB [SCB] PASS! -> a:124 + b:89 = y:213
UVM_INFO tb/tb_adder.sv(110) @ 20000: uvm_test_top.ENV.SCB [SCB] PASS! -> a:45 + b:210 = y:255
...
UVM_INFO tb/tb_adder.sv(154) @ 1000000: uvm_test_top [ADDER_TEST] Objection Test Message!
```
