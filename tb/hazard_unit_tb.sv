module hazard_unit_tb;
reg        mem_read_ex;
  reg  [4:0] rd_ex;
  reg [31:0] instr_if;
  wire       stall;

  // Instantiate hazard_unit (DUT)
  hazard_unit uut (
    .mem_read_ex(mem_read_ex),
    .rd_ex(rd_ex),
    .instr_if(instr_if),
    .stall(stall)
  );

  // helper: build a simple instruction with given rs1/rs2 fields
  function automatic [31:0] mk_instr(input [4:0] rs1, input [4:0] rs2);
    mk_instr = (rs1 << 15) | (rs2 << 20); // place rs1 at [19:15], rs2 at [24:20]
  endfunction

  integer pass_count;
  integer fail_count;

  // Task to run a single scenario and check expected stall
  task automatic run_case(
    input string name,
    input bit memr,
    input [4:0] rd,
    input [4:0] rs1,
    input [4:0] rs2,
    input bit expected_stall
  );
    begin
      mem_read_ex = memr;
      rd_ex       = rd;
      instr_if    = mk_instr(rs1, rs2);
      #1; // allow combinational propagation

      $display("[%0t] %s: mem_read_ex=%b rd_ex=%0d rs1=%0d rs2=%0d -> stall=%b (expect %b)",
               $time, name, mem_read_ex, rd_ex, instr_if[19:15], instr_if[24:20], stall, expected_stall);
      if (stall === expected_stall) begin
        pass_count = pass_count + 1;
        $display("  PASS");
      end else begin
        fail_count = fail_count + 1;
        $error("  FAIL: %s expected stall=%b but got %b", name, expected_stall, stall);
      end

      #1;
    end
  endtask

  initial begin
    pass_count = 0;
    fail_count = 0;

    $display("Starting consolidated hazard_unit tests...");

    // 1) Load-use hazard: mem_read_ex=1, rd_ex matches rs1 -> stall=1
    run_case("load-use hazard", 1'b1, 5, 5, 2, 1'b1);

    // 2) No hazard: mem_read_ex=1, rd_ex != rs1/rs2 -> stall=0
    run_case("no hazard", 1'b1, 5, 6, 7, 1'b0);

    // 3) mem_read_ex cleared: mem_read_ex=0 even if rd matches rs1 -> stall=0
    run_case("mem_read cleared", 1'b0, 5, 5, 0, 1'b0);

    // Summary
    $display("Test summary: passed=%0d failed=%0d", pass_count, fail_count);
    if (fail_count == 0) begin
      $display("ALL TESTS PASSED");
    end else begin
      $display("SOME TESTS FAILED");
    end

    #1 $finish;
  end

endmodule