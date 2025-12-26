module control (
    input logic [6:0] opcode,
    output logic reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, 
    output logic [2:0] alu_op
);

//ALU OP CONTROL SIGNALS
// ADD: 000
// SUB: 001
// R-TYPE: 010
// I-TYPE: 011
// DEFAULT: 111


always_comb begin
    // Default Values
    reg_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_to_reg = 1'b0;
    alu_src = 1'b0;
    branch = 1'b0;
    alu_op = 3'b111;
    case (opcode)
        7'b0110011: begin // R-type
            reg_write = 1'b1;
            alu_op = 3'b010;
        end
        7'b0010011: begin // I-type
            reg_write = 1'b1;
            alu_src = 1'b1;
            alu_op = 3'b011;
        end
        7'b0000011: begin // Load
            reg_write = 1'b1;
            mem_read = 1'b1;
            mem_to_reg = 1'b1;
            alu_src = 1'b1;
            alu_op = 3'b000; // ADD for address calculation
        end
        7'b0100011: begin // Store
            alu_src = 1'b1;
            mem_write = 1'b1;
            alu_op = 3'b000; // ADD for address calculation
        end
        7'b1100011: begin // Branch
            branch = 1'b1;
            alu_op = 3'b001; // SUB for comparison
        end
        default: begin
            reg_write = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            mem_to_reg = 1'b0;
            alu_src = 1'b0;
            branch = 1'b0;
            alu_op = 3'b111;
        end
    endcase
end

endmodule