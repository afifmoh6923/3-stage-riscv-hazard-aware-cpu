module imm_gen (
    input [31:0] instruct,
    output logic [31:0] imm
);

always_comb begin
    case(instruct[6:0])
        7'b0010011: begin // I-Type
            imm = {{20{instruct[31]}}, instruct[31:20]};
        end
        7'b0000011: begin // Load-Type
            imm = {{20{instruct[31]}}, instruct[31:20]};
        end
        7'b0100011: begin // S-Type
            imm = {{20{instruct[31]}}, instruct[31:25], instruct[11:7]};
        end
        7'b1100011: begin // B-Type
            imm = {{19{instruct[31]}}, instruct[31], instruct[7], instruct[30:25], instruct[11:8], 1'b0};
        end
        default: begin
            imm = 32'b0; // Default case
        end
    endcase
end

endmodule
