# Microarchitecture — Verilog coursework

Verilog labs, homework, and projects from a Microarchitecture / digital-design course,
plus the lecture slides and a CoolRISC assembler. Each exercise is a small module with a
matching `_tb.v` testbench. Compiled output (`*.out`, `*.vcd`, `build/`) is intentionally
not committed — regenerate it with Icarus Verilog.

## Contents

**Combinational logic**
- `AndGate/`, `HW1/` — basic gates (AND / NAND / NOR)
- `Decoder/`, `Multiplexor1-3/`, `LUT/` — decoders, muxes, lookup tables
- `ALU/` — arithmetic logic unit

**Sequential logic**
- `Counter/` — counter
- `BlockingAndNonBlocking/` — blocking vs non-blocking assignment semantics
- `LCD/`, `Gamepad/` — peripheral interface modules

**Projects**
- `deoMwala-Project1/` — vending machine FSM (coin counter → beverage + change dispensers)
- `deoMwala-Project2/` — register file
- `firstLast-HW2/` — console + gamepad game

**Microarchitecture**
- `CoolRISC_AssemblerV2/` — a CoolRISC assembler in C (`make` to build)

**Course material**
- `Lessons/` — lecture slides (Lessons 1–11)
- `Reference/` — project brief and quiz key

## Running an exercise

```bash
cd ALU
iverilog -o alu ALU.v ALU_tb.v
vvp alu                 # prints the testbench output; writes a .vcd for GTKWave
```
