// Lab 10 Level 4
// Fall 2018
// set PATH=%PATH%;C:\iverilog\bin

`timescale 1ns / 1ps
module tb_stopWatch;
	wire [0:6] seg;
    wire [3:0] anode;
    wire         dp;

    reg        start, stop, countDown, lap, timeSet, reset, clock;
	
	stopWatch tb(seg,anode,dp,start,stop,countDown,lap,timeSet,reset,clock);
	
	initial #1500000 $finish;
	initial begin clock = 0; forever #50 clock = ~clock; end
	initial begin
		$dumpfile("Lab10-4.vcd");
		$dumpvars(0,tb_stopWatch);
	end
	
	initial begin
	countDown		= 0;
	stop			= 0;
	start 			= 0;
	reset 			= 0;
	lap 			= 0;
	timeSet			= 0;
	#5 start 		= 1;
	#100 start 		= 0;
	#10000 lap 		= 1;
	#100 lap 		= 0;
	#600500 stop 	= 1;
	#100 timeSet	= 1;
	#100 start		= 1;
	#100 countDown	= 1;
	#60000 timeSet  = 0;
	countDown		= 0;
	stop 			= 0;
	#50 start 		= 0;
	#50 start		= 1;
	end
	
endmodule
