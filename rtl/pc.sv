module pc (
    input clk,
    input rst_n,
    input [31:0] pc_next,
    output logic [31:0] pc
);

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pc <= 0;
    end else begin
        pc <= pc_next;
    end
end

endmodule