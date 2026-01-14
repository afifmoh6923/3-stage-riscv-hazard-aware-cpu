module alu_control_tb;
    logic [2:0] alu_op;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [2:0] alu_cntrl;

    alu_control dut(
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_cntrl(alu_cntrl)
    );

    initial begin
        // Default
        alu_op = 3'b000; 
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #1;

        // ==================================================
        // ALU_OP = 000 (LOAD / STORE → ADD)
        // ==================================================
        funct3 = 3'b101; // Don't care
        funct7 = 7'b01010101; // Don't care
        #1;
        $display("ALU_OP=000 Test #1 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 010)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b000; // Don't care
        funct7 = 7'b0000000;; // Don't care
        #1;
        $display("ALU_OP=000 Test #2 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 010)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b111; // Don't care
        funct7 = 7'b1111111; // Don't care
        #1;
        $display("ALU_OP=000 Test #3 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 010)", funct3, funct7, alu_cntrl);
        #1;

        // ==================================================
        // ALU_OP = 001 (BRANCH → SUB)
        // ==================================================
        alu_op = 3'b001;

        funct3 = 3'b000; // Don't care
        funct7 = 7'b0000000; // Don't care
        #1;
        $display("ALU_OP=001 Test #1 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 110)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b101; // Don't care
        funct7 = 7'b0111011; // Don't care
        #1;
        $display("ALU_OP=001 Test #2 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 110)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b010; // Don't care
        funct7 = 7'b1110000; // Don't care
        #1;
        $display("ALU_OP=001 Test #3 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 110)", funct3, funct7, alu_cntrl);
        #1;

        // =================================================
        // ALU_OP = 010 (R-TYPE)
        // =================================================
        alu_op = 3'b010;

        funct3 = 3'b000; // ADD / SUB
        funct7 = 7'b0000000; // ADD
        #1;
        $display("ALU_OP=010 Test #1 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 010)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b000; // ADD / SUB
        funct7 = 7'b0100000; // SUB
        #1;
        $display("ALU_OP=010 Test #2 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 110)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b111; // AND
        funct7 = 7'b0000000; // Don't care
        #1;
        $display("ALU_OP=010 Test #3 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 000)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b110; // OR
        funct7 = 7'b1111111; // Don't care
        #1;
        $display("ALU_OP=010 Test #4 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 001)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b100; // XOR
        funct7 = 7'b1010101; // Don't care
        #1;
        $display("ALU_OP=010 Test #5 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 011)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b011; // Default case
        funct7 = 7'b0000000; // Don't care
        #1;
        $display("ALU_OP=010 Test #6 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 010)", funct3, funct7, alu_cntrl);
        #1;

        // =================================================
        // ALU_OP = 011 (I-TYPE)
        // =================================================
        alu_op = 3'b011;
        
        funct3 = 3'b000; // ADDI
        funct7 = 7'b0000000; // Don't care
        #1;
        $display("ALU_OP=011 Test #1 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 010)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b111; // ANDI
        funct7 = 7'b1111111; // Don't care
        #1;
        $display("ALU_OP=011 Test #2 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 000)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b110; // ORI
        funct7 = 7'b1010101; // Don't care
        #1;
        $display("ALU_OP=011 Test #3 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 001)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b100; // XORI
        funct7 = 7'b0001110; // Don't care
        #1;
        $display("ALU_OP=011 Test #4 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 011)", funct3, funct7, alu_cntrl);
        #1;

        funct3 = 3'b010; // Default case
        funct7 = 7'b0000000; // Don't care
        #1;
        $display("ALU_OP=011 Test #5 (FUNCT3 = %b, FUNCT7 = %b): ALU_CNTRL = %b (Expected = 010)", funct3, funct7, alu_cntrl);
        #1;
        $finish;
    end
endmodule

        


