module if_ex_reg ( 
    input clk,
    input rst_n,
    input [31:0] instr_in,
    input [31:0] pc_plus4,
    output logic [31:0] instr_out,
    output logic [31:0] pc_out
);

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        instr_out <= 0;
        pc_out <= 0;
    end else begin
        instr_out <= instr_in;
        pc_out <= pc_plus4;
    end
end

endmodule