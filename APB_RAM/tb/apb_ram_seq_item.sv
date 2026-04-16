`ifndef RAM_SEQ_ITEM_SV
`define RAM_SEQ_ITEM_SV

`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;



class apb_seq_item extends uvm_sequence_item;
    
    
    rand logic [7:0]   PADDR;
    rand logic         PWRITE;
    rand logic         PENABLE;
    rand logic [31:0]  PWDATA;
    logic              PSEL;
    logic [31:0]       PRDATA;
    logic              PREADY;

    constraint c_addr {PADDR % 4 == 0;}

    `uvm_object_utils_begin(apb_seq_item)
        `uvm_field_int(PADDR, UVM_ALL_ON)
        `uvm_field_int(PWRITE, UVM_ALL_ON)
        `uvm_field_int(PENABLE, UVM_ALL_ON)
        `uvm_field_int(PWDATA, UVM_ALL_ON)
        `uvm_field_int(PSEL, UVM_ALL_ON)
        `uvm_field_int(PRDATA, UVM_ALL_ON)
        `uvm_field_int(PREADY, UVM_ALL_ON)
    `uvm_object_utils_end


    function new(string name = "apb_seq_item");
        super.new(name);
    endfunction

    function string convert2string();
        string op = PWRITE ? "WRITE" : "READ";
        return $sformatf("%s PADDR = 0x%02h PWDATA = 0x%08h PRDATA = 0x%08h", op, PADDR, PWDATA, PRDATA);
    endfunction
endclass 
`endif
