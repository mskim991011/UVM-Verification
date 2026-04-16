interface apb_if(input logic PCLK, input logic PRESETn);

    logic [7:0]        PADDR;
    logic              PWRITE;
    logic              PENABLE;
    logic [31:0]       PWDATA;
    logic              PSEL;
    logic [31:0]       PRDATA;
    logic              PREADY;

    clocking drv_cb @(posedge PCLK);
        default input #1step output #0;
        output PADDR;
        output PWRITE;
        output PENABLE;
        output PWDATA;
        output PSEL;
        input PRDATA;
        input PREADY;
    endclocking

    clocking mon_cb @(posedge PCLK);
        default input #1step;
        input PADDR;
        input PWRITE;
        input PENABLE;
        input PWDATA;
        input PSEL;
        input PRDATA;
        input PREADY;
    endclocking

    modport mp_drv(clocking drv_cb, input PCLK, input PRESETn);
    modport mp_mon(clocking mon_cb, input PCLK, input PRESETn);
endinterface