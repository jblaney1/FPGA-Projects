// alu.v
// ALU for simple ARM single-cycle implementation.
// "Digital Design and Computer Architecture ARM EDITION," S.L. Harris and D.M. Harris.
// EE 4490 adapted from code by Jerry C. Hamann

module alu(ALUResult,ALUFlags,ALUControl,SrcA,SrcB);
  output  [31:0]  ALUResult;
  output  [3:0]   ALUFlags;
  input   [1:0]   ALUControl;
  input   [31:0]  SrcA, SrcB;

  reg     [31:0]  ALUResult;
  reg             N,Z,C,V;

  always @(ALUControl,SrcA,SrcB)
    case(ALUControl)
      2'b00:  begin   {C,ALUResult}=SrcA+SrcB;        // ADD
                      Z=(ALUResult==32'b0);
                      N=ALUResult[31];
                      V=SrcA[31]&&SrcB[31]&&(!ALUResult[31])
                        ||(!SrcA[31])&&(!SrcB[31])&&ALUResult[31];
              end
      2'b01:  begin   {C,ALUResult}=SrcA+(-SrcB);     // SUB
                      C=!C;
                      Z=(ALUResult==32'b0);
                      N=ALUResult[31];
                      V=SrcA[31]&&(!SrcB[31])&&(!ALUResult[31])
                        ||(!SrcA[31])&&(SrcB[31])&&ALUResult[31];
              end
      2'b10:  begin   ALUResult=SrcA&SrcB;            // AND
                      Z=(ALUResult==32'b0);
                      N=ALUResult[31];
                      V=0;    // Don't care
                      C=0;    // Don't care
              end
      2'b11:  begin   ALUResult=SrcA|SrcB;            // OR (or ORR)
                      Z=(ALUResult==32'b0);
                      N=ALUResult[31];
                      V=0;    // Don't care
                      C=0;    // Don't care
              end
      default:  begin ALUResult=0; {N,Z,C,V}=4'b0100; end
    endcase

  assign ALUFlags = {N,Z,C,V};  // BEWARE:  Whether these are saved in controller depends on instruction.
endmodule
