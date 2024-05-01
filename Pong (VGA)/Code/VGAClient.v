// VGAClient.v - Example VGA color computation client
// UW EE 4490 
// Adapted from original code by Jerry C. Hamann
// Computes the desired color at pix (X,Y), must do this fast!

module VGAClient(RED,GREEN,BLUE,CurrentX,CurrentY,VBlank,HBlank,PPosition,CPosition,BPosition,border,CLK_100MHz);
    output  [3:0]   RED, GREEN, BLUE;
    input   [10:0]  CurrentX, CurrentY;
    input           VBlank, HBlank;
    input           CLK_100MHz;
	input   [11:0]  border;
	input	[23:0]	PPosition,CPosition,BPosition;
	
    reg     [3:0]   RED, GREEN, BLUE;
 
	
	always @(posedge CLK_100MHz) begin
		if(VBlank || HBlank)
            {RED,GREEN,BLUE}=0; // Must drive colors only during non-blanking times.
        else if ((CurrentX < PPosition[11:0]  + 4'h1) && (CurrentX >= PPosition[11:0]) && 												// Rx			Create the player paddle based on the figure to the left. 
				(CurrentY < PPosition[23:12] + 5'd28) && (CurrentY >= PPosition[23:12]))												// xx			The R is the reference point. The paddle is 28 pixels tall
				{RED,GREEN,BLUE} = 12'hfff;																								// xx			Set the paddles color to white.
				
		else if ((CurrentX < CPosition[11:0]  + 4'h1) && (CurrentX >= CPosition[11:0]) && 												// Rx			Create the computers paddle based on the same constraints 
				(CurrentY < CPosition[23:12] + 5'd28) && (CurrentY >= CPosition[23:12]))												// xx			as the players paddle. Also make it white.
				{RED,GREEN,BLUE} = 12'hfff;																								// xx
				
		else if ((CurrentX <= BPosition[11:0] + 4'h3 && CurrentX >  BPosition[11:0] + 4'h1 && CurrentY == BPosition[23:12] - 2)||		//   xx			Create the ball based on the 
				(CurrentX <= BPosition[11:0] + 4'h4 && CurrentX >  BPosition[11:0]     && CurrentY == BPosition[23:12] - 1)||		    //  xxxx		figure to the left. The R is
				(CurrentX <= BPosition[11:0] + 4'h5 && CurrentX >= BPosition[11:0]     && CurrentY == BPosition[23:12])||			    // Rxxxxx		the reference point provided by
				(CurrentX <= BPosition[11:0] + 4'h4 && CurrentX >  BPosition[11:0]     && CurrentY == BPosition[23:12] + 1)||		    //  xxxx		BPosition and the x's are pixels
				(CurrentX <= BPosition[11:0] + 4'h3 && CurrentX >  BPosition[11:0] + 4'h1 && CurrentY == BPosition[23:12] + 2))		    //   xx			that form the ball.
				{RED,GREEN,BLUE} = 12'hfff;
				
		else if (CurrentX > 12'd144 && CurrentX < 12'd655 && CurrentY < 12'd427 && CurrentY > 12'd172)									// Create the play area 512 by 256 pixels
				{RED,GREEN,BLUE} = 12'h000;																								// Make the play area black.
				
		else
				{RED,GREEN,BLUE} = border;																								// Make all other pixels the random color input.
	end	
 endmodule
