module Automate(aGo, aclk, bclk, Go, clk, reset);
	output 		aGo, aclk, bclk;
	input  		Go, clk, reset;

	reg [14:0] count1 = 15'b0;						// A counter used to delay the clock to the same speed as our wait time for sending bits.
	reg [25:0] count2 = 26'b0, count3 = 26'b0;		// Counters used to delay the processing of new outputs in Pong.
	reg			S = 1'b0, cS = 1'b0, cBS = 1'b0;	// S used to track the aGo state, cS used to track clock A state, cBS used to track clock B state.
	
	always @ (posedge clk)begin
	   if(Go)begin									// As long as Go remains high the LED processing clock will run.
		   if(count1 == 15'd28100)begin 			// If the counter has reached the hold time reset it and change the aGo state.
			    S <= !S;							
			    count1 <= 0;					
		     end
		     else count1 <= count1 + 1;				// Else continue to count.
		end
		else S <= 0;								// If Go is low do nothing.
	end
		
	always @ (posedge clk) begin
        if(Go)begin							        // As long as Go remains high the player clock will run.
            if(count2 == 26'h4C4B40)begin			// If the counter has counted for half a second reset it and change the A clock state.
                count2 <= 26'b0;				
                cS <= !cS;
            end
            else count2 <= count2 + 1;				// Else continue to count.
        end
    end
    
    always @(posedge clk) begin
      if(Go)begin									// As long as Go remains high the ball clock will run.
              if(count3 == 26'h4C4B40)begin			// If the counter has counted for a second reset it and change the B clock state.
                 count3 <= 26'b0;
                 cBS <= !cBS;
              end	
              else count3 <= count3 + 1;			// Else continue counting.
      end
    end
    	
	assign aGo = S;
	assign aclk = cS;
	assign bclk = cBS;
endmodule