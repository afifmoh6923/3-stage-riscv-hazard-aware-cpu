# 3-stage-riscv-hazard-aware-cpu

A small educational 3-stage RISC‑V-like CPU (IF → EX → WB) with simple hazard detection and forwarding logic. The design implements:
- Basic RISC-V instruction support for arithmetic, loads/stores, and branches (14 Total Instructions).
- Immediate generation for I/S/B/L types.
- A load-use hazard detector that stalls the pipeline when an EX-stage load would be used by the next instruction.
- A simple WB→EX forwarding path to forward writeback results into EX-stage operands.

This repository includes RTL and unit tests for components.

Table of contents
- Features
- Repository layout
- How the pipeline works (brief)
- Simulation / running tests
- Recommended checks & known limitations
- Contributing

Features
- 3 pipeline stages: IF (fetch), EX (execute + memory access), WB (writeback).
- Load-use stall detection in `rtl/hazard_unit.sv`.
- Forwarding from the WB stage to EX stage to avoid some stalls.
- Unit tests for key modules (imm_gen, alu, control, hazard_unit, etc.) in `tb/`.

Repository layout
- rtl/ — SystemVerilog RTL
  - cpu_top.sv — top-level module which connects IF/EX/EX/WB pipeline and units
  - hazard_unit.sv — load-use hazard detection
  - imm_gen.sv — immediate extraction
  - alu.sv — arithmetic and logic unit
  - control.sv — control signal generation (opcode → control)
  - regfile.sv — register file
  - if_ex_reg.sv, ex_wb_reg.sv — pipeline registers
  - imem.sv / dmem.sv — simple memories (models)
- tb/ — testbench files
- vivado/ — simulation/run artifacts (Xilinx Vivado simulation outputs)
- README.md — this document

How the pipeline works (brief)
- IF: instruction fetch from `imem` using the PC.
- EX: decode + ALU operation; loads/stores access `dmem` in this stage.
- WB: values from EX are written back to the `regfile` via the EX/WB register.
- Hazards:
  - Load-use hazard: if EX-stage instruction is a load (mem_read_ex) and its destination register matches either source register of the instruction in IF, the `hazard_unit` asserts `stall`, which freezes PC and IF/EX (or injects a bubble depending on the IF/EX implementation).
  - Forwarding: when the WB stage will write a register that EX needs, the `wb_data` is forwarded into EX combinationally to avoid stalls.

Simulation / running tests
- Preferred simulators: Questa (ModelSim), Synopsys VCS, Cadence Xcelium. Verilator can be used for a subset but may require testbench adaptation. I personally used Vivado's built in waveform analysis.
- Example (Questa / XSIM / VCS style — adapt as needed):
  - Compile/Simulate a unit test:
    - vlog/ vlogan or vcs compilation commands depending on your simulator
    - run the tb (e.g., `vsim -c tb.module -do "run -all; quit"`)
  - Example testbenches:
    - `tb/imm_gen_tb.sv`
    - `tb/hazard_unit_tb.sv`
    - `tb/*` other module tests
- I provided a combined hazard testbench (consolidated tb_hazard_all.sv) that checks the main hazard scenarios (load-use, no-hazard, mem_read cleared).

Recommended checks & known limitations
- Confirm `if_ex_reg` semantics: on a stall, IF/EX must be held or a bubble inserted; on a branch taken, IF/EX must be flushed.
- Branch handling: current branch logic uses `zero` for decision — ensure the ALU and `control` handle all branch types you intend to support (BEQ, BNE, BLT, BGE, etc.).
- Ensure `x0` (register 0) is correctly implemented as constant zero and writes to x0 are ignored.
- Memory and memory alignment: this project assumes word-aligned accesses by default — add checks if you add byte/halfword support.
- The CPU is intended for learning and small experiments; it is not optimized for performance, and certain corner-cases and advanced RISC‑V instructions are out-of-scope.
