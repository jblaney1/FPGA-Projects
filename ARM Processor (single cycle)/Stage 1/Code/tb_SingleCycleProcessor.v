// tb_SingleCycleProcessor.v
// Test bench for first draft of single-cycle ARM processor.
// "Digital Design and Computer Architecture ARM EDITION," S.L. Harris and D.M. Harris.
// EE 4490 adapted from code by Jerry C. Hamann

// This TB just gets the ARM going.  The program lives in the
//  instruction memory.

`timescale 1ns / 1ns
module tb_SingleCycleProcessor;
  wire    [31:0]  tDBtheRegVal;
  reg     [3:0]   tDBtheReg;
  reg             tclk, treset;

  SingleCycleProcessor    dut(tDBtheRegVal,tDBtheReg,tclk,treset);

  always
    #10 tclk = !tclk;

  initial begin
    $dumpfile("tb_SingleCycleProcessor.vcd");
    $dumpvars(0,tb_SingleCycleProcessor);
    $display("PC       \tInstr    \tReg \tRegister Value");
    $display("------------------------------------------------------");
    $monitor("%8h \t%8h \t%3d \t%8h",dut.PC,dut.Instr,tDBtheReg,tDBtheRegVal);
    tclk=0; treset=1; tDBtheReg=4'b0010;    #20     // Reset (PC)
    treset=0;                               #440    // Should be enough to finish
    $finish;
  end
endmodule
