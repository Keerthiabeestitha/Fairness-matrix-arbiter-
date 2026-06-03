# Fairness-matrix-arbiter-
Fairness Matrix Arbiter implemented in Verilog HDL for efficient and starvation-free resource allocation in multi-requestor systems. Includes RTL design, simulation, and verification testbench.

<img width="1494" height="476" alt="Waveform" src="https://github.com/user-attachments/assets/9e36d706-1139-4757-a008-56473f39d638" />

4-Channel Arbiter with Fairness Logic

Overview

This repository contains a Verilog implementation of a 4-channel Arbiter
designed for FPGA/RTL applications. The module manages access to a shared
resource by taking four independent request signals and issuing a single grant
at any given time.

The design focuses on Fairness, ensuring that no single requester can monopolize
the resource and that all requests are eventually serviced (preventing
starvation).

Features

  - 4-bit Input/Output: Supports up to 4 masters/requesters.
  - Mutual Exclusion: Only one grant is sanctioned at a time (One-hot encoding).
  - Fairness Policy: Implements logic to rotate priority among requesters.
  - Synchronous Design: Driven by a system clock with an active-low asynchronous
    reset.

Signal Definitions

| Signal Name  | Direction | Width | Description                                          |
| :----------- | :-------- | :---- | :--------------------------------------------------- |
| `clk`        | Input     | 1     | System Clock                                         |
| `rst_n`      | Input     | 1     | Active-low Reset                                     |
| `req[3:0]`   | Input     | 4     | Request signals from 4 different sources             |
| `grant[3:0]` | Output    | 4     | Sanctioned grant (Only one bit high at a time)       |
| `N`, `W`     | Parameter | 32    | Configurable bit-width parameters for internal logic |

Simulation Results

The provided waveform demonstrates the arbitration logic in action:

1.  Reset Phase: At the start of the simulation, rst_n is low, and all grants
    are held at 0.
2.  Request Handling: When multiple requests are asserted (e.g., req = 0xF or
    1111), the arbiter selects only one bit to pull high in the grant vector.
3.  Fairness Check: As seen in the waveform, the grant signal changes over time
    (switching between 1, 2, 4, and 8) even if the requests remain constant,
    proving that the arbiter is cycling through masters fairly.

Simulation Waveform

How to Use

1.  Clone the Repository:
    git clone https://github.com/your-username/Arbiter_fairness.git
2.  Open in Vivado:
      - Launch Xilinx Vivado.
      - Click Open Project and select project_12.xpr.
3.  Run Simulation:
      - Go to the 'Flow Navigator' on the left.
      - Click Simulation > Run Behavioral Simulation.
      - Observe the grant signals in the waveform viewer to verify the fairness
        logic.

Project Structure

  - project_12.xpr: The main Vivado project file.
  - project_12.srcs/: Contains the Verilog source code (.v) and testbench files.
  - project_12.srcs/constrs_1/: Contains the .xdc constraint files (if
    applicable).

