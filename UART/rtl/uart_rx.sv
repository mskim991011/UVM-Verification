module uart_rx (
    input  logic       clk,
    input  logic       reset,
    input  logic       tick,
    input  logic       rx,         
    output logic [7:0] rx_data,     
    output logic       rx_valid     
);

    typedef enum logic [1:0] {
        IDLE, START, DATA, STOP
    } rx_state_e;

    rx_state_e state;
    logic [3:0] tick_cnt;
    logic [2:0] bit_cnt;
    logic [7:0] shift_reg;


    logic rx_q1, rx_q2;
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            rx_q1 <= 1'b1;
            rx_q2 <= 1'b1; 
        end else begin
            rx_q1 <= rx;
            rx_q2 <= rx_q1;
        end
    end

    
    always_ff @(posedge clk, posedge reset) begin 
        if (reset) begin
            state    <= IDLE;
            tick_cnt <= 0;
            bit_cnt  <= 0;
            rx_data  <= 0;
            rx_valid <= 1'b0;
        end else begin
            
            rx_valid <= 1'b0;

            case (state)
                IDLE : begin
                    if (rx_q2 == 1'b0) begin
                        state    <= START;
                        tick_cnt <= 0;
                        bit_cnt  <= 0;
                    end
                end
                
                START : begin
                    if (tick) begin                        
                        if (tick_cnt == 7) begin
                            tick_cnt <= 0;
                            if (rx_q2 == 1'b0) begin
                                state <= DATA;
                            end else begin
                                state <= IDLE;
                            end
                        end else begin
                            tick_cnt <= tick_cnt + 1;
                        end
                    end
                end
                
                DATA : begin
                    if (tick) begin
                        
                        if (tick_cnt == 15) begin
                            tick_cnt  <= 0;
                            shift_reg <= {rx_q2, shift_reg[7:1]}; 
                            
                            if (bit_cnt == 7) begin
                                bit_cnt <= 0;
                                state   <= STOP;
                            end else begin
                                bit_cnt <= bit_cnt + 1;
                            end
                        end else begin
                            tick_cnt <= tick_cnt + 1;
                        end
                    end
                end
                
                STOP : begin
                    if (tick) begin
                        if (tick_cnt == 15) begin
                            tick_cnt <= 0;
                            state    <= IDLE;
                            rx_data  <= shift_reg; 
                            rx_valid <= 1'b1;      
                        end else begin
                            tick_cnt <= tick_cnt + 1;
                        end
                    end
                end               
                default : state <= IDLE;
            endcase
        end
    end
endmodule