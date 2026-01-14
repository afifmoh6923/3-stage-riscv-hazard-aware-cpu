module if_ex_reg (
    input  logic clk,
    input  logic rst_n,
    input  logic [31:0] instr_in,
    input  logic [31:0] pc_plus4,
    input  logic stall,   // when asserted: insert a bubble into EX and hold PC in IF
    input  logic flush,   // when asserted: flush EX (e.g., branch taken)
    output logic [31:0] instr_out,
    output logic [31:0] pc_out
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        instr_out <= 32'd0;
        pc_out    <= 32'd0;
    end else if (flush) begin
        // Flush EX (convert next EX instruction into a NOP)
        instr_out <= 32'd0;
        pc_out    <= 32'd0;
    end else if (stall) begin
        // On load-use hazard: insert bubble into EX (NOP). IF/PC will be held by cpu_top (pc_next = pc).
        instr_out <= 32'd0;
        pc_out    <= 32'd0;
    end else begin
        instr_out <= instr_in;
        pc_out    <= pc_plus4;
    end
end

endmodule