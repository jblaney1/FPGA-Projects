// A module used to track the position of the ball. It also contains the logic for scoring.
// The scoring and movement change condiditons are synced to the rising edge of the clock.
// The balls position is changed on the falling edge of the clock. In the following code a 
// capital B references something to the ball, a capital C references something to the 
// computer, and a capital P references something to the player.

module Ball(BPosition,PScore,CScore,PPosition,CPosition,score,win,clkB,Reset);
	output	[23:0]	BPosition;								// A 24bit output register used to track the x and y position of the ball.
	output			PScore, CScore, score;					// Registers to output the scoring flags. 
	input	[23:0]	PPosition, CPosition;					// 24bit inputs used to compare the position of the ball to the player and computer paddles.
	input			win, clkB, Reset;						// Register inputs used for synchronization.
	
	reg	[23:0]	tBPosition = 24'h12C18F;					// A 24bit temporary register used to track the x and y position of the ball.
	reg			xmov = 1;									// A 1bit register used to track the x-direction that the ball is moving.
	reg         ymov = 0;									// A 1bit register used to track the y-direction that the ball is moving.
	reg         straight = 1;								// A 1bit register used to track if the ball should travel in a straight line.
	reg			tscore = 0, tPScore = 0, tCScore = 0;		// Temporary 1bit registers used to track the scoring flags.
	
	// The rising clock edge, used to check scoring conditions and change the balls movement vector.
	always @ (posedge clkB)begin							
		// Check to make sure that Reset has not been envoked and that someone has not scored
		if(Reset || score)begin
			tscore <= 0;
			tPScore <= 0;
			tCScore <= 0;
			xmov <= 1;
			ymov <= 0;
			straight <= 1;
		end 
		
		// Check to see if the ball needs to bounce off of the top or the bottom of the play area.
		// If the ball needs to bounce, invert the direction of the y movement;
		else if ((tBPosition[23:12] == 9'd175) || (tBPosition[23:12] == 11'd424))ymov <= ~ymov;
		
		// Check to see if the ball needs to bounce off of a paddle either the computer or player paddle.
		// If the ball needs to bounce, invert the direction of the x movement. Also, check to see if 
		// the ball should be hit straight.
		else if (((tBPosition[11:0] == PPosition[11:0] + 4'h3) && (tBPosition[23:12] <= PPosition[23:12] + 5'd28) && (tBPosition[23:12] >= PPosition[23:12]))||
				 ((tBPosition[11:0] == CPosition[11:0] - 4'h5) && (tBPosition[23:12] <= CPosition[23:12] + 5'd28) && (tBPosition[23:12] >= CPosition[23:12])))begin
				 xmov <= ~xmov;
				 if(!straight && (tBPosition[23:12] < PPosition[23:12] + 5'd14) && (tBPosition[23:12] > PPosition[23:12] + 12))straight <= 1;
				 else straight <= 0;
		end
		
		// Check to see if the ball is in the players paddle area.
		// If it is, the computer has scored and the flags should be
		// updated accordingly.
		else if (tBPosition[11:0] == 12'h094)begin
				tCScore <= 1;
				tscore <= 1;
		end
		
		// Check to see if the ball is in the computers paddle area.
		// If it is, the player has scored and the flags should be
		// updated accordingly.
		else if (tBPosition[11:0] == 12'h288)begin
				tPScore <= 1;
				tscore <= 1;
		end
		else xmov <= xmov;
	end
	
	// The falling clock edge, used to update the position of the ball.
	always @ (negedge clkB)begin
		// Check to see if the position of the ball needs to be set back to the default.
		if(Reset || score || win)tBPosition <= 24'h12C18F;
		
		// If the ball was hit straight, maintain the current y position 
		// and move the ball in the correct x-direction.
		else if (straight)begin
			if(xmov)tBPosition[11:0] <= tBPosition[11:0] + 4'h1;
			else tBPosition[11:0] <= tBPosition[11:0] - 4'h1;
		end
		
		// Check the x-direction and update the balls x-position accordingly.
		// Then check the y-direction and update the balls y-position accordingly.
		else begin
			if(xmov)begin
				tBPosition[11:0] <= tBPosition[11:0] + 4'h1;
				if(ymov)tBPosition[23:12] <= tBPosition[23:12] + 4'h1;
				else tBPosition[23:12] <= tBPosition[23:12] - 4'h1;
			end
			else begin
				tBPosition[11:0] <= tBPosition[11:0] - 4'h1;
				if(ymov)tBPosition[23:12] <= tBPosition[23:12] + 4'h1; 
				else tBPosition[23:12] <= tBPosition[23:12] - 4'h1;
		    end
		end
	end
	
	// Assign the output ports to the correct temporary variables.
	assign BPosition = tBPosition;
	assign CScore = tCScore;
	assign PScore = tPScore;
	assign score = tscore;
	
endmodule