module if_ex_reg_tb;

    logic clk;
    logic rst_n;
    logic [31:0] instr_in;
    logic [31:0] pc_plus4;
    logic [31:0] instr_out;
    logic [31:0] pc_out;

    if_ex_reg dut(
        .clk(clk),
        .rst_n(rst_n),
        .instr_in(instr_in),
        .pc_plus4(pc_plus4),
        .instr_out(instr_out),
        .pc_out(pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        instr_in = 32'h00000000;
        pc_plus4 = 32'h00000000;
        #10;

        rst_n = 1;

        // Test case 1
        instr_in = 32'hA5A5A5A5;
        pc_plus4 = 32'h00000004;
        #10;

        $display("Test Case 1:");
        $display("instr_out = %h (expected A5A5A5A5)", instr_out);
        $display("pc_out = %h (expected 00000004)", pc_out);

        // Test case 2
        instr_in = 32'h5A5A5A5A;
        pc_plus4 = 32'h00000008;
        #10;

        $display("Test Case 2:");
        $display("instr_out = %h (expected 5A5A5A5A)", instr_out);
        $display("pc_out = %h (expected 00000008)", pc_out);

        #10;
        $display("Test Case 3 (Holding Values):");
        $display("instr_out = %h (expected 5A5A5A5A)", instr_out);
        $display("pc_out = %h (expected 00000008)", pc_out);

        #10;
        rst_n = 0;

        #10;

        $display("After Reset:");
        $display("instr_out = %h (expected 00000000)", instr_out);
        $display("pc_out = %h (expected 00000000)", pc_out);
        $finish;
    end

endmodule
