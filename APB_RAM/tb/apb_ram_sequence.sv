`ifndef APB_SEQUENCE_SV
`define APB_SEQUENCE_SV


`include "uvm_macros.svh"
import uvm_pkg::*;
`include "apb_ram_seq_item.sv"

class apb_base_seq extends uvm_sequence #(apb_seq_item);
    `uvm_object_utils(apb_base_seq)
    int num_loop = 0; 

    function new(string name = "apb_base_seq");
        super.new(name);
    endfunction

    task do_write(bit [7:0] addr, bit [31:0] data);
        apb_seq_item item;
        item = apb_seq_item::type_id::create("item");
        start_item(item);
        if (!item.randomize() with {PWRITE == 1'b1; PADDR ==addr; PWDATA ==data;}) `uvm_fatal(get_type_name(), "do_write() Randomize Fail!!");
        finish_item(item);
        `uvm_info(get_type_name(), $sformatf("do_write() write send complete : addr=0x%02h data = 0x%08h", addr, data), UVM_MEDIUM);
    endtask

    task do_read(bit [7:0] addr, output bit [31:0] rdata);
        apb_seq_item item;
        item = apb_seq_item::type_id::create("item");
        start_item(item);
        if (!item.randomize() with {PWRITE == 1'b0; PADDR ==addr;}) `uvm_fatal(get_type_name(), "do_read() Randomize Fail!!");
        finish_item(item);
        rdata = item.PRDATA;
        `uvm_info(get_type_name(), $sformatf("do_read() read send complete : addr=0x%02h data = 0x%08h", addr, rdata), UVM_MEDIUM);
    endtask


    virtual task body();
    endtask
endclass 

class apb_write_read_seq extends apb_base_seq;
    `uvm_object_utils(apb_write_read_seq)
    int num_loop = 0; 
    bit [7:0] addr;
    bit [31:0] wdata, rdata;

    function new(string name = "apb_write_read_seq");
        super.new(name);
    endfunction


    virtual task body();
        for (int i = 0; i<num_loop; i++) begin
            apb_seq_item item = apb_seq_item::type_id::create("item");
            addr = (i%64) * 4;
            wdata = $urandom();
            do_write(addr, wdata);
            do_read(addr, rdata);
        end
    endtask
endclass 

class apb_rand_seq extends apb_base_seq;
    `uvm_object_utils(apb_rand_seq)
    int num_loop = 0;
    bit [7:0] addr;
    bit [31:0] wdata, rdata;

    function new(string name = "apb_rand_seq");
        super.new(name);
    endfunction


    virtual task body();
        repeat(num_loop) begin
            apb_seq_item item = apb_seq_item::type_id::create("item");
            start_item(item);
            if (!item.randomize()) `uvm_fatal(get_type_name(), "Randomize() Fail!");
            finish_item(item);
        end
    endtask
endclass 

class apb_corner_case_seq extends apb_base_seq;
    `uvm_object_utils(apb_corner_case_seq)
    
    function new(string name = "apb_corner_case_seq"); 
        super.new(name); 
    endfunction

    virtual task body();
        bit [7:0] addr = 8'h00;
        bit [31:0] rdata;
        bit [31:0] target_data[] = {
            32'h0000_0000, 
            32'hFFFF_FFFF, 
            32'h5555_5555, 
            32'hAAAA_AAAA,
            32'h0000_0010,
            32'h0011_2233  
        };

        foreach (target_data[i]) begin
            do_write(addr, target_data[i]); 
            do_read(addr, rdata);         
            addr += 4;
        end
    endtask
endclass
`endif
