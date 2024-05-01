// TopLevelSCUWARM.v
// Jerry Hamann
// EE 4490 Fall 2017

module TopLevelSCUWARM(sevenSegmentsa2g,anodeDrives,theReg,TopHalf,PushButton,clk,reset,select);
  output [0:6]    sevenSegmentsa2g;
  output [3:0]    anodeDrives;
  input  [3:0]    theReg;
  input           TopHalf, PushButton, clk, reset, select;

  wire   [31:0]   theRegVal,Instr;
  wire   [3:0]    the7SegVal;
  wire   [3:0]    setA, setB, setC, setD;
  
  reg    [3:0]    A, B, C, D;		// Added registers to allow for instruction and register switching to leds.

  SingleCycleProcessor    scpuw(.Instr(Instr),.DBtheRegVal(theRegVal),.DBtheReg(theReg),.clk(PushButton),.reset(reset));
  Mux4Machine             mux4m(.muxd(the7SegVal),.adrive(anodeDrives),.A(setA),.B(setB),
                                .C(setC),.D(setD),.clk(clk),.reset(reset),.blank(4'b0000));
  Hex27Seg                hx27s(.Leds(sevenSegmentsa2g),.HexVal(the7SegVal));

  // Added logic to allow the viewing of the entire instruction as well as the any of the register values.
  // If the select switch is high, send the instruction to the leds.
  // Otherwise send the register value to the leds.
  always @ (clk)begin
    if(select)begin
        A = TopHalf ? Instr[31:28] : Instr[15:12];
        B = TopHalf ? Instr[27:24] : Instr[11:8];
        C = TopHalf ? Instr[23:20] : Instr[7:4];
        D = TopHalf ? Instr[19:16] : Instr[3:0];
    end
    else begin
        A = TopHalf ? theRegVal[31:28] : theRegVal[15:12];
        B = TopHalf ? theRegVal[27:24] : theRegVal[11:8];
        C = TopHalf ? theRegVal[23:20] : theRegVal[7:4];
        D = TopHalf ? theRegVal[19:16] : theRegVal[3:0];
    end
  end
    
  assign  setA = A;
  assign  setB = B;
  assign  setC = C;
  assign  setD = D;
endmodule
