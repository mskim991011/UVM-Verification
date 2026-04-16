`ifndef MONITOR_SV
`define MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "apb_ram_seq_item.sv"

class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor)
    uvm_analysis_port #(apb_seq_item) ap;
    virtual apb_if vif;


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual apb_if)::get(this,"","vif", vif)) begin
            `uvm_fatal(get_type_name(), "uvm_config_db ERRER in monitor");
        end
    endfunction

    task collect_transaction();
        apb_seq_item tx;
        @(vif.mon_cb);
        if(vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY) begin
            tx = apb_seq_item::type_id::create("mon_tx");
            tx.PADDR = vif.mon_cb.PADDR;
            tx.PWRITE = vif.mon_cb.PWRITE;
            tx.PWDATA = vif.mon_cb.PWDATA;
            tx.PRDATA = vif.mon_cb.PRDATA;
            tx.PREADY = vif.mon_cb.PREADY;
            tx.PENABLE = vif.mon_cb.PENABLE;
            tx.PSEL = vif.mon_cb.PSEL;
            `uvm_info(get_type_name(), $sformatf("mon tx: %s", tx.convert2string()), UVM_MEDIUM);
            ap.write(tx);
        end

    endtask

    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Monitoring APB bus.............", UVM_MEDIUM);

        forever begin
            collect_transaction();
        end
    endtask
endclass 
`endif
