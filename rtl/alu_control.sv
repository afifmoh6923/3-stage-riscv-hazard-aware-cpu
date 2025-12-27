module alu_control (
    input logic [2:0] alu_op,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic [2:0] alu_cntrl
);

always_comb begin
    if(alu_op == 3'b000) begin
        alu_cntrl = 3'b010; // ADD
    end else if(alu_op == 3'b001) begin
        alu_cntrl = 3'b110; //SUB
    end else if(alu_op == 3'b010) begin // R-TYPE
        case(funct3)
            3'b000: begin
                if(funct7 == 7'b0000000) begin
                    alu_cntrl = 3'b010; // ADD
                end else if(funct7 == 7'b0100000) begin
                    alu_cntrl = 3'b110; // SUB
                end
            end
            3'b111: alu_cntrl = 3'b000; // AND
            3'b110: alu_cntrl = 3'b001; // OR
            3'b100: alu_cntrl = 3'b011; // XOR
            default: alu_cntrl = 3'b010; // Default to ADD
        endcase
    end else if(alu_op == 3'b011) begin // I-TYPE
        case(funct3)
            3'b000: alu_cntrl = 3'b010; // ADDI
            3'b111: alu_cntrl = 3'b000; // ANDI
            3'b110: alu_cntrl = 3'b001; // ORI
            3'b100: alu_cntrl = 3'b011; // XORI
            default: alu_cntrl = 3'b010; // Default to ADDI
        endcase
    end else begin
        alu_cntrl = 3'b010; // Default to ADD
    end
end

endmodule
