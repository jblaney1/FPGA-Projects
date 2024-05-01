// controlunit.v
// Simple control unit for single-cycle processor.  All Figure and Table references are due to
// "Digital Design and Computer Architecture ARM EDITION," S.L. Harris and D.M. Harris.
// EE 4490 adapted from code by Jerry C. Hamann

module controlunit(PCSrc,MemtoReg,MemWrite,ALUControl,ALUSrc,ImmSrc,RegWrite,RegSrc,
                   Instr,Flags,clk);
  output          PCSrc, MemtoReg, MemWrite,ALUSrc,RegWrite;
  output [1:0]    ALUControl, ImmSrc, RegSrc;
  input  [31:0]   Instr;
  input  [3:0]    Flags;
  input           clk;

  reg             N,Z,C,V;    // For processor storage of status flags
  reg             CondEx;     // Is the condition satisfied for storage
  reg    [1:0]    ALUControl, FlagW;

  // Parsing of Instr into identifiable segments.
  wire   [3:0]    Cond, Rd;
  wire   [1:0]    Op;
  wire   [5:0]    Funct;
  wire            S;

  // Main decoder signals from Table 7.2
  wire            Branch, MemW, RegW, ALUOp;
  // Output of the PC Logic Block (Figure 7.14)
  wire            PCS;

  // Provide the internal decoding names of the instruction field bits.
  assign  Cond  = Instr[31:28];
  assign  Op    = Instr[27:26];
  assign  Funct = Instr[25:20];
  assign  Rd    = Instr[15:12];
  assign  S     = Instr[20];

  // Build the logic of Table 7.2, the Main Decoder
  assign  Branch   = (Op==2'b10);
  assign  MemtoReg = (Op==2'b01)&&(Funct[0]);
  assign  MemW     = (Op==2'b01)&&(!Funct[0]);
  assign  ALUSrc   = !((Op==2'b00)&&(!Funct[5]));
  assign  ImmSrc   = Op;
  assign  RegW     = (Op==2'b00) || ((Op==2'b01)&&Funct[0]);
  assign  RegSrc[1]= (Op==2'b01)&&(!Funct[0]);
  assign  RegSrc[0]= (Op==2'b10);
  assign  ALUOp    = (Op==2'b00);

  // The PC Logic block
  assign  PCS = ((Rd==4'd15) && RegW) || Branch;

  // Build the logic of Table 7.3, the ALU Decoder
  always @(ALUOp,Funct,S)
    case(ALUOp)
      1'b0:   {ALUControl,FlagW} = 4'b00_00;
      1'b1:   case({Funct[4:1],S})
                5'b0100_0:  {ALUControl,FlagW} = 4'b00_00;  // ADD
                5'b0100_1:  {ALUControl,FlagW} = 4'b00_11;  // ADDS
                5'b0010_0:  {ALUControl,FlagW} = 4'b01_00;  // SUB
                5'b0010_1:  {ALUControl,FlagW} = 4'b01_11;  // SUBS
                5'b0000_0:  {ALUControl,FlagW} = 4'b10_00;  // AND
                5'b0000_1:  {ALUControl,FlagW} = 4'b10_10;  // ANDS
                5'b1100_0:  {ALUControl,FlagW} = 4'b11_00;  // ORR
                5'b1100_1:  {ALUControl,FlagW} = 4'b11_10;  // ORRS
                default:    {ALUControl,FlagW} = 4'b00_00;  
              endcase
      default: {ALUControl,FlagW} = 4'b00_00;
    endcase

  // The processor storage of status flags
  always @(posedge clk) begin
    N <= (FlagW[1]&&CondEx) ? Flags[3] : N;
    Z <= (FlagW[1]&&CondEx) ? Flags[2] : Z;
    C <= (FlagW[0]&&CondEx) ? Flags[1] : C;
    V <= (FlagW[0]&&CondEx) ? Flags[0] : V;
  end

  // Determination of condition satisfied (full interpretation of Table 6.3)
  always @(Cond,N,Z,C,V)
    case(Cond)
      4'b0000:    CondEx = Z;                     // EQ
      4'b0001:    CondEx = !Z;                    // NE
      4'b0010:    CondEx = C;                     // CS/HS
      4'b0011:    CondEx = !C;                    // CC/LO
      4'b0100:    CondEx = N;                     // MI
      4'b0101:    CondEx = !N;                    // PL
      4'b0110:    CondEx = V;                     // VS
      4'b0111:    CondEx = !V;                    // VC
      4'b1000:    CondEx = (!Z) && C;             // HI
      4'b1001:    CondEx = Z || (!C);             // LS
      4'b1010:    CondEx = !(N ^ V);              // GE
      4'b1011:    CondEx = N ^ V;                 // LT
      4'b1100:    CondEx = (!Z) && (!(N ^ V));    // GT
      4'b1101:    CondEx = Z || (N ^ V);          // LE
      4'b1110:    CondEx = 1;                     // AL
      default:    CondEx = 1;
    endcase

  // Conditionally controlled updates to PC, Reg, Mem
  assign  PCSrc = PCS && CondEx;
  assign  RegWrite = RegW && CondEx;
  assign  MemWrite = MemW && CondEx;
endmodule
