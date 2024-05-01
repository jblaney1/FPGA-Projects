// A 4 to 1 mux used in a stopwatch and modified for Pong.

module mux(dmux,anode,min,sec_10,sec_1,sec_01,clk);
    output reg [3:0]dmux, anode;
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
        2'b11:  begin dmux = min; anode = 4'b0111;end
        2'b10:  begin dmux = sec_10; anode = 4'b1011;end
        2'b01:  begin dmux = sec_1; anode = 4'b1101;end
        2'b00:  begin dmux = sec_01; anode = 4'b1110;end
        default: begin dmux = sec_01; anode = 4'b1111;end
        endcase
    end
   
endmodule