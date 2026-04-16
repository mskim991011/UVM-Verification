module uart #(
    parameter int SYS_CLK  = 100_000_000,
    parameter int BAUD_RATE = 9600
) (
    input logic        clk,
    input logic        reset,
    input logic  [7:0] tx_data,
    input logic        tx_start,
    output logic       tx,
    output logic       tx_busy,
    input  logic       rx,
    output logic [7:0] rx_data,
    output logic       rx_valid
);
    logic tick;

    baud_rate_gen #(.SYS_CLK(SYS_CLK), .BAUD_RATE(BAUD_RATE)) u_tick (.*);
    uart_tx u_uart_tx (.*);
    uart_rx u_uart_rx (.*);
endmodule