module LUT(lutout1,lutout2,lutout3,lutin,clk);
	output [8:0] lutout1,lutout2,lutout3;	// Three outputs, one for each light in the players paddle.
	input  [3:0] lutin;						// The input from Player that tells us which position the lights need to be in.
	input        clk;
	
	reg [8:0]    S1, S2, S3;
	
	// Below is the lookup table that holds all of the possible values fo rthe players paddle.
	// lutin keeps track of the middle paddle position, so we only need cases from 1 to 8.
	// If you would like to see why we chose these values for our LUT, please refer to the 
	// wiring diagram.
	
	always @(posedge clk)begin
		case(lutin)
		4'b0001:		begin S1 <= 9'd30;  S2 <= 9'd60;  S3 <= 9'd90;  end
		4'b0010:		begin S1 <= 9'd60;  S2 <= 9'd90;  S3 <= 9'd120;	end
		4'b0011:		begin S1 <= 9'd90;  S2 <= 9'd120; S3 <= 9'd150; end
		4'b0100:		begin S1 <= 9'd120; S2 <= 9'd150; S3 <= 9'd180; end
		4'b0101:		begin S1 <= 9'd150; S2 <= 9'd180; S3 <= 9'd210; end
		4'b0110:        begin S1 <= 9'd180; S2 <= 9'd210; S3 <= 9'd240; end
		4'b0111:		begin S1 <= 9'd210; S2 <= 9'd240; S3 <= 9'd270; end
		4'b1000:		begin S1 <= 9'd240; S2 <= 9'd270; S3 <= 9'd300; end
		default:		begin S1 <= 9'd120; S2 <= 9'd150; S3 <= 9'd180; end
		endcase
	end
	
	assign lutout1 = S1;
	assign lutout2 = S2;
	assign lutout3 = S3;
	
endmodule