// Homework 3
// Fall 2019
// set PATH=%PATH%;C:\iverilog\bin

module BitCounter(Count,ClearCounter,IncCounter,clk,reset);
	output[7:0] Count;
	input		ClearCounter, IncCounter;
	input		clk, reset;
	reg	[7:0] 	Count, nCount;
	
	always @ (posedge clk) begin
		if (reset) assign Count = 8'b0000_0000;
		else Count <= nCount;
	end
		
	always @ (negedge clk) begin
		if (ClearCounter) nCount <= 8'b0000_0000;
		else if(IncCounter) nCount <= Count + 1;
		else nCount <= Count;		
	end
	
endmodule

module ShiftRegister(CurrentBit,sw,LoadRegister,RotateRegisterLeft,clk,reset);
	output			CurrentBit;
	input	[15:4] 	sw;
	input			LoadRegister, RotateRegisterLeft;
	input			clk, reset;
	
	parameter		DEFAULTREG = 24'h0F0F0F;
	
	reg		[23:0]  TheReg, nTheReg;

	always @ (posedge clk) begin
		if(reset) TheReg <= DEFAULTREG;
		else TheReg <= nTheReg;
	end
	
	always @ (negedge clk) begin
		if(LoadRegister)begin
			nTheReg <= {sw[15:12], 4'b0000, sw[11:8], 4'b0000, sw[7:4], 4'b0000};
		end
		else if(RotateRegisterLeft)begin
			nTheReg <= {nTheReg[22:0], nTheReg[23]};
		end
		else nTheReg <= nTheReg;
	end
	
	assign CurrentBit = TheReg[23];
	
endmodule

module Hex27Seg(Leds,HexVal);
	output	[0:6] 	Leds;
	input	[3:0] 	HexVal;
	reg		[0:6] 	Leds;
	
	always @(HexVal) begin
		case(HexVal)
			4'h0:  Leds = 7'b000_0001;
            4'h1:  Leds = 7'b100_1111;
            4'h2:  Leds = 7'b001_0010;
            4'h3:  Leds = 7'b000_0110;
            4'h4:  Leds = 7'b100_1100;
            4'h5:  Leds = 7'b010_0100;
            4'h6:  Leds = 7'b010_0000;
            4'h7:  Leds = 7'b000_1111;
            4'h8:  Leds = 7'b000_0000;
            4'h9:  Leds = 7'b000_0100;
            4'hF:  Leds = 7'b111_1111;
            default:  Leds = 7'b000_0001;
		endcase
	end
	
endmodule