module control (
    input logic [6:0] opcode,
    output logic reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op
);

