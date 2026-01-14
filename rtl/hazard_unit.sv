// Simple hazard detection unit for 3-stage pipeline (IF, EX, WB)
// Detects load-use hazard: EX-stage instruction is a load (mem_read)
// and its destination register matches either source of the instruction currently in IF.
// Output:
//  - stall: when high, CPU should hold PC and IF/EX should receive a bubble (NOP)

module hazard_unit (
    input  logic        mem_read_ex,   // mem_read for EX-stage instruction
    input  logic [4:0]  rd_ex,         // destination register of EX-stage instruction
    input  logic [31:0] instr_if,      // instruction currently in IF stage (will go to EX next)
    output logic        stall
);

logic [4:0] rs1_if, rs2_if;
assign rs1_if = instr_if[19:15];
assign rs2_if = instr_if[24:20];

always_comb begin
    // Default: no stall
    stall = 1'b0;
    // If EX stage is load and destination matches either source of IF-stage instr, stall
    if (mem_read_ex && (rd_ex != 5'd0) &&
        ((rd_ex == rs1_if) || (rd_ex == rs2_if))) begin
        stall = 1'b1;
    end
end

endmodule