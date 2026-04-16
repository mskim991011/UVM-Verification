module baud_rate_gen #(
    parameter int SYS_CLK = 100_000_000,
    parameter int BAUD_RATE = 9600
) (
    input  logic     clk,
    input  logic     reset,
    output logic     tick
);
    localparam int CLK_DIV = SYS_CLK / (BAUD_RATE * 16) ;
    localparam int CNT_W = $clog2(CLK_DIV);
    logic [CNT_W-1:0] cnt;

    always_ff @( posedge clk, posedge reset) begin 
        if (reset) begin
            cnt <= 0;
            tick <= 1'b0;
        end else begin
            if (cnt == CLK_DIV - 1) begin
                cnt <=0;
                tick <= 1'b1;
        end else begin
                cnt <= cnt + 1;
                tick <=1'b0;
            end
        end
    end
endmodule
