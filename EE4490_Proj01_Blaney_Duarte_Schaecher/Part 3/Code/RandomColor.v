module RandomColor(sw1,sw2,sw3,swb,ball,player1,player2,player3,minus,clk,reset);
	output 	[11:0] 	sw1,sw2,sw3,swb;   //4 12 bit registers that hold the color for each sprite
	input 			clk, reset,minus;  //minus is the sprite direction
    input   [8:0] 	ball,player1, player2, player3; //Position values for the respective sprites
	
	reg 	[11:0]	s1,sw1_r = 12'hFFF, sw2_r = 12'hFFF, sw3_r = 12'hFFF, swb_r = 12'hFFF; //initializes 12 bit registers so that on startup the sprites are given a value
	reg		[4:1]   count = 4'b0; //4 bit value that represents the case
	
	//transfers color from ball to paddle
	always @(posedge clk) begin
	    if(reset)begin count = 4'd0; end //active high reset,sets count to 0
        else if ((ball + 1) == player1) begin //looks for a ball-sprite adjacent to player1-sprite
            sw1_r = swb_r;                    //sets player1-sprite color to the ball-sprite color
            count = count + 1;				  //increases the counter that decides the ball color
            end     
        else if ((ball + 1) == player2) begin //looks for a ball-sprite adjacent to player2-sprite
            sw2_r = swb_r;					  //sets player2-sprite color to the ball-sprite color
            count = count + 1; 				  //increases the counter that decides the ball color
            end
        else if ((ball + 1) == player3) begin //looks for a ball-sprite adjacent to player3-sprite
            sw3_r = swb_r;				      //sets player3-sprite color to the ball-sprite color
            count = count + 1; 				  //increases the counter that decides the ball color
            end
         else begin							  //If above conditions are not met, keep all sprite values the same
                sw1_r = sw1_r;
                sw2_r = sw2_r;
                sw3_r = sw3_r;
                swb_r = swb_r;
            end
     end
	//This case statement changes the color value of s1. this will determine ball color
	always @(count,reset)begin
	   if(reset)begin s1 = 12'hFFF; end //active high reset, sets the value of s1 to white
	   else begin
		case(count)
			4'd0:		begin s1 = 12'h083; end
			4'd1:		begin s1 = 12'hF00; end
			4'd2:		begin s1 = 12'h0F0; end
			4'd3:		begin s1 = 12'hB29; end
			4'd4:		begin s1 = 12'hF0F; end
			4'd5:    	begin s1 = 12'h0FF; end
			4'd6:    	begin s1 = 12'h3A7; end
            4'd7:       begin s1 = 12'h72F; end
            4'd8:       begin s1 = 12'hFF0; end
            4'd9:       begin s1 = 12'hF00; end
            4'd10:      begin s1 = 12'h8C2; end
            4'd11:      begin s1 = 12'h00F; end
            4'd12:      begin s1 = 12'hE93; end
            4'd13:      begin s1 = 12'hF0F; end
            4'd14:      begin s1 = 12'hAA9; end
            4'd15:      begin s1 = 12'hF00; end
            default:    begin s1 = 12'hFFF; end
        endcase
        end
	end
	
	//This looks for if the ball position value is equal to the column of leds one of the paddles.
	//It then sets the ball color value to the s1 register value 
	always @(posedge clk)begin
                if ((ball == 9'd29)  || (ball == 9'd59) ||
                    (ball == 9'd89)  || (ball == 9'd119)||
                    (ball == 9'd149) || (ball == 9'd179)||
                    (ball == 9'd209) || (ball == 9'd239)||
                    (ball == 9'd269) || (ball == 9'd299))begin
						//this allows for the ball color value to be assigned by the s1 register
						//when the ball is moving away from the paddles
                         if(!minus)begin swb_r <= s1; end       
                         else if(minus)begin swb_r <= s1; end
                         else begin swb_r <= swb_r;end  //keeps the ball register values constant
                end
                else begin swb_r <= swb_r; end //keeps the ball register values constant
        end

	//This assigns color values to the output element
	//using the modules internal registers
	 assign sw1 = sw1_r; 
     assign sw2 = sw2_r;
     assign sw3 = sw3_r;
     assign swb = swb_r;
	
endmodule