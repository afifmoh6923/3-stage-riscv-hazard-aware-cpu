module dmem (
    input clk,
    input logic [31:0] address,
    input logic [31:0] wd,
    input logic mem_read,
    input logic mem_write,
    output logic [31:0] rd
);

logic [31:0] memory [0:255]; // 256 x 32-bit data memory

always_ff @(posedge clk) begin
    if(mem_write) begin
        memory[address[9:2]] <= wd; // Word-aligned access
    end
end

always_comb begin
    if(mem_read) begin
        rd = memory[address[9:2]]; // Word-aligned access
    end else begin 
        rd = 0;
    end
end

endmodule