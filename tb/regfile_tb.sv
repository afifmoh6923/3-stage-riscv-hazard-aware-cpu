module regfile_tb;

    logic clk;
    logic rst_n;
    logic we;
    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr; 
    logic [4:0] rd_addr;
    logic [31:0] wd;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    regfile dut (
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .wd(wd),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        we = 0;
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        rd_addr = 5'd0;
        wd = 32'd0;
        
        #10; //BASIC WRITE AND READ TEST
        rst_n = 1;
        we = 1;
        rd_addr = 5'd1;
        wd = 32'd67;
        rs1_addr = 5'd1;
        
        #10;
        $display("RS1 Data = %0d (expected 67)", rs1_data);

        #10; //WRITE TO MULTIPLE REGISTERS AND READ BACK
        rd_addr = 5'd2;
        wd = 32'd10;
        rs1_addr = 5'd2;

        #10;
        rd_addr = 5'd3;
        wd = 32'd20;
        rs2_addr = 5'd3;

        #10;
        $display("RS1 Data = %0d (expected 10)", rs1_data);
        $display("RS2 Data = %0d (expected 20)", rs2_data);

        #10;
        we = 0; //DISABLE WRITE AND ATTEMPT TO WRITE
        rd_addr = 5'd4;
        wd = 32'd99;
        rs1_addr = 5'd4;

        #10;
        $display("RS1 Data = %0d (expected 0)", rs1_data);

        #10;
        we = 1;
        rd_addr = 5'd0; //ATTEMPT TO WRITE TO REGISTER 0
        wd = 32'd123;
        rs1_addr = 5'd0;

        #10
        $display("RS1 Data = %0d (expected 0)", rs1_data);

        #10;
        rd_addr = 5'd1; //OVERWITE TEST
        wd = 32'd45; 
        rs1_addr = 5'd1;

        #10;
        $display("RS1 Data = %0d (expected 45)", rs1_data);
        $display("REGFILE TEST COMPLETE");
        $finish;
    end

endmodule