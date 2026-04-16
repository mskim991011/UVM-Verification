`ifndef RAM_TEST_SV
`define RAM_TEST_SV

`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

class ram_base_test extends uvm_test;
    `uvm_component_utils(ram_base_test)

    ram_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
        env = ram_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        run_test_seq();
        phase.drop_objection(this);
        `uvm_info("TEST", "ram test Complete!", UVM_NONE);
    endtask

    virtual task run_test_seq();
    
    endtask
endclass 

class ram_write_read_test extends ram_base_test;
    `uvm_component_utils(ram_write_read_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
    endfunction

    
    virtual task run_test_seq();
        ram_write_read_sequence seq = ram_write_read_sequence::type_id::create("seq");
        seq.num_transaction = 50;
        seq.start(env.agt.sqr);
    endtask
endclass 

class ram_all_write_read_test extends ram_base_test;
    `uvm_component_utils(ram_all_write_read_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
    endfunction

    
    virtual task run_test_seq();
        ram_all_write_read_sequence seq = ram_all_write_read_sequence::type_id::create("seq");
        seq.start(env.agt.sqr);
    endtask
endclass 

class ram_random_test extends ram_base_test;
    `uvm_component_utils(ram_random_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
    endfunction

    
    virtual task run_test_seq();
        ram_random_sequence seq = ram_random_sequence::type_id::create("seq");
        seq.num_transaction = 100;
        seq.start(env.agt.sqr);
    endtask
endclass 
`endif
