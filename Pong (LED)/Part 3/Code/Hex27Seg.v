module Hex27Seg(Leds,HexVal);
	output [0:6] Leds;		// Active low light selection used to create the players score.
	input  [3:0] HexVal;	// The 4 bit hex value of the number to be represented with LEDs.
	reg    [0:6] Leds;		// A register used to assign the LED output.
	
	always @(HexVal)
	begin
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
			default: Leds = 7'b111_1111; 
		endcase
	end
endmodule