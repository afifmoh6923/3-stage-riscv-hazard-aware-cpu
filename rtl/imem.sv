module imem (
    input logic [31:0] address,
    output logic [31:0] instruction
);

logic [31:0] memory [0:255]; // 256 x 32-bit instruction memory

initial begin
    $readmemh("program.hex", memory);
end

always_comb begin
    instruction = memory[address[9:2]]; // Word-aligned access
end

endmodule