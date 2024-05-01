// A module used to follow the position of the ball with a paddle.
// It is used to create a computer to play Pong against.

module Computer(CPosition,BPosition,PScore,CScore,clkC,Reset);
	output	[23:0]	CPosition;							// A 24bit register used to track the position of the computers paddle.
	input	[23:0]	BPosition;							// A 24bit register used to track the position of the ball.
	input			PScore, CScore, clkC, Reset;		// Inputs to track the state of the game.
	
	reg	[23:0]	tCPosition = 24'h11E28C;				// A 24bit temporary register used to track the position of the computers paddle.
	
	always @ (posedge clkC)begin
		// Check to see if the computers paddle position needs to be reset.
		if(Reset || PScore || CScore)begin
			tCPosition = 24'h11E28C;
		end
		
		// Check to see if the ball is above the paddles acceptable hit zone.
		// If it is, move the paddle up.
		else if (BPosition[23:12] > tCPosition[23:12] + 16 && tCPosition[23:12] + 28 < 426)begin 
			tCPosition[23:12] <= tCPosition[23:12] + 1;
		end
		
		// Check to see if the ball is below the paddles acceptable hit zone.
		// If it is, move the paddle down.
		else if (BPosition[23:12] < tCPosition[23:12] + 14 && tCPosition[23:12] > 175)begin
			tCPosition[23:12] <= tCPosition[23:12] - 1;
		end
		
		// It the ball is in the acceptable hit zone do not move the paddle.
		else tCPosition = tCPosition;
	end
	
	// Assign the temporary computer position to the output computer position.
	assign CPosition = tCPosition;
	
endmodule