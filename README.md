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

Suggested FPGA prototyping plan & Next steps
This section is a plan for taking the design from simulation to prototype on an FPGA, plus other recommended improvements for robustness, verification, and usability.

1) Goal: Prototype the CPU on an FPGA, run the programs in `programs/`, observe behavior (PC progression, register values), and measure resource utilization and max frequency.

2) Recommended target boards (beginner-friendly)
   - Xilinx Artix-7/Spartan-6 dev boards (e.g., Digilent Arty A7) — good Vivado support.

3) Required RTL and build changes before FPGA
   - Replace behavioral memories (imem/dmem) with block RAM primitives:
     - For Xilinx: use inferred BRAM or use Xilinx RAMB primitives and initialize with `.mem` via `$readmemh` during simulation and via COE/INIT for bitstream if needed.
     - For open-source flows, infer ROM/RAM in a manner the synthesizer recognizes (single-port/dual-port BRAM inference).
   - Provide a reset/start vector: ensure `.text` is located at the reset address expected by the FPGA implementation (commonly 0x0 or 0x1000 depending on loader).
   - Make `dmem` synchronous for read data if desired (BRAM read latency may be 1 cycle); adapt pipeline to account for BRAM read latency (introduce appropriate pipeline stage or combinational read style that maps to BRAM).
   - Add simple MMIO for peripherals: UART (for prints), LEDs, switches for simple I/O and debugging. A very small UART (baud 115200) is useful to print register values or boot messages.
   - Implement a minimal "bootstrap loader" if you cannot initialize BRAM from bitstream: a simple ROM bootloader in FPGA fabric that loads a program into RAM over UART or SPI.

4) Build flow (Xilinx Vivado example)
   - Create a Vivado project targeting the chosen board.
   - Add RTL files.
   - Add constraints file (.xdc) mapping clocks and UART/LED pins.
   - Synthesize, implement, and generate bitstream. Monitor timing and resource reports.
   - Program FPGA and monitor UART/LED outputs.
   - Debug with Vivado logic analyzer (ILA) or use an on-board USB-UART to print status.

5) Test plan on FPGA
   - Stage 1: Smoke test — program a simple program that sets registers and toggles LEDs; check basic correctness.
   - Stage 2: Memory test — run `store_load.mem` and verify memory contents via reading back and comparing (use UART prints).
   - Stage 3: Hazard & forwarding test — run `load_use.mem` and capture the expected register results; verify the pipeline stalls actually occur (observe PC stays same when expected).
   - Stage 4: Branch test — run `branch_test.mem`; verify taken/not-taken behavior and flush semantics.
   - For visibility: add a small CSR or MMIO that prints PC, current IF instruction, EX rd, mem_read, stall at chosen intervals (e.g., via UART) to validate dynamic behavior.

6) Verification & quality-of-design (medium priority)
   - Add SystemVerilog Assertions (SVA) for important invariants:
     - x0 always zero
     - if `mem_read_ex` asserted and `rd_ex==rs1_if` then `stall` asserted
     - pipeline registers hold values on stall
   - Add more unit tests and a cpu_top integration test that initializes `imem` with a test program and checks registers after N cycles.
   - Consider adding constrained-random tests for sequences of dependent instructions to find corner-case hazards.

7) Performance & resource measurement (on FPGA)
   - Track LUT/FF/BRAM/IO usage and maximum achievable frequency.
   - Measure cycles to run example programs and count stalls using instrumentation — compute CPI (cycles per instruction) for test programs (useful resume metric).

8) Potential advanced next steps (longer-term)
    - Add an instruction decode stage to expand to 4-stage pipeline (IF/ID/EX/WB) and more complex hazard handling.
    - Implement a branch predictor (static or simple dynamic) to reduce branch mispredict cost.
    - Support additional RISC‑V extensions (M, atomic, compressed) or privilege modes.
    - Add JTAG or RISC-V debug module for stepping and memory/register inspection.
    - Run on actual ASIC flow (synthesis + place & route) if targeting silicon.

Estimated effort (rough)
- FPGA smoke prototype (single board, add UART/LED debug, make memories BRAM-friendly): 1–2 weeks (assumes familiarity with Vivado or open-source tools).
- Full test harness + UART-based debug and measurement counters: 1–2 additional weeks.
- Extended verification (SVA, constrained-random tests): 1–3 weeks depending on coverage goals.

Concrete checklist you can use
- [ ] Convert `imem`/`dmem` to inferred BRAM or BRAM primitives and ensure proper initialization.
- [ ] Add UART MMIO and a simple print mechanism.
- [ ] Add `stall_counter` and `cycle_counter` registers exposed via MMIO.
- [ ] Create Vivado project and pin constraints for board.
- [ ] Implement bootloader or initialize BRAM from bitstream (`$readmemh` can initialize BRAM for simulation but on real FPGA use INIT/COE or upload at runtime).
- [ ] Run and validate `basic.mem`, `load_use.mem`, `store_load.mem`, `branch_test.mem` on hardware and capture results.
- [ ] Document measured resource usage and max frequency in a short report.
