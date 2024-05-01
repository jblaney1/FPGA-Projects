// The module used to control the users paddle LEDs.
module Player(lutin,up,down,clk,reset);
  output [3:0] lutin;							// The input sent to the LUT that tells it which location the paddle needs to be in.
  input        up, down;						// Logical inputs used to shift the paddle LEDs.
  input        clk, reset;						
	
	reg [3:0] low = 4'b0100;					// A 4 bit register used to keep track to the position of the paddle.
        
  always @(posedge clk)begin
    if(reset) low <= 4'b0100;		            // If reset is high, set the postions of the paddle LEDs back to their inital positions
    else if(up && low < 4'b1001)begin           // Else if up is high and we are within our paddle bounds, increment low and move the paddle LEDs up by 1 position in bound.
        if(low == 4'b1000)low = low;			//If low is already at the boundary don't change it.
        else low = low + 1;						// Otherwise incriment low.
        end
    else if(down && low > 4'b0000)begin         // Else if down is high and we are within our paddle bounds, decriment low and move the paddle LEDs down by 1 position in bound.  
        if(low == 4'b0001)low = low;			// If low is already at the boundary don't change it.
        else low = low - 1;						// Otherwise decriment low.
        end
    end

  assign  lutin = low;
endmodule