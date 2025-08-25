# Computer Organization Labs

- Labs 0-4 aims to construct a classical five stage RISC-V pipeline CPU
- Lab 5 aims to construct a cache manager

## Overview

### Lab 0 – Environment Setup & Verilog Practice	
- Introduce tools and basic HDL workflows
- Set up Verilator & GTKWave, implement a Full Adder and 4-bit ALU with testbenches. 

### Lab 1 – Single-Cycle CPU (Basic RISC-V)	
- Construct a simple CPU pipeline
- Build a single-cycle CPU supporting basic R-V instructions (e.g., add, lw, beq). 

### Lab 2 – Branch Instructions	
- Enhance the CPU with control flow logic
- Extend the CPU to handle branch/jump instructions like jal, jalr, bne, blt, and bge. 

### Lab 3 – Simple Pipelined CPU	
- Introduce pipelining for performance
- Implement a 5-stage pipeline (IF/ID/EX/MEM/WB) without addressing hazards. 

### Lab 4 – Advanced Pipelined CPU	
- Improve pipeline robustness
- Add hazard detection (e.g., load-use), forwarding units, and branch flush logic. 

### Lab 5 – Cache Manager Design	
- Incorporate memory hierarchy behavior
- Build a cache manager (direct-mapped or set-associative) for read/write handling and replacement policies.


## Repo Structure
```
CO2024_source/
├── README.md            ← this overview
├── lab0/                ← Verilog exercises (Full Adder & ALU)
├── lab1/                ← Single-cycle CPU and components
├── lab2/                ← Branch-capable single-cycle CPU
├── lab3/                ← Simple pipelined CPU
├── lab4/                ← Pipelined CPU with hazard units
└── lab5/                ← Cache manager implementation
```

