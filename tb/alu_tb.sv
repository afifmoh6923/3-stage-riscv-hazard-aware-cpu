module alu_tb;
    logic [31:0] op_a;
    logic [31:0] op_b;
    logic [2:0] alu_cntrl;
    logic [31:0] alu_rslt;
    logic zero;

    alu dut(
        .op_a(op_a),
        .op_b(op_b),
        .alu_cntrl(alu_cntrl),
        .alu_rslt(alu_rslt),
        .zero(zero)
    );

    initial begin 

        // Test case 1: AND
            alu_cntrl = 3'b000; // AND

            op_a = 32'hFFFFFFFF;
            op_b = 32'h0F0F0F0F;
            #1; //Needs a delay to propagate signals
            $display("AND Test 1: %h & %h = %h (Expected = 0F0F0F0F)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);

            op_a = 32'h00000000;
            op_b = 32'hFFFFFFFF;
            #1;
            $display("AND Test 2: %h & %h = %h (Expected = 00000000)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 1)", zero);

            op_a = 32'hAAAAAAAA;
            op_b = 32'h55555555;
            #1;
            $display("AND Test 3: %h & %h = %h (Expected = 00000000)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 1)", zero);

        // Test case 2: OR
            alu_cntrl = 3'b001; // OR

            op_a = 32'h00000000;
            op_b = 32'h00000000;
            #1;
            $display("OR Test 1: %h | %h = %h (Expected = 00000000)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 1)", zero);

            op_a = 32'hFFFFFFFF;
            op_b = 32'h00000000;
            #1;
            $display("OR Test 2: %h | %h = %h (Expected = FFFFFFFF)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);

            op_a = 32'h674121AB;
            op_b = 32'h12345678;
            #1;
            $display("OR Test 3: %h | %h = %h (Expected = 777577FB)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);
        
        //Test case 3: ADD
            alu_cntrl = 3'b010; // ADD

            op_a = 32'h00000001;
            op_b = 32'h00000001;
            #1;
            $display("ADD Test 1: %h + %h = %h (Expected = 00000002)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);

            op_a = 32'hFFFFFFFF;
            op_b = 32'h00000001;
            #1;
            $display("ADD Test 2: %h + %h = %h (Expected = 00000000)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 1)", zero);

            op_a = 32'h7FFFFFFF;
            op_b = 32'h00000001;
            #1;
            $display("ADD Test 3: %h + %h = %h (Expected = 80000000)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);
        
        // Test case 4: SUB
            alu_cntrl = 3'b110; // SUB

            op_a = 32'h00000005;
            op_b = 32'h00000003;
            #1;
            $display("SUB Test 1: %h - %h = %h (Expected = 00000002)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);

            op_a = 32'h00000003;
            op_b = 32'h00000003;
            #1;
            $display("SUB Test 2: %h - %h = %h (Expected = 00000000)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 1)", zero);

            op_a = 32'h00000002;
            op_b = 32'h00000005;
            #1;
            $display("SUB Test 3: %h - %h = %h (Expected = FFFFFFFD)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);

        // Test case 5: XOR
            alu_cntrl = 3'b011; // XOR

            op_a = 32'hFFFFFFFF;
            op_b = 32'h0F0F0F0F;
            #1;
            $display("XOR Test 1: %h ^ %h = %h (Expected = F0F0F0F0)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);

            op_a = 32'hAAAAAAAA;
            op_b = 32'hAAAAAAAA;
            #1;
            $display("XOR Test 2: %h ^ %h = %h (Expected = 00000000)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 1)", zero);

            op_a = 32'h12345678;
            op_b = 32'h87654321;
            #1;
            $display("XOR Test 3: %h ^ %h = %h (Expected = 95511559)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);
        
        // Test case 6: SLT
            alu_cntrl = 3'b111; // SLT

            op_a = 32'h00000003;
            op_b = 32'h00000005;
            #1;
            $display("SLT Test 1: %h < %h = %h (Expected = 00000001)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);

            op_a = 32'h00000005;
            op_b = 32'h00000003;
            #1;
            $display("SLT Test 2: %h < %h = %h (Expected = 00000000)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 1)", zero);

            op_a = 32'hFFFFFFFF; // -1 in signed
            op_b = 32'h00000001;
            #1;
            $display("SLT Test 3: %h < %h = %h (Expected = 00000001)", op_a, op_b, alu_rslt);
            #1;
            $display("Zero Flag: %b (Expected = 0)", zero);
        $finish;
    end

endmodule