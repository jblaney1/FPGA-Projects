// A module used to track the position of the players paddle.
// Utilizes the inputs up and down to track which direction
// the player wants to move the paddle.

module Player(PPosition,PScore,CScore,Up,Down,clkP,Reset);
	output	[23:0]	PPosition;
	input			PScore, CScore, Up, Down, clkP, Reset;
	
	reg	[23:0]	tPPosition = 24'h11E093;	
	
	always @ (posedge clkP)begin
		// Check to see if a reset is required.
		if(Reset || PScore || CScore)begin
			tPPosition <= 24'h11E093;
		end
		
		// If the up button has been pressed and the paddle
		// is not already at the lower bound of the play area
		// move the paddle down the screen.
		else if (Up && (tPPosition[23:12] + 5'd28 < 9'd426))begin 
			tPPosition[23:12] <= tPPosition[23:12] + 1;
		end
		
		// If the down button has been pressed and the paddle
		// is not already at the upper bound of the play area
		// move the paddle up the screen.		
		else if (Down && (tPPosition[23:12] > 9'd175))begin
			tPPosition[23:12] <= tPPosition[23:12] - 1;
		end
		
		// Maintain the current of the paddle position.
		else tPPosition <= tPPosition;
	end
			
	assign PPosition = tPPosition;
	
endmodule