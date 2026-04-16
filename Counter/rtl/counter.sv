module counter (
    input logic         clk,
    input logic         resetn,
    input logic         en,
    output logic [3:0]  count
);
    always_ff @( posedge clk, negedge resetn ) begin 
        if (!resetn) begin
        count <= 0;
        end else begin
            if (en)
            count <= count +1;
        end
    end
endmodule
