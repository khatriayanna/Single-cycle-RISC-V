**Single-Cycle RISC-V Processor with ISA-Level Accelerator Integration**

**Overview**
This project presents the design and implementation of a Single-Cycle RISC-V Processor enhanced with an ISA-level hardware accelerator. The processor executes each instruction in a single clock cycle, ensuring simplicity and deterministic timing, while the accelerator extends the base instruction set to improve performance for specialized operations.
The design is implemented using Verilog/SystemVerilog, making it suitable for FPGA prototyping and academic exploration of processor architecture and hardware acceleration.

**Objectives**
Design a functional single-cycle RISC-V CPU based on the RV32I instruction set.
Integrate a custom ISA-level accelerator to offload computationally intensive tasks.
Demonstrate performance improvement through hardware acceleration.
Understand datapath, control logic, and instruction decoding in processor design.

**Key Features**
- RV32I base instruction set support
- Single-cycle execution (1 instruction per clock cycle)
- Modular datapath design
- Custom instruction decoding for accelerator
- Hardware accelerator integration at ISA level
- Verilog/SystemVerilog implementation
- Testbench for functional verification

**Architecture**
1. Core Components
Program Counter (PC) – Holds address of current instruction
Instruction Memory – Stores program instructions
Register File – 32 general-purpose registers
ALU (Arithmetic Logic Unit) – Performs arithmetic/logic operations
Control Unit – Generates control signals based on instruction
Data Memory – Handles load/store operations

3. Accelerator Integration
A custom instruction is added to the ISA.
The control unit identifies this instruction and:
Routes operands to the accelerator
Enables accelerator execution
Writes back result to register file


**Custom Accelerator**
Purpose
The accelerator is designed to perform specialized operations such as:
Vector operations / MAC (Multiply-Accumulate)
Bit manipulation
Signal processing tasks (depending on implementation
Working
Instruction is decoded as a custom opcode
Control signal activates accelerator
Inputs are passed from register file
Accelerator computes result
Result is written back to destination register


**Project Structure**
├── src/│   ├── processor.v│   ├── control_unit.v│   ├── alu.v│   ├── register_file.v│   ├── memory.v│   ├── accelerator.v│├── testbench/│   ├── processor_tb.v│├── docs/│   ├── architecture_diagram.png│└── README.md


**Instruction Flow (Single Cycle)**
Fetch instruction from memory
Decode instruction
Read registers
Execute operation (ALU / Accelerator)
Access memory (if required)
Write back result
All steps occur in one clock cycle.


**Simulation & Testing**
Tools
ModelSim / QuestaSim / Vivado Simulator
Steps
Compile all Verilog files
Run the testbench:
vsim processor_tbrun -all
Observe waveforms for:
PC updates
Register writes
Accelerator activation


**Performance Considerations**
Advantages
Simple design and easy to debug
Deterministic timing
Efficient for small programs
Accelerator improves execution speed for targeted tasks
Limitation
Long clock period due to worst-case instruction delay
Not scalable for complex/high-performance systems
No pipelining or parallel execution



**Applications**
Educational processor design
FPGA-based prototyping
Embedded systems experimentation
Custom hardware acceleration research
