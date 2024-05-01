// VGAStart.v - Top level module for example VGA driver implementation in Verilog
// UW EE 4490 
// Adapted from original code by Jerry C. Hamann

module FirstVGA(adrive, Leds, dp, VS, HS, RED, GREEN, BLUE, Up, Down, start, CLK_100MHz, Reset);
    output          VS, HS, dp; 
    output [3:0]    RED, GREEN, BLUE;
    output [3:0]  adrive;				// An output used to select the anode to write the LED output to.
    output [0:6]  Leds;                    // An output used to select the LEDs to write in order to show the players score.
    input           Up, Down, start, CLK_100MHz, Reset;
    
    wire            HBlank, VBlank;
    wire   [10:0]   CurrentX, CurrentY;
	
	wire			PScore, CScore, win, clk;
	wire   [3:0]    muxd, PTen, POne, CTen, COne;
	wire   [23:0]	PPosition,CPosition,BPosition;
	wire   [11:0]   border;

    // Connect to driver of VGA signals
    VGALLDriver vgadll(.VS(VS),.HS(HS),.VBlank(VBlank),.HBlank(HBlank),
                       .CurrentX(CurrentX),.CurrentY(CurrentY), 
                       .CLK_100MHz(CLK_100MHz),.Reset(Reset));
   
    // Connect to "client" which produces pixel color based on (X,Y) location
    VGAClient   vgacl(.RED(RED),.GREEN(GREEN),.BLUE(BLUE),
                      .CurrentX(CurrentX),.CurrentY(CurrentY),.VBlank(VBlank),.HBlank(HBlank),
                      .PPosition(PPosition),.CPosition(CPosition),.BPosition(BPosition),
                      .border(border),.CLK_100MHz(CLK_100MHz));
					  
	// Pong
	Pong		        pong(PPosition, CPosition, BPosition, PScore, CScore, Up, Down, start, win, clk, CLK_100MHz, Reset);	
	
	// Scoring
	Counter             counter(PTen,POne,CTen,COne,PScore,CScore,win,clk,Reset);
    Mux4Machine         Mux(muxd,adrive,PTen,POne,CTen,COne,CLK_100MHz,Reset,,dp);	
    Hex27Seg            seg(Leds,muxd);  
    
    // Color Changer
    RNDCOLOR            rndclr(border,CLK_100MHz);                                                 
endmodule