# Finite State Machine (FSM) — Moore & Mealy Sequence Detector

**Author:** P. Venkatesh Sagar  
**Date:** June 2026  
**Tools:** Verilog HDL · ModelSim · Xilinx Vivado

---

## Overview

Implementation of **Moore and Mealy FSM architectures** in Verilog HDL — both designed as overlapping sequence detectors for the pattern **"101"** on a serial input stream. Includes a self-checking testbench with full state-transition coverage.

### Key Concepts Demonstrated
- State encoding and transition logic
- Moore FSM — output depends only on current state (registered)
- Mealy FSM — output depends on current state AND input (combinational, faster response)
- Full state-transition coverage verification
- Comparative timing analysis between Moore and Mealy outputs

---

## Project Structure

```
FSM-Design-Verification-Verilog/
├── rtl/
│   ├── fsm_moore.v     # Moore FSM implementation
│   └── fsm_mealy.v     # Mealy FSM implementation
├── tb/
│   └── fsm_tb.v        # Self-checking testbench
├── sim/
│   └── (waveform screenshots)
└── README.md
```

---

## State Diagrams

### Moore FSM (4 states)
```
S0 --din=1--> S1 --din=0--> S2 --din=1--> S3
S3 = output "detect" HIGH (registered, 1 cycle delay)
```

### Mealy FSM (3 states)
```
S0 --din=1--> S1 --din=0--> S2 --din=1/detect=1--> S1
detect asserted COMBINATIONALLY during S2->S1 transition
```

---

## Moore vs Mealy — Key Difference

| Aspect | Moore FSM | Mealy FSM |
|--------|-----------|-----------|
| Output depends on | Current state only | Current state + input |
| Output timing | Registered (1 cycle delay) | Combinational (same cycle) |
| States needed | More (extra output state) | Fewer |
| Response time | Slower by 1 clock | Faster - detects immediately |

---

## How to Simulate (ModelSim)

```tcl
vlog rtl/fsm_moore.v rtl/fsm_mealy.v tb/fsm_tb.v
vsim fsm_tb
run -all
```

---

## How to Simulate (Xilinx Vivado)

1. Create new project, add rtl/fsm_moore.v and rtl/fsm_mealy.v
2. Add simulation source tb/fsm_tb.v
3. Set fsm_tb as top simulation module
4. Run Behavioral Simulation

---

## Testbench Results

| Test | Description | Result |
|------|-------------|--------|
| 16-bit sequence sweep | Full state transition coverage | PASS |
| Directed "101" pattern | Mealy detects combinationally | PASS |
| Directed "101" pattern | Moore detects 1 cycle later | PASS |
| Overlap detection | Both FSMs handle overlapping patterns | PASS |

---

## Metastability Note

This design assumes a synchronous din input. In real hardware, an asynchronous input would require a double flip-flop synchronizer before feeding the FSM to prevent metastability - implemented in the companion UART project's RX module.

---

## Skills Demonstrated

- Sequential RTL design (state encoding, transition logic, output decode)
- Moore and Mealy FSM architectures
- Full state-transition coverage verification
- Self-checking testbench with directed test cases
- Comparative timing/latency analysis between FSM types
