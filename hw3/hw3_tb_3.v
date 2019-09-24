// Homework 3 testbench 3
// Fall 2018
// set PATH=%PATH%;C:\iverilog\bin

`timescale 1ns / 1ps
module tbHex27Seg;
	wire	[0:6] 	tLeds;
	reg		[3:0] 	tHexVal;
	
	Hex27Seg	tb(tLeds,tHexVal);
	
	initial begin #100 $finish; end
	initial begin
		$dumpfile("hw3-3.vcd");
		$dumpvars(0,tbHex27Seg);
	end
	
	initial begin
	tHexVal = 4'b0000;
	while (tHexVal < 15)
	#5 tHexVal = tHexVal + 1;
	end
	
endmodule