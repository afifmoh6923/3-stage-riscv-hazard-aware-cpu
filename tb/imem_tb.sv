module imem_tb;

    logic [31:0] address;
    logic [31:0] instruction;

    imem uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        $display("==== IMEM TEST START ====");

        // Wait for memory to initialize
        #5;

        // Test address 0x00
        address = 32'h00000000;
        #5;
        $display("Addr 0x00 -> Instr = %h", instruction);

        // Test address 0x04
        address = 32'h00000004;
        #5;
        $display("Addr 0x04 -> Instr = %h", instruction);

        // Test address 0x08
        address = 32'h00000008;
        #5;
        $display("Addr 0x08 -> Instr = %h", instruction);

        // Test address 0x0C
        address = 32'h0000000C;
        #5;
        $display("Addr 0x0C -> Instr = %h", instruction);

        $display("==== IMEM TEST END ====");
        $finish;
    end

endmodule
