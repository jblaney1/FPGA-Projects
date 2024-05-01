// SimpleSend.v
// top-level module for WS2812B LED strip
// Updated to support new WS2812B reset code of > 280 us

module SimpleSend(adrive,Leds,dataOut,Go,clk,reset,up,down,Ready2Go);
	output	dataOut, Ready2Go;
	output [3:0]  adrive;				// An output used to select the anode to write the LED output to.
	output [0:6]  Leds;					// An output used to select the LEDs to write in order to show the players score.
	input	Go, up, down, clk, reset;	// Added up and down inputs to allow the control of the paddle.

	wire [15:4] sw1,sw2,sw3,swb,rand_color;
	wire		shipGRB, Done, allDone;
	wire [1:0]	qmode;
	wire		LoadGRBPattern, ShiftPattern, StartCoding, ClrCounter, IncCounter, theBit, bdone;
	
	//Wires used to tie our added modules together.
	wire [8:0]  ball;								// An 9bit register used to hold the position of the ball.
	wire        touch,score,lose,aGo, aclk, bclk,minus;   // Wires used to pass the game states and clock values between game modules.
	wire		CurrentBit_1,CurrentBit_2,CurrentBit_3,CurrentBit_b;//Wire that transfers big_reg output bits to GRBStateMachine
	wire [3:0]  thousands,hundreds,tens,ones,muxd;  // 5 4bit registers used to pass the scoring from the counter to the mux.
	wire [12:0]	Count;								// Changed Count to 13 bits to accomodate writing to the extra 295 leds.
	wire [8:0]  lutout1,lutout2,lutout3;
	wire [3:0]  lutin;

    
	SSStateMachine		sssm(shipGRB,Done,aGo,clk,reset,allDone,Ready2Go);
	GRBStateMachine		grbsm(qmode,Done,LoadGRBPattern,ShiftPattern,StartCoding,
							ClrCounter,IncCounter,shipGRB,bdone,Count,reset,clk,allDone,
							lutout1,lutout2,lutout3,ball,CurrentBit_1,CurrentBit_2,CurrentBit_3,CurrentBit_b);			   		    	// Added LED selection logic for Player and Ball.
	BitCounter			btcnt(Count,ClrCounter,IncCounter,clk,reset);
	NZRbitGEN			nzrgn(dataOut,bdone,qmode,StartCoding,clk,reset);
	
	// Below are our added modules used to create our version of pong.
	Automate    		auto(aGo, aclk, bclk, Go, clk, reset);							   // A module that synchronizes everything to clocks.
	Player       		player(lutin,up,down,aclk,reset);	                               // A module that controls the logic for moving the players paddle.
	Ball				pball(minus,score,lose,ball,lutout1,lutout2,lutout3,bclk,reset);   // A module that controls the logic for moving the ball.
	LUT                 plut(lutout1,lutout2,lutout3,lutin,clk);						   // A lookup table module to give the values to Player for the paddle position.
	
	// Below are modules modified from Joshua Blaneys Digital Design final StopWatch project.
	Counter             pcounter(thousands,hundreds,tens,ones,clk,reset,score,lose);		// A module that keeps track of the players score.
	mux                 Mux(muxd,adrive,thousands,hundreds,tens,ones,clk);					// A module that outputs the players score one digit at a time.
	Hex27Seg            seg(Leds,muxd);														// A module that selects the correct LED to light up to show the users score.
	
	
	//Below are the modules that change the color of the ball and paddles
	RandomColor         rando(sw1,sw2,sw3,swb,ball,lutout1,lutout2,lutout3,minus,bclk,reset);       //A module that assigns the ball and player sprites to specific color values
	big_reg				shftr(CurrentBit_1,CurrentBit_2,CurrentBit_3,CurrentBit_b,sw1,sw2,sw3,swb,LoadGRBPattern,ShiftPattern,clk,reset);   //adjusted to output multiple registers 
endmodule
