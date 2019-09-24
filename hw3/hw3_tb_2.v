// Homework 3 testbench 2
// Fall 2018
// C

`timescale 1ns / 1ps
module tbShiftRegister;
	wire			tCurrentBit;
	reg		[15:4] 	tsw;
	reg				tLoadRegister, tRotateRegisterLeft;
	reg				tclk, treset;
	
	ShiftRegister	tb(tCurrentBit,tsw,tLoadRegister,tRotateRegisterLeft,tclk,treset);
	
	initial #200 $finish;
	initial begin tclk = 0; forever #5 tclk = ~tclk; end
	initial begin
		$dumpfile("hw3-2.vcd");
		$dumpvars(0, tbShiftRegister);
	end
	
	initial begin
	tsw = 12'b000000000000;
	tLoadRegister = 1;
	treset = 0;
	#10	tLoadRegister = 0;
	#5	tRotateRegisterLeft = 1;
	#20	treset = 1;
	#10	treset = 0; tsw = 12'b111111111111;
	#10 tLoadRegister = 1;
	#10 tLoadRegister = 0;
	#10 tRotateRegisterLeft = 1;
	end
endmodule