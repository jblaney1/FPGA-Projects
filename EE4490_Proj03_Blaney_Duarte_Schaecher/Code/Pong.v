module Pong(PPosition, CPosition, BPosition, PScore, CScore, Up, Down, start, win, clkB, CLK_100MHz, Reset);
	output	[23:0] 	PPosition,CPosition,BPosition;					// 24bit output registers used to draw the paddles and ball on the screen.
	output			PScore,CScore,clkB;								// 1bit outputs used to track the scoring flags and a clock to syncronize the counter.
	input			Up, Down, start, win, CLK_100MHz, Reset;		// 1bit inputs from the user and the board to update the state of the game.

	wire			clkP,clkC,clkB;									// 1bit wires used to pass altered clock signals into the different modules.
	wire			score;											// 1bit wire used to pass the score flag from ball into CLK_Divider.
	
	CLK_Divider		clk(clkP, clkC, clkB, start, win, score, CLK_100MHz, Reset);				// A module used to slow down processing on the paddles and ball
	Player			player(PPosition,PScore,CScore,Up,Down,clkP,Reset);							// A module used to track the position of the players paddle.
	Computer		computer(CPosition,BPosition,PScore,CScore,clkC,Reset);						// A module used to track the position of the computers paddle.
	Ball			ball(BPosition,PScore,CScore,PPosition,CPosition,score,win,clkB,Reset);		// A module used to track the position of the ball and scoring flags.
	
endmodule