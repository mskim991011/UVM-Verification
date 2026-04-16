`ifndef COVERAGE_SV
`define COVERAGE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "apb_ram_seq_item.sv"

class apb_coverage extends uvm_subscriber#(apb_seq_item);

    `uvm_component_utils(apb_coverage)
    apb_seq_item tx;

    covergroup apb_cg;

        cp_addr: coverpoint tx.PADDR {
            bins addr_low = {[8'h00 : 8'h3C]};
            bins addr_mid1 = {[8'h40 : 8'h7C]};
            bins addr_mid2 = {[8'h80 : 8'hBC]};
            bins addr_high = {[8'hC0 : 8'hFC]};
        }
        cp_write: coverpoint tx.PWRITE{
            bins write_op = {1'b1};
            bins read_op = {1'b0};
        }
        cp_wdata : coverpoint tx.PWDATA {
        bins all_zeros       = {32'h0000_0000};
        bins all_ones        = {32'hFFFF_FFFF};
        bins all_5         = {32'h5555_5555}; 
        bins all_a          = {32'hAAAA_AAAA}; 
        

        bins small_values    = {[32'h0000_0001 : 32'h0000_00FF]};
        bins mid_values      = {[32'h0000_0100 : 32'h00FF_FFFF]};
        bins large_values    = {[32'h0100_0000 : 32'hFFFF_FFFE]};

        
        }
        cp_rdata : coverpoint tx.PRDATA {
            bins zeros        = {32'h0};
            bins ones         = {32'hFFFF_FFFF};
            bins small_values = {[32'h0000_0001 : 32'h0000_00FF]};
            bins mid_values   = {[32'h0000_0100 : 32'h00FF_FFFF]};
            bins large_values = {[32'h0100_0000 : 32'hFFFF_FFFE]}; 
        }  
        
        cx_addr_rw : cross cp_addr, cp_write;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        apb_cg = new();
    endfunction

    function void write (apb_seq_item t);
        tx = t;
        apb_cg.sample();
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "==========================================================", UVM_LOW);
        `uvm_info(get_type_name(), "                  APB Coverage Summary                    ", UVM_LOW);
        `uvm_info(get_type_name(), "==========================================================", UVM_LOW);
        `uvm_info(get_type_name(), $sformatf(" [OVERALL   ] : %.1f%%", apb_cg.get_coverage()), UVM_LOW);
        `uvm_info(get_type_name(), $sformatf(" [ADDRESS   ] : %.1f%%", apb_cg.cp_addr.get_coverage()), UVM_LOW);
        `uvm_info(get_type_name(), $sformatf(" [WR/RD OP  ] : %.1f%%", apb_cg.cp_write.get_coverage()), UVM_LOW);
        `uvm_info(get_type_name(), $sformatf(" [WRITE DATA] : %.1f%%", apb_cg.cp_wdata.get_coverage()), UVM_LOW);
        `uvm_info(get_type_name(), $sformatf(" [READ DATA ] : %.1f%%", apb_cg.cp_rdata.get_coverage()), UVM_LOW);
        `uvm_info(get_type_name(), $sformatf(" [ADDR x RW ] : %.1f%%", apb_cg.cx_addr_rw.get_coverage()), UVM_LOW);
        `uvm_info(get_type_name(), "==========================================================", UVM_LOW);
    endfunction
endclass
`endif
