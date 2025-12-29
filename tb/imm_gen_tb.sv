module imm_gen_tb;

    logic [31:0] instr;
    logic [31:0] imm;

    imm_gen dut (
        .instruct(instr),
        .imm(imm)
    );

    initial begin
        // Test I-type instruction
        instr = 32'b000000000001_00000_000_00001_0010011; // ADDI x1, x0, 1
        #10;
        $display("I-type Imm = %0d (expected 1)", imm);

        // Test S-type instruction
        instr = 32'b0000000_00010_00001_010_00010_0100011; // SW x2, 2(x1)
        #10;
        $display("S-type Imm = %0d (expected 2)", imm);

        // Test B-type instruction
        instr = 32'b0000000_00010_00001_000_00100_1100011; // BEQ x1, x2, 3
        #10;
        $display("B-type Imm = %0d (expected 4)", imm);

        // Test Load-type instruction
        instr = 32'b000000000100_00001_010_00010_0000011; // LW x2, 4(x1)
        #10;
        $display("Load-type Imm = %0d (expected 4)", imm);

        $display("IMM GEN TEST COMPLETE");
        $finish;
    end

endmodule