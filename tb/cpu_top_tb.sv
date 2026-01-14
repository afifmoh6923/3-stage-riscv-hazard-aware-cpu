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

// Reset: hold low for 20 time units, then release
initial begin
    rst_n = 0;
    #20;
    rst_n = 1;
end

// Per-cycle display (extended for debug)
always @(posedge clk) begin
    $display("t=%0t PC=%08h instr=%08h instr_if_ex=%08h rs1=%0d rs2=%0d rs1_d=%0d rs2_d=%0d alu=%08h wb=%08h rd=%0d we=%b",
        $time,
        dut.pc,
        dut.instr,
        dut.instr_if_ex,
        dut.instr_if_ex[19:15],
        dut.instr_if_ex[24:20],
        dut.cpu_reg_file.rs1_data,
        dut.cpu_reg_file.rs2_data,
        dut.alu_result_ex_wb,
        dut.wb_data,
        dut.rd_ex_wb,
        dut.reg_write_ex_wb
    );
end

// -----------------------------
// Program Loader (UPDATED)
// -----------------------------
// Load the program into instruction memory while CPU is held in reset.
// This ensures the first fetch sees the correct instructions and prevents
// races where the CPU fetches before the TB writes the memory.
initial begin
    // Wait until reset is asserted (low)
    // This will synchronize to the reset initial block so writes happen while CPU is held in reset.
    wait (rst_n === 1'b0);

    // Load program into instruction memory (hierarchical access)
    dut.cpu_imem.memory[0] = 32'h00500093; // addi x1, x0, 5
    dut.cpu_imem.memory[1] = 32'h00A00113; // addi x2, x0, 10
    dut.cpu_imem.memory[2] = 32'h002081B3; // add x3, x1, x2
    dut.cpu_imem.memory[3] = 32'h00302023; // sw x3, 0(x0)
    dut.cpu_imem.memory[4] = 32'h00002203; // lw x4, 0(x0)

    // Optional NOPs
    dut.cpu_imem.memory[5] = 32'h00000013;
    dut.cpu_imem.memory[6] = 32'h00000013;

    // Small handshake: wait a posedge to ensure memory writes are stable before reset release
    @(posedge clk);
    $display("%0t: Program loaded into imem. mem0=%08h mem1=%08h mem2=%08h", $time, dut.cpu_imem.memory[0], dut.cpu_imem.memory[1], dut.cpu_imem.memory[2]);

    // Keep this initial block done; reset release happens in the reset initial block above.
end

// -----------------------------
// Simulation Control & Check
// -----------------------------
initial begin
    // Run long enough for pipeline to complete
    #300;

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