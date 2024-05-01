// GRBStateMachine.v
// Output qmode tells the NZRbitGEN module whether to send a 0, 1, RESET
// Updated to support new WS2812B reset code of > 280 us
// bdone ticks every bit period (1.28 us), RESET is > 280 us, use 281000 clks = 281 us

module GRBStateMachine(qmode,Done,LoadGRBPattern,ShiftPattern,StartCoding,
          ClrCounter,IncCounter,ShipGRB,bdone,Count,reset,clk,allDone,
          player1,player2,player3,ball,p1,p2,p3,bb);
	output	[1:0]	qmode;
	output	allDone, Done, LoadGRBPattern, ShiftPattern, StartCoding, ClrCounter, IncCounter;
	input		ShipGRB, bdone;
	input   [12:0]	Count;
	input   [8:0] player1,player2,player3;									// Inputs used to track the position of the players paddle.
	input   [8:0] ball;														// Input used to track the position of the ball.
	input		reset,clk;
	input  		p1,p2,p3,bb;
  
  reg	     	S, nS;
	parameter	SSHIPRET=1'b0, SSHIPGRB=1'b1;

  reg      [12:0]   COMPAREVAL = 7199;	// Set COMPAREVAL to always output 300 LEDs worth of data.
  reg      [14:0]  rCount;  // counter for RESET time
    
  reg      b;
        
	always @(posedge clk)
	   S <= nS;

	always @(S, ShipGRB, bdone, Count)begin
		case(S)
			SSHIPRET:  nS = ShipGRB ? SSHIPGRB : SSHIPRET;
			SSHIPGRB:  nS = (bdone && (Count==COMPAREVAL)) ? SSHIPRET : SSHIPGRB;
			default:   nS = SSHIPRET;
		endcase
	end
		
		// Logic used to light up specific LEDs based on the position of the LED.
		// If the number of bits sent is equal to the 24 bit range used to address either a paddle LED or ball LED
		// send the respective output bit coming from big_reg, this will make all paddle and ball LEDs currently being equal to the color being output from big_reg. 
		// Else we want all other LEDs to be off, send a zero. 
	always @(*) begin
        if(reset) b<=0;
        else if(COMPAREVAL - Count <= (24*player1) - 1 && COMPAREVAL - Count >= (24*(player1 - 1)))b<=p1;
        else if(COMPAREVAL - Count <= (24*player2) - 1 && COMPAREVAL - Count >= (24*(player2 - 1)))b<=p2;
        else if(COMPAREVAL - Count <= (24*player3) - 1 && COMPAREVAL - Count >= (24*(player3 - 1)))b<=p3;
        else if(COMPAREVAL - Count <= (24*ball) - 1 && COMPAREVAL - Count >= (24*(ball - 1)))b<=bb;
        else b <= 0;
    end

	assign LoadGRBPattern = (S==SSHIPRET)&&ShipGRB;
	assign ClrCounter     = (S==SSHIPRET)&&ShipGRB;
	assign StartCoding    = (S==SSHIPRET)&&ShipGRB;
	assign ShiftPattern   = (S==SSHIPGRB)&&bdone;
	assign IncCounter     = (S==SSHIPGRB)&&bdone;
	assign qmode          = (S==SSHIPRET) ? 2'b10 : {1'b0,b};
	assign Done           = (S==SSHIPGRB)&&bdone&&(Count==COMPAREVAL);
	assign allDone        = (S==SSHIPRET)&&(rCount==15'd28100); // 281 us

//	assign allDone  = (S==SSHIPRET)&&(rCount==15'd3000); // for testing only  

  always @(posedge clk)
  // counts time for RESET, 10 ns per tick
  begin
    if(Done)begin  // Done sending bits, start RESET
      rCount <= 0;
      end
    else if (S==SSHIPRET)rCount <= rCount+1;
    else rCount <= rCount;
  end
 
endmodule
