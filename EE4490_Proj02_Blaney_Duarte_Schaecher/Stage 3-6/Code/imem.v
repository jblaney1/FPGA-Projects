// imem.v
// Very simple instruction memory for ARM single-cycle model.
// "Digital Design and Computer Architecture ARM EDITION," S.L. Harris and D.M. Harris.
// EE 4490 adapted from code by Jerry C. Hamann

module imem(RD,A);
  output  [31:0]  RD;
  input   [31:0]  A;

  reg     [31:0]  RD;

  always @(A)
    case(A[5:2])
      4'b0000: RD = 32'hE202_2000;  //      AND  R2,R2,#0
      4'b0001: RD = 32'hE382_3000;  //      ORR  R3,R2,#0
      4'b0010: RD = 32'hE383_4005;  //      ORR  R4,R3,#5
      4'b0011: RD = 32'hE3A0_5062;  //      mov  R5, #0x62
      4'b0100: RD = 32'hE3A0_9065;  //      mov  R9, #0x65
      4'b0101: RD = 32'hE249_9001;  // T1:  sub  R9, R9, #1
      4'b0110: RD = 32'hE155_0009;  //      cmp  R5, R9
      4'b0111: RD = 32'h1AFF_FFFC;  //      BNE  T1
      4'b1000: RD = 32'hE583_2000;  //      STR  R2,[R3]
      4'b1001: RD = 32'hE593_5000;  //      LDR  R5,[R3]
      4'b1010: RD = 32'hE035_6003;  //      EORS R6, R5, R3
      4'b1011: RD = 32'hE354_0000;  //      CMP  R4, #0
      4'b1100: RD = 32'h0086_7005;  //      ADDEQ R7,R6,R5
      4'b1101: RD = 32'hEAFF_FFFE;  // T2:  BAL  T2
      default: RD = 32'hEAFF_FFFE;  // T3:  BAL  T3
    endcase
endmodule
