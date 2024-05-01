// A module used to contorl the movement of the ball.
module Ball(minus,score,lose,ball,player1,player2,player3,clk,reset);
  output	[8:0] ball;											// A 9bit register output used to track the position of the ball.
  output          score,lose,minus;									// Two outputs used to track if the player has scored or lost.
  input     [8:0] player1,player2,player3;						// 3 9bit registers used to track the 
  input           clk, reset;
	
	reg [8:0] Position = 9'd135;								// A 9bit register used to store the position of the ball.
	reg [5:0] movement = 6'b000001;								// A 6bit register used to store the movement of the ball.
	reg       minus = 1'b1;										// A 1bit register used to store the direction of the ball.
	reg       SSCORE;											// A 1bit register used to signal a score by the player.
    reg		  SLOSE = 1'b0;										// A 1bit register used to signal a loss by the player.
	
	always @(posedge clk)begin
	    SSCORE = 1'b0;											// Every clock pulse set the score state to zero.
	    if(reset)begin											// If reset is high, set the movement, direction, and lose values to their defaults.
	       movement = 6'd1;
	       minus = 1'b1;
           SLOSE = 1'b0;
        end
	    else if((Position + 1) == player1)begin movement = 6'd31; minus = 1'b1;end		// Else if the ball is next to paddle position 1, move the ball up.
		else if((Position + 1) == player2)begin movement = 6'd1; minus = 1'b1;end		// Else if the ball is next to the middle paddle position, move the ball straight.
		else if((Position + 1) == player3)begin movement = 6'd29; minus = 1'b0;end		// Else if the ball is next to paddle position 3, move the ball down.
	
		// Below is the logic for a player losing the game.
		// The ball did not bounce, instead it is now in the players position.
		// Refer to the wiring diagram to see why we set these bounds the way we did.
		else if((Position == 9'd30)  || (Position == 9'd60) ||
                (Position == 9'd90)  || (Position == 9'd120)||
                (Position == 9'd150) || (Position == 9'd180)||
                (Position == 9'd210) || (Position == 9'd240)||
                (Position == 9'd270) || (Position == 9'd300))begin
                SLOSE = ~SLOSE;															// Set the lose state to high.
				movement = 6'd0;														// Stop the balls movement.
		   end
		
		// Below is the logic for a player to score.
		// The ball is at the opposite end of the screen and needs to bounce.
		// Refer to the wiring diagram to see why we set these bounds the way we did.
		else if((Position == 9'd1)   || (Position == 9'd31) ||
		        (Position == 9'd61)  || (Position == 9'd91) ||
		        (Position == 9'd121) || (Position == 9'd151)||
		        (Position == 9'd181) || (Position == 9'd211)||
		        (Position == 9'd241) || (Position == 9'd271))begin
				if(!minus)begin movement = 6'd31; end									// If the ball was moving up and right, make it move up and left.
				else if(minus)begin movement = 6'd29; end								// If the ball was moving down and right, make it move down and left.
				SSCORE = ~SSCORE;														// Change the score state to high.
				end
		
		// Below is the logic for bouncing off of the bottom of the screen.
		// Refer to the wiring diagram to see why we set this bound the way we did.
		else if(Position < 9'd30)begin													// If the balls position is on the bottom row and
				if(movement == 6'd31)begin movement = 6'd29;end							// if the ball is moving down and to the right, it is now moving up and to the right.
				else begin movement = 6'd31;end											// If the ball is moving down and to the left, it is now moving up and to the left.
				minus = 1'b0;															// Set the direction to up.
				end
				
		// Below is the logic for bouncing off of the top of the screen.
		// Refer to the wiring diagram to see why we set this bound the way we did.
		else if(Position > 9'd270)begin													// If the balls position is on the top of the screen and
				if(movement == 6'd31)begin movement = 6'd29;end							// if the ball is moving up and to the left, it is now moving down and to the left.
				else begin movement = 6'd31;end											// IF the ball is moving up and to the right, it is now moving down and to the right.
				minus = 1'b1;															// Set the direction to down.
				end
	end
	
	always @(negedge clk)begin
        if(reset)Position = 9'd135;														// If reset is high, set the ball to its default position.
        else if(minus)Position = Position - movement;									// If minus is high subtract the movement from the current position
        else Position = Position + movement;											// else add the movement to the current position.
    end
	    
	assign  ball = Position;
	assign	lose = SLOSE;
	assign 	score = SSCORE;
	assign  dir = minus;
endmodule

