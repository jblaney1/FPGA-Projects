// A counter to count the score of both the player and the computer from 00 to 11.
// Counting is synchronized with the ball clock and the scoring flags. A capital P
// references something to the palyer, a capital C references something to the computer.
 
module Counter(PTen,POne,CTen,COne,PScore,CScore,win,clk,Reset);
	output [3:0]     PTen,POne,CTen,COne;
	input            PScore,CScore,win,clk,Reset;
	
	reg          twin = 0;													// Temporary 1bit register used to track a win condition.
	reg 	[3:0]state_PT = 0, state_PO = 0, state_CT = 0, state_CO = 0;	// Registers to track the state of the various outputs.
	
	always@(posedge clk, posedge Reset)begin
		// Check to see if the reset switch has been set to high.
		// If the reset has been envoked, set all variables to zero.
		if(Reset) begin	
			state_PT 		<= 4'b0000;
			state_PO 		<= 4'b0000;
			state_CT 		<= 4'b0000;
			state_CO	 	<= 4'b0000;
			twin            <= 0;
		end
		
		// Check to see if either the player or the computer has won the game.
		// Set the temporary win flag accordingly.
		else if((state_PT == 4'b0001 && state_PO == 4'b0001)||
		       (state_CT == 4'b0001 && state_CO == 4'b0001)) twin <= 1;
			   
		// Check to see if the player has scored.
		// Incriment the players score registers accordingly.
		else if(PScore)begin
			if(state_PO < 4'b1001)state_PO = state_PO + 1;
			else if(state_PT < 4'b0001) begin
			state_PO 		<= 4'b0000;
			state_PT	 	<= state_PT + 1;
			end
		end
		
		// Check to see if the computer has scored.
		// Incriment the computers score registers accordingly.
		else if(CScore)begin
			if(state_CO < 4'b1001)state_CO = state_CO + 1;
			else if(state_CT < 4'b0001) begin
			state_CO 		<= 4'b0000;
			state_CT	 	<= state_CT + 1;
			end
		end
		
		// If no one has scored or won, change nothing.
		else twin <= twin;
	end
	
	// Assign the outputs to the appropriate temporary registers.
	assign PTen = state_PT;
	assign POne = state_PO;
	assign CTen = state_CT;
	assign COne = state_CO;
	assign win = twin;
	
endmodule
