# RISC-V 32-bit Single-Cycle CPU in VHDL

This project is a **single-cycle RV32I RISC-V processor** implemented in **VHDL** and simulated in **Xilinx Vivado**.  
It supports a subset of the RISC-V base integer instruction set, including:

- Arithmetic & logical instructions (`add`, `sub`, `and`, `or`, `slt`, etc.)
- Immediate instructions (`addi`, `andi`, `ori`, `slli`, `srli`, `srai`, etc.)
- Memory access (`lw`, `sw`)
- Branches (`beq`, `bne`, `blt`, etc.)
- Jumps (`jal`, `jalr`)

---

## Repository Structure

- src/ # VHDL source files (datapath, control, ALU, regfile, etc.)
- tb/ # Testbenches (tb_riscv and tb_riscv_alt)
- instructions/ # Test programs (machine code .txt + commented versions)
- docs/ # Documentation & diagrams (block diagrams, control unit, waveforms)


---

## Verification
The CPU was verified using **two independent test programs**:

1. **riscvtest.txt** – from *Digital Design and Computer Architecture* textbook.  
   - Covers arithmetic, logic, load/store, and branches.  
   - Simulation confirmed **correct execution**, with final value `25` written to memory address `100`.

2. **riscvtest1.txt** – AI-generated instruction sequence.  
   - Exercises shifts, immediates, load/store, and jumps.  
   - Simulation confirmed **correct execution**, with final store/load sequence writing and reading back the expected value.

✅ Both testbenches completed successfully in simulation.  
Waveform captures and block diagrams are available in the **docs/** folder.  

---

## Documentation
- **Block Diagrams**  
  - Complete datapath + control unit  
  - Detailed control unit (main controller + ALU controller)  
- **Instruction Reference**  
  - Excel file with instruction formats and design notes  
- **Waveforms**  
  - Successful execution results from both testbenches  

---

## How to Run
1. Clone the repository  
2. Open **Vivado**  
3. Add files from `src/` and `tb/` to a project  
4. Run simulation with `tb_riscv.vhd` or `tb_riscv_alt.vhd`  
5. Load program files (`instructions/riscvtest.txt`, etc.) into the instruction memory  
6. Check the TCL console for success messages and view the waveforms  

---

## Author
**Mehmet Akarli** – R&D Electronics Engineer  
Passionate about computer architecture, HDL design, and embedded systems.  

---

## License
This project is released under the **MIT License** – feel free to use and adapt.  
