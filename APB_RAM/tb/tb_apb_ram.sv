`include "uvm_macros.svh"
import uvm_pkg::*;

`include "apb_ram_interface.sv"
`include "apb_ram_seq_item.sv"
`include "apb_ram_sequence.sv"
`include "apb_ram_driver.sv"
`include "apb_ram_monitor.sv"
`include "apb_ram_agent.sv"
`include "apb_ram_scoreboard.sv"
`include "apb_ram_coverage.sv"
`include "apb_ram_env.sv"
`include "apb_ram_test.sv"

module tb_apb ();
    logic PCLK;
    logic PRESETn;
    
    always #5 PCLK = ~PCLK;

    apb_if vif (PCLK, PRESETn);

    apb_ram dut(
        .PCLK(PCLK),
        .PRESET(PRESETn),
        .PADDR(vif.PADDR),
        .PWRITE(vif.PWRITE),
        .PENABLE(vif.PENABLE),
        .PWDATA(vif.PWDATA),
        .PSEL(vif.PSEL),
        .PRDATA(vif.PRDATA),
        .PREADY(vif.PREADY)
    );

    initial begin
        uvm_config_db#(virtual apb_if)::set(null,"*","vif",vif);
        run_test();
    end

    
    initial begin
        PCLK= 0;
        PRESETn = 0;
        repeat(5) @(posedge PCLK);
        PRESETn = 1;
    end

    initial begin
        $fsdbDumpfile("novas.fsdb");
        $fsdbDumpvars(0, tb_apb, "+all");
    end
endmodule