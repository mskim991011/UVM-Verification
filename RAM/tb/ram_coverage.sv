`ifndef RAM_COVERAGE_SV
`define RAM_COVERAGE_SV

`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

class ram_coverage extends uvm_subscriber #(ram_seq_item);
    `uvm_component_utils(ram_coverage)


    ram_seq_item item;

    covergroup cg_ram;
        option.per_instance = 1;

    
        cp_wr : coverpoint item.wr {
            bins write = {1'b1};
            bins read  = {1'b0};
        }

        
        cp_addr : coverpoint item.addr {
            bins valid_range = {[8'h00 : 8'h0F]};
            bins others = default; 
        }

        cross_wr_addr : cross cp_wr, cp_addr;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent); 
        cg_ram = new(); 
    endfunction


    virtual function void write(ram_seq_item t);
        this.item = t;   
        cg_ram.sample();
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask

endclass 
`endif
