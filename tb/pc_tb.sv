module pc_tb;

    logic clk;
    logic rst_n;
    logic [31:0] pc_next;
    logic [31:0] pc;

    pc dut (
        .clk(clk),
        .rst_n(rst_n),
        .pc_next(pc_next),
        .pc(pc)
    );

    // 10 ns clk period
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        pc_next = 32'd0;

        // Apply reset
        #10;
        rst_n = 1;

        // Test 1: PC increments
        pc_next = 32'd4;
        #10;
        $display("PC = %0d (expected 4)", pc);

        pc_next = 32'd8;
        #10;
        $display("PC = %0d (expected 8)", pc);

        // Test reset behavior
        rst_n = 0;
        #10;
        $display("PC after reset = %0d (expected 0)", pc);

        // Resume
        rst_n = 1;
        pc_next = 32'd12;
        #10;
        $display("PC = %0d (expected 12)", pc);

        $display("PC TEST COMPLETE");
        $finish;
    end

endmodule
        


