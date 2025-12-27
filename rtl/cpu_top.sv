module cpu_top (
    input clk,
    input rst_n, 
);

// -------------------------------
    // IF Stage Wires
    // -------------------------------
    logic [31:0] pc;
    logic [31:0] pc_next;
    logic [31:0] pc_plus4;
    logic [31:0] instr;

    // IF/EX pipeline register outputs
    logic [31:0] instr_if_ex;
    logic [31:0] pc_if_ex;

    // -------------------------------
    // EX Stage Wires
    // -------------------------------
    // Instruction decode fields
    logic [4:0] rs1, rs2, rd;
    logic [2:0] funct3;
    logic [6:0] funct7, opcode;
    logic alu_src;        // 0 = rs2, 1 = imm
    logic [31:0] rs1_data, rs2_data;
    logic [31:0] imm;

    // ALU wires
    logic [31:0] alu_op_b;
    logic [2:0] alu_op;
    logic [31:0] alu_result;
    logic [2:0]  alu_cntrl;
    logic zero;

    // Control signals
    logic reg_write;
    logic mem_to_reg;
    logic mem_read;
    logic mem_write;
    logic branch;

    // EX/WB pipeline register wires
    logic [31:0] alu_result_ex_wb;
    logic [31:0] mem_data_ex_wb;
    logic [4:0]  rd_ex_wb;
    logic reg_write_ex_wb;
    logic mem_to_reg_ex_wb;

    // -------------------------------
    // WB Stage Wires
    // -------------------------------
    logic [31:0] mem_data;
    logic [31:0] wb_data;


pc cpu_pc (
    .clk(clk),
    .rst_n(rst_n),
    .pc_next(pc_next),
    .pc(pc)
);

assign pc_plus4 = pc + 4;
assign pc_next = pc_plus4; // For now, no branches/jumps

imem cpu_imem (
    .address(pc),
    .instruction(instr)
);

if_ex_reg cpu_if_ex_reg (
    .clk(clk),
    .rst_n(rst_n),
    .instr_in(instr),
    .pc_plus4(pc_plus4),
    .instr_out(instr_if_ex),
    .pc_out(pc_if_ex)
)

assign opcode = instr_if_ex[6:0];
assign rd = instr_if_ex[11:7];
assign funct3 = instr_if_ex[14:12];
assign rs1 = instr_if_ex[19:15];
assign rs2 = instr_if_ex[24:20];
assign funct7 = instr_if_ex[31:25];

imm_gen cpu_imm_gen (
    .instruct(instr_if_ex),
    .imm(imm)
);

reg_file cpu_reg_file (
    .clk(clk),
    .rst_n(rst_n),
    .rs1_addr(rs1),
    .rs2_addr(rs2),
    .rd_addr(rd_ex_wb),
    .we(reg_write_ex_wb),
    .wd(wb_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

control cpu_control (
    .opcode(opcode),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .alu_src(alu_src),
    .branch(branch),
    .alu_op(alu_op)
);

assign alu_op_b = (alu_src) ? imm : rs2_data;

alu_control cpu_alu_control (
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_cntrl(alu_cntrl)
);

alu cpu_alu (
    .op_a(rs1_data),
    .op_b(alu_op_b),
    .alu_cntrl(alu_cntrl),
    .alu_rslt(alu_result),
    .zero(zero)
);

ex_wb_reg cpu_ex_wb_reg (
    .clk(clk),
    .rst_n(rst_n),
    .alu_result_in(alu_result),
    .rd_in(rd),
    .reg_write_in(reg_write),
    .mem_data_in(mem_data),
    .mem_to_reg_in(mem_to_reg),
    .alu_result_out(alu_result_ex_wb),
    .rd_out(rd_ex_wb),
    .reg_write_out(reg_write_ex_wb),
    .mem_data_out(mem_data_ex_wb),
    .mem_to_reg_out(mem_to_reg_ex_wb)
);

dmem cpu_dmem (
    .clk(clk),
    .address(alu_result),
    .wd(rs2_data),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .rd(mem_data)
);

// WB Stage (MUX)
assign wb_data = (mem_to_reg_ex_wb) ? mem_data_ex_wb : alu_result_ex_wb;

endmodule


