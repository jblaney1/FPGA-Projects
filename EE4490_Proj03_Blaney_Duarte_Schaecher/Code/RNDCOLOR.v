// A module that creates different colors by adding 
// set amounts to specific bits in a 12bit register.

module RNDCOLOR(border,CLK_100MHz);
	output [11:0] border;
	input 		  CLK_100MHz;
	
	reg	   [27:0] counter = 28'b0;					// A 28bit register used as a clock divider
	reg	   [11:0] tborder = 12'b0;					// A 12bit temporary register used to hold the colors.
	
	always @ (posedge CLK_100MHz)begin
		// Check to see if the clock divider has ticked
		if(counter == 28'h5F5E100)begin
			counter <= 0;
			tborder[3:0] <= tborder[3:0] + 1;		// Add 1 to the RED shown on the display
			tborder[7:4] <= tborder[7:4] + 4;		// Add 4 to the GREEN shown on the display
			tborder[11:8] <= tborder[11:8] + 7;		// Add 7 to the BLUE shown on the dispaly
		end
		else counter <= counter + 1;
	end
	
	assign border = tborder;
	
endmodule