// Lab 10 Level 4
// Fall 2018
// set PATH=%PATH%;C:\iverilog\bin

module stopWatch(seg,anode,dp,start,stop,countDown,lap,timeSet,reset,clk);
	output [0:6] seg;
	output [3:0] anode;
	output		 dp;
	
	input		start, stop, countDown, lap, timeSet, reset, clk;
	
	wire [0:6]  tseg;
	wire [3:0]	tmux,tanode,min,sec_10,sec_1,sec_01,fmin,fsec_10,fsec_1,fsec_01;
	wire        tdp, en, up, flash;
	wire [1:0]  stopflash;
	reg  [0:6]  seg;
	reg  [3:0]  anode,mux,rmin,rsec_10,rsec_1,rsec_01;		
    reg         ten, dp, clr, tflash;

	Enable              enabler(en,up,set,stopflash,countDown,start,stop,timeSet);
    clockDivider        clkdivider(clock,clk,set);
	count0000to9599    	counter(flash,min,sec_10,sec_1,sec_01,clock,clr,ten,up,lap);
	mux                 shootme(tmux,tanode,tdp,rmin,rsec_10,rsec_1,rsec_01,clk);
	sevenseghexdecoder 	decoder(tseg,tmux);
	flash               flasher(fmin,fsec_10,fsec_1,fsec_01,clock,clr,up,timeSet);
	
	
	always @ (posedge clk) begin
	if(reset == 1)begin clr = 1; ten = 0; end
	else begin
	if(stopflash) begin
	   tflash = 0;
	   rmin = min;
       rsec_10 = sec_10;
       rsec_1 = sec_1;
       rsec_01 = sec_01;
       clr = 0; ten = en;  
       end  
	else if(flash && ~timeSet)begin
	   rmin = fmin;
	   rsec_10 = fsec_10;
	   rsec_1 = fsec_1;
	   rsec_01 = fsec_01;
	   clr = 1; ten = 0;
	end
	else begin
	   rmin = min;
       rsec_10 = sec_10;
       rsec_1 = sec_1;
       rsec_01 = sec_01;
       ten = en;	
	end
	end
		dp = tdp;
	    anode = tanode;
	    seg = tseg;
	end

endmodule

// sevenseghexdecoder.v from Lab 4 and Lab 5
`timescale 1ns / 1ps
module sevenseghexdecoder(Seg,HexVal);
    output [0:6] Seg;
    input  [3:0] HexVal;
    reg    [0:6] Seg;
    // Signal correspondence is as follows:
    // Display Segment:  a b c d e f g (all active low: 0--on, 1--off)
    // Seg output bit:   0 1 2 3 4 5 6
    // HexVal[3:0] has MSb at bit 3, LSb at bit 0
    always @(HexVal) // Do this whenever HexVal changes
    begin
    case(HexVal)
            4'h0:  Seg = 7'b000_0001;  // forms the character for 0
            4'h1:  Seg = 7'b100_1111;  // forms the character for 1
            4'h2:  Seg = 7'b001_0010;  // forms the character for 2
            4'h3:  Seg = 7'b000_0110;  // forms the character for 3
            4'h4:  Seg = 7'b100_1100;  // forms the character for 4
            4'h5:  Seg = 7'b010_0100;  // forms the character for 5
            4'h6:  Seg = 7'b010_0000;  // forms the character for 6
            4'h7:  Seg = 7'b000_1111;  // forms the character for 7
            4'h8:  Seg = 7'b000_0000;  // forms the character for 8
            4'h9:  Seg = 7'b000_0100;  // forms the character for 9
            4'hF:  Seg = 7'b111_1111;  // turns all LED's off
            default:  Seg = 7'b000_0001; //  specify a default (Zero)
     endcase
    end
endmodule

// Counting Module from homework 7 problem 2 modified to accomodate two extra digits
// min = minutes 
// sec_10 = 10's place for seconds
// sec_1 = 1's place for seconds
// sec_01 = 10'ths place for seconds
module count0000to9599(flash,min,sec_10,sec_1,sec_01,clk,clr,en,up,lap);
	output reg  [3:0]min, sec_10, sec_1, sec_01;
	output reg       flash;
	input            clk,clr,en,up,lap;
	
	reg 	[3:0]state_min,state_sec_10,state_sec_1,state_sec_01;
	
	always @ (posedge clk) begin
		if(clr) begin
			state_min 		= 4'b0000;
			state_sec_10 	= state_min;
			state_sec_1 	= state_min;
			state_sec_01 	= state_min;
		end
		else if(en && up) begin
			if(state_sec_01 < 4'b1001) begin state_sec_01 = state_sec_01 + 1; flash = 0; end
			else if(state_sec_1 < 4'b1001) begin
			state_sec_01 	= 4'b0000;
			state_sec_1 	= state_sec_1 + 1;
			flash = 0;
			end
			else if(state_sec_10 < 4'b0101) begin
			state_sec_01 	= 4'b0000;
			state_sec_1 	= 4'b0000;
			state_sec_10 	= state_sec_10 + 1;
			flash = 0;
			end
			else if(state_min < 4'b1001) begin
			state_sec_01 	= 4'b0000;
			state_sec_1 	= 4'b0000;
			state_sec_10 	= 4'b0000;
			state_min 		= state_min + 1;
			flash = 0;
			end
			else begin
			if(state_min == 4'b1001) flash = 1;
			else flash = 0;
			state_sec_01 	= 4'b0000;
			state_sec_1 	= 4'b0000;
			state_sec_10 	= 4'b0000;
			state_min 		= 4'b0000;
			end
		end
		else if(en == 1) begin
			if(state_sec_01 > 4'b0000) begin state_sec_01 = state_sec_01 - 1; flash = 0; end
			else if(state_sec_1 > 4'b0000) begin
			state_sec_01 	= 4'b1001;
			state_sec_1 	= state_sec_1 - 1;
			flash = 0;
			end
			else if(state_sec_10 > 4'b0000) begin
			state_sec_01 	= 4'b1001;
			state_sec_1 	= 4'b1001;
			state_sec_10 	= state_sec_10 - 1;
			flash = 0;
			end
			else if(state_min > 4'b0000) begin
			state_sec_01 	= 4'b1001;
			state_sec_1 	= 4'b1001;
			state_sec_10 	= 4'b0101;
			state_min 		= state_min - 1;
            flash = 0;
			end
			else begin
			if(state_min == 4'b0000) flash = 1;
            else flash = 0;
			state_sec_01 	= 4'b1001;
			state_sec_1 	= 4'b1001;
			state_sec_10 	= 4'b0101;
			state_min 		= 4'b1001;
			end
		end else state_min = state_min;	
			
		if(~lap)begin
		  min 			= state_min;
		  sec_10 		= state_sec_10;
		  sec_1 		= state_sec_1;
		  sec_01 		= state_sec_01;
		 end
	end
	
endmodule

module clockDivider(clock,clk,set);
    output clock;
    input clk,set;
    
    reg [25:0] count;
    reg clock;
    
    initial begin
        count = 1'b0;
        clock <= 1'b1;
    end
	
    always @ (posedge clk) begin
		if(~set)begin
			if(count==26'h989680)begin
				count = 1'b0;
				clock =1'b1;
			end
			else begin
			count = count + 1;
			clock = 1'b0;
			end
		end
		else begin
			if(count==26'h090000)begin
					count = 1'b0;
					clock =1'b1;
			end
			else begin
				count = count + 1;
				clock = 1'b0;
			end
		end
    end
endmodule

`timescale 1ns/1ps
module mux(dmux,anode,dp,min,sec_10,sec_1,sec_01,clk);
    output reg [3:0]dmux, anode;
    output reg      dp;
    input [3:0] min,sec_10,sec_1,sec_01;
    input       clk;
    
    parameter   ref = 19;
    reg [ref:0] s,ns;
    
    always @ (posedge clk) begin
        s<=ns;
    end
    
    always @ (s) begin
        ns = s+1;
     end
    
    always @ (s,min,sec_10,sec_1,sec_01)
    begin
        case(s[ref:ref-1])
        2'b11:  begin dmux = min; anode = 4'b0111; dp = 0; end
        2'b10:  begin dmux = sec_10; anode = 4'b1011; dp = 1; end
        2'b01:  begin dmux = sec_1; anode = 4'b1101; dp = 0; end
        2'b00:  begin dmux = sec_01; anode = 4'b1110; dp = 1; end
        default: begin dmux = sec_01; anode = 4'b1111; dp = 0; end
        endcase
    end
   
endmodule

`timescale 1ns/1ps
module Enable(en,up,set,stopflash,countDown,start,stop,timeSet);
    output reg en, up, set, stopflash;
    input countDown,start,stop,timeSet;
    
    always @(*)begin
    if(start) begin en = 1; stopflash = 1; end
    else if(stop) begin en = 0; up = ~countDown; stopflash = 1;
        if(timeSet)set = 1;
    end
    else if(en) begin en = en; stopflash = 0; end
    else begin en = 0; up = ~countDown; stopflash = 0;end
    end
    
endmodule

module flash(min,sec_10,sec_1,sec_01,clk,clr,up,timeSet,);
	output reg  [3:0]min, sec_10, sec_1, sec_01;
    input            clk,clr,up,timeSet;
    
    reg count = 0;
    
    always @(posedge clk) begin
        if(~timeSet)begin
            if(count) begin
                min = 4'b0000;
                sec_10 = min;
                sec_1 = min;
                sec_01 = min;
                count = ~count;
            end
            else begin
                min = 4'b1111;
                sec_10 = min;
                sec_1 = min;
                sec_01 = min;
                count = ~count;
            end
        end
    end    

endmodule