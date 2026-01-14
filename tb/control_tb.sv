module control_tb;
    logic [6:0] opcode;
    logic reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch;
    logic [2:0] alu_op;

    control dut(
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .alu_op(alu_op)
    );

    initial begin
        // R-type Instruction
        opcode = 7'b0110011;
        #1;
        $display("R-type Instruction: reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, alu_src=%b, branch=%b, alu_op=%b",
                 reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op); //JUST REG_WRITE=1, ALU_OP=010
        #1;

        // I-type Instruction
        opcode = 7'b0010011;
        #1;
        $display("I-type Instruction: reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, alu_src=%b, branch=%b, alu_op=%b",
                 reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op); //REG_WRITE=1, ALU_SRC=1, ALU_OP=011
        #1;

        // Load Instruction
        opcode = 7'b0000011;
        #1;
        $display("Load Instruction: reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, alu_src=%b, branch=%b, alu_op=%b",
                 reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op); //REG_WRITE=1, MEM_READ=1, MEM_TO_REG=1, ALU_SRC=1, ALU_OP=000
        #1;

        // Store Instruction
        opcode = 7'b0100011;
        #1;
        $display("Store Instruction: reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, alu_src=%b, branch=%b, alu_op=%b",
                 reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op);
        #1;

        // Branch Instruction
        opcode = 7'b1100011;
        #1;
        $display("Branch Instruction: reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, alu_src=%b, branch=%b, alu_op=%b",
                 reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op);
        #1;

        // Default Case
        opcode = 7'b1111111;
        #1;
        $display("Default Case: reg_write=%b, mem_read=%b, mem_write=%b, mem_to_reg=%b, alu_src=%b, branch=%b, alu_op=%b",
                 reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, alu_op); // SHOULD ALL BE 0 OR 111
        #1;
    end
endmodule