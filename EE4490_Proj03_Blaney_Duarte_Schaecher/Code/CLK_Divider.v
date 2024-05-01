// A clock divider module used to set the movement speed of the ball and the paddles.
// The ball moves every 1/30 of a second growing faster by subtracting 10 at every tick.
// The paddle clocks tick every 1/30 of a second and are constant.
module CLK_Divider(clkP, clkC, clkB, start, win, score, CLK_100MHz, Reset);
	output		clkP, clkC, clkB;
	input		start, win, score, CLK_100MHz, Reset;
	
	reg	[31:0]	counter1,counter2,counter3;
	reg			tclkB,tclkP,tclkC;	
	
	// Clock divider for the ball.
	// If the ball clock has ticked, increment counter 3
	// which decriments the number of ticks to the next clkB tick.
	always @ (posedge CLK_100MHz)begin
		if(!start || win)tclkB <= 0;
		else if (score)begin counter3 <= 0; tclkB = ~tclkB; end
		else if (counter2 == 24'h07A120 - counter3)begin
			tclkB <= ~tclkB; 
			counter2 <= 24'h0;
			counter3 <= counter3 + 10;
		end
		else counter2 <= counter2 + 1;
	end
	
	// Clock divider for the paddles
	always @ (posedge CLK_100MHz)begin
		if(!start || win)tclkP <= 0;
		else if (counter1 == 24'h07A120)begin
			tclkP <= ~tclkP; 
			counter1 <= 24'h0;
		end
		else counter1 <= counter1 + 1;
	end
			
	assign clkP = tclkP;
	assign clkC = tclkP;
	assign clkB = tclkB;
	
endmodule