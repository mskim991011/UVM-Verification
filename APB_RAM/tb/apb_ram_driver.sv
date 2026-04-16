`ifndef DRIVER_SV
`define DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "apb_ram_seq_item.sv"

class apb_driver extends uvm_driver #(apb_seq_item);
    `uvm_component_utils(apb_driver)
    virtual apb_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
        if (!uvm_config_db#(virtual apb_if)::get(this,"","vif", vif)) begin
            `uvm_fatal(get_type_name(), "uvm_config_db ERRER in driver");
        end
    endfunction

    task apb_bus_init();
        vif.drv_cb.PSEL <=0;
        vif.drv_cb.PENABLE <=0;
        vif.drv_cb.PWRITE <=0;
        vif.drv_cb.PADDR <=0;
        vif.drv_cb.PWDATA <=0;
    endtask

    task drive_apb(apb_seq_item tx);
        @(vif.drv_cb);
        vif.drv_cb.PSEL <= 1;
        vif.drv_cb.PENABLE <= 0;
        vif.drv_cb.PWRITE <= tx.PWRITE;
        vif.drv_cb.PADDR <= tx.PADDR;
        vif.drv_cb.PWDATA <= (tx.PWRITE) ? tx.PWDATA : 0;
        @(vif.drv_cb);
        vif.drv_cb.PENABLE <= 1;
        while(!vif.drv_cb.PREADY) @(vif.drv_cb);
        if (!tx.PWRITE) begin
            tx.PRDATA = vif.drv_cb.PRDATA;
            tx.PREADY = vif.drv_cb.PREADY;
        end
        @(vif.drv_cb);
        vif.drv_cb.PSEL <= 0;
        vif.drv_cb.PENABLE <= 0;
        `uvm_info(get_type_name(), $sformatf("drv apb run complete!! %s", tx.convert2string()), UVM_MEDIUM);
    endtask

    virtual task run_phase(uvm_phase phase);
        apb_bus_init();
        wait(vif.PRESETn ==1);
        `uvm_info(get_type_name(), "RESET OFF Waiting for transaction....", UVM_MEDIUM);
        forever begin
            apb_seq_item tx;
            seq_item_port.get_next_item(tx);
            drive_apb(tx);
            seq_item_port.item_done();
        end
    endtask
endclass 
`endif
