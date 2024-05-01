// A stopwatch counter modified to count the players score from 0000 to 9999.

module Counter(PTen,POne,CTen,COne,PScore,CScore,win,clk,Reset);
	output [3:0]     PTen,POne,CTen,COne;
	output           win;
	input            PScore,CScore,clk,Reset;
	
	reg 	[3:0]state_PT = 0,state_PO = 0,state_CT = 0,state_CO = 0;	// Registers to track the state of the various outputs.
	reg          twin = 0;
	
	always@(posedge clk)begin
		if(Reset) begin
			state_PT 		<= 4'b0000;
			state_PO 		<= 4'b0000;
			state_CT 		<= 4'b0000;
			state_CO	 	<= 4'b0000;
			twin            <= 0;
		end
		else if((state_PT == 4'b0001 && state_PO == 4'b0001)|| 
                (state_PT == 4'b0001 && state_PO == 4'b0001)) twin <= 1;
		else if (CScore)begin
		     if(state_CO < 4'b1001)state_CO <= state_CO + 1;
             else if(state_CT < 4'b0001) begin
                 state_CO         <= 4'b0000;
                 state_CT         <= state_CT + 1;
             end
             else state_CO <= state_CO;
		end
		else if (PScore)begin
		     if(state_PO < 4'b1001)state_PO <= state_PO + 1;
             else if(state_PT < 4'b0001) begin
                state_PO         <= 4'b0000;
                state_PT         <= state_PT + 1;
             end
        end
	    else state_PO <= state_PO;
	end
	
	assign PTen = state_PT;
	assign POne = state_PO;
	assign CTen = state_CT;
	assign COne = state_CO;
	assign win = twin;
	
endmodule
