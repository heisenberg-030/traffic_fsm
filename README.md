# Traffic Light Controller FSM — Verilog HDL

A synthesizable 5-state Finite State Machine (FSM) implementing a 2-way traffic
light controller with pedestrian interrupt logic, written in Verilog HDL and
verified through simulation.

## Features
- 5 FSM states: NS Green, NS Yellow, EW Green, EW Yellow, Pedestrian
- Timer-based state transitions with configurable hold durations
- Pedestrian interrupt input that overrides traffic flow from any state
- Synchronous reset
- Self-checking testbench with 4 assertion checks — all passing

## State Diagram
S0 (NS GREEN,  EW RED)   → 10 cycles → S1

S1 (NS YELLOW, EW RED)   →  3 cycles → S2

S2 (NS RED,    EW GREEN) → 10 cycles → S3

S3 (NS RED,    EW YELLOW)→  3 cycles → S0

Any state + ped_btn=1    →            S4

S4 (ALL RED, WALK=1)     →  5 cycles → S0

## Files
| File | Description |
|------|-------------|
| `traffic.v` | FSM design module |
| `traffic_tb.v` | Self-checking testbench |

## Tools
- **Icarus Verilog** v12.0 — compilation and simulation
- **GTKWave** — waveform visualization

## How to Run

### Prerequisites
Install Icarus Verilog (includes GTKWave):
- Windows: http://bleyer.org/icarus/
- Linux: `sudo apt install iverilog`

### Simulate
```bash
iverilog -o traffic_sim traffic_tb.v traffic.v
vvp traffic_sim
```

### View Waveforms
```bash
gtkwave traffic.vcd
```

## Simulation Output
PASS: S0 - NS GREEN, EW RED verified

PASS: S1 - NS YELLOW, EW RED verified

PASS: S2 - NS RED, EW GREEN verified

PASS: S4 - PEDESTRIAN state verified

## Signal Encoding
| Signal | Bit 2 | Bit 1 | Bit 0 |
|--------|-------|-------|-------|
| ns_light / ew_light | RED | YELLOW | GREEN |

Example: `3'b001` = GREEN, `3'b010` = YELLOW, `3'b100` = RED
