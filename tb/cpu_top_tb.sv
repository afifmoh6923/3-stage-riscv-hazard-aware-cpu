module cpu_top_tb;

logic clk;
logic rst_n;

cpu_top dut (
    .clk(clk),
    .rst_n(rst_n)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 time units clock period
end

initial begin
        rst_n = 0;
        #20;
        rst_n = 1;
end

always @(posedge clk) begin
    $display("PC=%h instr=%h alu=%h wb=%h rd=%0d we=%b",
        dut.pc,
        dut.instr,
        dut.alu_result_ex_wb,
        dut.wb_data,
        dut.rd_ex_wb,
        dut.reg_write_ex_wb
    );
end

// -----------------------------
// Program Loader
// -----------------------------
initial begin
    // Wait for reset
    @(negedge rst_n);
    @(posedge rst_n);

    // Load program into instruction memory
    // NOTE: hierarchical access
    dut.cpu_imem.memory[0] = 32'h00500093; // addi x1, x0, 5
    dut.cpu_imem.memory[1] = 32'h00A00113; // addi x2, x0, 10
    dut.cpu_imem.memory[2] = 32'h002081B3; // add x3, x1, x2
    dut.cpu_imem.memory[3] = 32'h00302023; // sw x3, 0(x0)
    dut.cpu_imem.memory[4] = 32'h00002203; // lw x4, 0(x0)

    // Optional NOPs
    dut.cpu_imem.memory[5] = 32'h00000013;
    dut.cpu_imem.memory[6] = 32'h00000013;
end

// -----------------------------
// Simulation Control
// -----------------------------
initial begin
    // Run long enough for pipeline to complete
    #300;

    // -----------------------------
    // CHECK RESULTS
    // -----------------------------
    $display("Checking results...");

    if (dut.cpu_reg_file.reg_array[1] !== 32'd5)
        $fatal("FAIL: x1 incorrect");

    if (dut.cpu_reg_file.reg_array[2] !== 32'd10)
        $fatal("FAIL: x2 incorrect");

    if (dut.cpu_reg_file.reg_array[3] !== 32'd15)
        $fatal("FAIL: x3 incorrect");

    if (dut.cpu_reg_file.reg_array[4] !== 32'd15)
        $fatal("FAIL: x4 incorrect");

    $display("=================================");
    $display("PASS: CPU basic test successful!");
    $display("=================================");

    $finish;
end

endmodule
