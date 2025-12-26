module regfile (
    input clk, 
    input rst_n,
    input we, 
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input [4:0] rd_addr,
    input [31:0] wd,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);
    logic [31:0] reg_array [31:0];

    assign rs1_data = (rs1_addr != 0) ? reg_array[rs1_addr] : 32'b0;
    assign rs2_data = (rs2_addr != 0) ? reg_array[rs2_addr] : 32'b0;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            reg_array <= '{default:0};
        end else if (we && rd_addr != 0) begin
            reg_array[rd_addr] <= wd;
        end
    end

endmodule