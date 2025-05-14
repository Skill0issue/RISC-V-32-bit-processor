# 32-bit RISC-V Processor in Verilog

## Overview

This project implements a basic 32-bit RISC-V processor in Verilog HDL. It supports a subset of the RV32I instruction set and includes:

- **32 general-purpose 32-bit registers**
- **4KB of memory (RAM)**
- **Basic instruction support** (Arithmetic, Load/Store, Branch, etc.)

The processor is designed for educational purposes and simulates a minimal but functional RISC-V core.

---

## Features

- **Architecture**: RV32I (Integer base subset)
- **Registers**: 32 general-purpose registers (x0–x31)
- **Memory**: 4KB memory addressable byte-wise
- **Instruction Width**: 32-bit fixed-length instructions
- **Pipeline**: Single-cycle or basic multi-cycle (depending on your implementation)
- **ISA Coverage**:
  - Arithmetic: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SRA`, etc.
  - Immediate: `ADDI`, `ANDI`, `ORI`, etc.
  - Load/Store: `LW`, `SW`
  - Branch: `BEQ`, `BNE`, `BLT`, `BGE`
  - Jump: `JAL`, `JALR`
  - Environment: `ECALL`

---

## File Structure

```bash
riscv_processor/
├── src/
│   ├── alu.v
│   ├── control_unit.v
│   ├── datapath.v
│   ├── register_file.v
│   ├── memory.v
│   ├── riscv_core.v
├── testbench/
│   ├── riscv_tb.v
├── programs/
│   ├── example_program.hex
├── README.md
