// ShiftRegister.v
// determines the 24-bit control word for an LED module
// shifts it out one bit at a time
// keeps sending the same 24 bits, so same color to all modules

module big_reg(CurrentBit_1,CurrentBit_2,CurrentBit_3,CurrentBit_b,sw1,sw2,sw3,swb,LoadRegister,RotateRegisterLeft,clk,reset);
  output CurrentBit_1,CurrentBit_2,CurrentBit_3,CurrentBit_b;
  input  [11:0] sw1,sw2,sw3,swb; //12 bit registers that hold the values determined in RandomColor
  input  LoadRegister, RotateRegisterLeft;
  input  clk, reset;

  parameter DEFAULTREG=24'h0F0F0F;  // white, half brightness

  // 24 bits for GRB control
  reg [23:0]  TheReg_1, nTheReg_1;  
  reg [23:0]  TheReg_2, nTheReg_2;
  reg [23:0]  TheReg_3, nTheReg_3;
  reg [23:0]  TheReg_b, nTheReg_b;
  
//Player 1: Color Value
  always @(posedge clk)
    if(reset) TheReg_1 <= DEFAULTREG;
    else  TheReg_1 <= nTheReg_1;
      
    // switches set the upper 4 bits of the GRB control bytes
  always @(TheReg_1, LoadRegister, RotateRegisterLeft, sw1)
    if(LoadRegister)
      nTheReg_1 = {sw1[11:8],4'b0000,sw1[7:4],4'b0000,sw1[3:0],4'b0000};
    else if(RotateRegisterLeft)
      nTheReg_1 = {TheReg_1[22:0],TheReg_1[23]};
    else
      nTheReg_1 = TheReg_1;

  assign  CurrentBit_1 = TheReg_1[23];

//Player 2: Color Value
  always @(posedge clk)
    if(reset) TheReg_2 <= DEFAULTREG;
    else  TheReg_2 <= nTheReg_2;

    // switches set the upper 4 bits of the GRB control bytes
  always @(TheReg_2, LoadRegister, RotateRegisterLeft, sw2)
    if(LoadRegister)
      nTheReg_2 = {sw2[11:8],4'b0000,sw2[7:4],4'b0000,sw2[3:0],4'b0000};
    else if(RotateRegisterLeft)
      nTheReg_2= {TheReg_2[22:0],TheReg_2[23]};
    else
      nTheReg_2 = TheReg_2;

  assign  CurrentBit_2 = TheReg_2[23];
  
//Player 3: Color Value 
  always @(posedge clk)
    if(reset) TheReg_3 <= DEFAULTREG;
    else  TheReg_3 <= nTheReg_3;
   
    // switches set the upper 4 bits of the GRB control bytes
  always @(TheReg_3, LoadRegister, RotateRegisterLeft, sw3)
    if(LoadRegister)
      nTheReg_3= {sw3[11:8],4'b0000,sw3[7:4],4'b0000,sw3[3:0],4'b0000};
    else if(RotateRegisterLeft)
      nTheReg_3 = {TheReg_3[22:0],TheReg_3[23]};
    else
      nTheReg_3 = TheReg_3;

  assign  CurrentBit_3 = TheReg_3[23];

//Ball: Color Value
    always @(posedge clk)
    if(reset) TheReg_b <= DEFAULTREG;
    else  TheReg_b <= nTheReg_b;
 
    // switches set the upper 4 bits of the GRB control bytes
  always @(TheReg_b, LoadRegister, RotateRegisterLeft, swb)
    if(LoadRegister)
      nTheReg_b = {swb[11:8],4'b0000,swb[7:4],4'b0000,swb[3:0],4'b0000};
    else if(RotateRegisterLeft)
      nTheReg_b = {TheReg_b[22:0],TheReg_b[23]};
    else
      nTheReg_b = TheReg_b;

  assign  CurrentBit_b = TheReg_b[23];
endmodule

