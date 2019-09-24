// Homework 3 testbench 1
// Fall 2018
// set PATH=%PATH%;C:\iverilog\bin

`timescale 1ns / 1ps
module tbBitCounter;
	wire	[7:0] 	tCount;
	reg				tClearCounter, tIncCounter;
	reg				tclk, treset;
	
	BitCounter	tb(tCount,tClearCounter,tIncCounter,tclk,treset);
	
	initial #1000 $finish;
	initial begin tclk = 0; forever #5 tclk = ~tclk; end
	initial begin
		$dumpfile("hw3-1.vcd");
		$dumpvars(0,tbBitCounter);
	end
	
	initial begin
	tClearCounter = 1;
	tIncCounter = 1;
	treset = 0;
	#10 tClearCounter = 0;
	#100 tIncCounter = 1;
	#500 tClearCounter = 1;
	#100 tClearCounter = 0;
	#200 treset = 1;
	end
	
endmodule