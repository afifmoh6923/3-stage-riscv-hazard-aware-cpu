module dmem_tb;

    logic clk;
    logic [31:0] address;
    logic [31:0] wd;
    logic mem_read;
    logic mem_write;
    logic [31:0] rd;

    dmem uut ( // Using UUT due to it being a complete functional system which has been predefined
        .clk(clk),
        .address(address),
        .wd(wd),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .rd(rd)
    );

    always #5 clk = ~clk;

    initial begin 
        clk = 0;
        address = 32'h00000000;
        wd = 32'h00000000;
        mem_read = 1'b0;
        mem_write = 1'b0;
        #10;

        mem_write = 1'b1;
        wd = 32'hFFFFFFFF;
        address = 32'h00000004; // Write to address 0x04
        #10;

        mem_write = 1'b0;
        mem_read = 1'b1;
        address = 32'h00000004; // Read from address 0x04
        #10;

        $display("Read from 0x04: rd = %h (expected FFFFFFFF)", rd);

        mem_read = 1'b0;
        mem_write = 1'b1;
        wd = 32'hAAAAAAAA;
        address = 32'h00000008; // Write to address 0x08
        #10;

        mem_write = 1'b0;
        mem_read = 1'b1;
        address = 32'h00000008; // Read from address 0x08
        #10;
        $display("Read from 0x08: rd = %h (expected AAAAAAAA)", rd);

        mem_read = 1'b1;
        address = 32'h00000000; // Read from address 0x00 (not written yet)
        #10;
        $display("Read from 0x00: rd = %h (expected 00000000 or XXXXXXXX)", rd);
        $finish;
    end
endmodule



