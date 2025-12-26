module alu (
    input logic [31:0] op_a,
    input logic [31:0] op_b,
    input logic [2:0] alu_cntrl,
    output logic [31:0] alu_rslt,
    output logic zero
);

always_comb begin
    alu_rslt = 32'b0; // Default value for edgecases

    case(alu_cntrl)
        3'b000: alu_rslt = op_a & op_b;          // AND
        3'b001: alu_rslt = op_a | op_b;          // OR
        3'b010: alu_rslt = op_a + op_b;          // ADD
        3'b011: alu_rslt = op_a ^ op_b;          // XOR
        3'b110: alu_rslt = op_a - op_b;          // SUB
        3'b111: alu_rslt = ($signed(op_a) < $signed(op_b)) ? 1 : 0; // SLT
        default: alu_rslt = 32'b0;                // Default case
    endcase
end

assign zero = (alu_rslt == 0);

endmodule