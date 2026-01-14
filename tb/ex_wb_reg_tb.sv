module ex_wb_reg_tb;

    logic clk, rst_n;
    logic [31:0] alu_result_in;
    logic [4:0] rd_in;
    logic reg_write_in;
    logic [31:0] mem_data_in;
    logic mem_to_reg_in;
    logic [31:0] alu_result_out;
    logic [4:0] rd_out;
    logic reg_write_out;
    logic [31:0] mem_data_out;
    logic mem_to_reg_out;

    ex_wb_reg dut(
        .clk(clk),
        .rst_n(rst_n),
        .alu_result_in(alu_result_in),
        .rd_in(rd_in),
        .reg_write_in(reg_write_in),
        .mem_data_in(mem_data_in),
        .mem_to_reg_in(mem_to_reg_in),
        .alu_result_out(alu_result_out),
        .rd_out(rd_out),
        .reg_write_out(reg_write_out),
        .mem_data_out(mem_data_out),
        .mem_to_reg_out(mem_to_reg_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;

        alu_result_in = 32'h00000000;
        rd_in = 5'b00000;
        reg_write_in = 1'b0;
        mem_data_in = 32'h00000000;
        mem_to_reg_in = 1'b0;

        #10;
        rst_n = 1;

        // Cycle 1 
        alu_result_in = 32'hAAAA0001;
        mem_data_in   = 32'h11111111;
        rd_in         = 5'd3;
        reg_write_in  = 1;
        mem_to_reg_in = 0;
        #10;

        $display("C1: alu=%h mem=%h rd=%0d rw=%b m2r=%b", alu_result_out, mem_data_out, rd_out, reg_write_out, mem_to_reg_out);

        // Cycle 2
        alu_result_in = 32'hBBBB0002;
        mem_data_in   = 32'h22222222;   
        rd_in         = 5'd5;
        reg_write_in  = 0;
        mem_to_reg_in = 1;
        #10;

        $display("C2: alu=%h mem=%h rd=%0d rw=%b m2r=%b", alu_result_out, mem_data_out, rd_out, reg_write_out, mem_to_reg_out);

        // Cycle 3
        rst_n = 0;
        alu_result_in = 32'hBBBB0002;
        mem_data_in   = 32'h22222222;   
        rd_in         = 5'd5;
        reg_write_in  = 0;
        mem_to_reg_in = 1;
        #10;

        $display("C3 (after reset): alu=%h mem=%h rd=%0d rw=%b m2r=%b", alu_result_out, mem_data_out, rd_out, reg_write_out, mem_to_reg_out);
        $finish;
    end
endmodule
