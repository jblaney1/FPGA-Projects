# FPGA Projects

Projects completed for classes on hardware descriptive languages. 
All programming was performed in Verilog and all implementations assume a Basys 3 FPGA.

# Project Descriptions
## ARM Processor (single cycle)
Implements a single cycle arm processor including the control unit, arithmetic logic unit, register file,
instruction memory, and data memory. See "SingleCycleProcessor.v" in ARM Processor (single cycle)/Stage 3-6/Code/
for the top-level module and "tb_SingleCycleProcessor.v" for a test bench. 

## Pong (LED)
Implements Pong using 300 LEDs as a screen and the buttons on the Basys 3 as a controller. See "SimpleSend.v" 
in Pong (LED)/Part 3/Code/ for the top-level module and "Basic Description.pdf" in Pong (LED)/Part 3/Documentation/ 
for a more detailed description of the project.

## Pong (VGA)
Implements Pong on a monitor through a VGA connection. See "VGAStart.v" in Pong (VGA)/Code/ for the top-level
module and "Basic Description.pdf" in Pong (VGA)/Documentation/ for a more detailed description of the project.

## StopWatch
Implements a 10 minute stopwatch with forward, reverse, warp, and rollover functionality.
