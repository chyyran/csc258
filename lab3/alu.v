
//Hex
module sevenseg(HEX, IN);
    input [0:3] IN;
    output [6:0] HEX;

    hex0 a0(.c0(IN[0]), .c1(IN[1]), .c2(IN[2]), .c3(IN[3]), .m(HEX[0]));
    hex1 b0(.c0(IN[0]), .c1(IN[1]), .c2(IN[2]), .c3(IN[3]), .m(HEX[1]));
    hex2 c0(.c0(IN[0]), .c1(IN[1]), .c2(IN[2]), .c3(IN[3]), .m(HEX[2]));
    hex3 d0(.c0(IN[0]), .c1(IN[1]), .c2(IN[2]), .c3(IN[3]), .m(HEX[3]));
    hex4 e0(.c0(IN[0]), .c1(IN[1]), .c2(IN[2]), .c3(IN[3]), .m(HEX[4]));
    hex5 f0(.c0(IN[0]), .c1(IN[1]), .c2(IN[2]), .c3(IN[3]), .m(HEX[5]));
    hex6 g0(.c0(IN[0]), .c1(IN[1]), .c2(IN[2]), .c3(IN[3]), .m(HEX[6]));

endmodule

module hex0(c0, c1, c2, c3, m);
    input c0; 
    input c1; 
    input c2;
	 input c3;
    output m;
  
    assign m = ~c3 & c2 & ~c1 & ~c0 | ~c3 & ~c2 & ~c1 & c0 | c3 & c2 & ~c1 & c0 | c3 & ~c2 & c1 & c0;
   
		 
endmodule

module hex1(c0, c1, c2, c3, m);
    input c0; 
    input c1; 
    input c2;
	 input c3;
    output m;
  
    assign m = c3 & c2 & ~c0 | ~c3 & c2 & ~c1 & c0 | c3 & c1 & c0 | c2 & c1 & ~c0;

	 
endmodule

module hex2(c0, c1, c2, c3, m);
    input c0; 
    input c1; 
    input c2;
	 input c3;
    output m;
  
    assign m = c3 & c2 & ~c1 & ~c0 | c3 & c2 & c1 | ~c3 & ~c2 & c1 & ~c0;

	 
endmodule

module hex3(c0, c1, c2, c3, m);
    input c0; 
    input c1; 
    input c2;
	 input c3;
    output m;
  
    assign m = ~c3 & c2 & ~c1 & ~c0 | ~c2 & ~c1 & c0 | c2 & c1 & c0 | c3 & ~c2 & c1 & ~c0;

	 
endmodule

module hex4(c0, c1, c2, c3, m);
    input c0; 
    input c1; 
    input c2;
	 input c3;
    output m;
  
    assign m = ~c3 & c2 & ~c1 | ~c3 & c0 | ~c2 & ~c1 & c0;

	 
endmodule

module hex5(c0, c1, c2, c3, m);
    input c0; 
    input c1; 
    input c2;
	 input c3;
    output m;
  
    assign m = ~c3 & ~c2 & c0 | ~c3 & c1 & c0 | ~c3 & ~c2 & c1 | c3 & c2 & ~c1 & c0;

	 
endmodule

module hex6(c0, c1, c2, c3, m);
    input c0; 
    input c1; 
    input c2;
	 input c3;
    output m;
  
    assign m = ~c3 & ~c2 & ~c1 | c3 & c2 & ~c1 & ~c0 | ~c3 & c2 & c1 & c0;

	 
endmodule

module full_adder(Cout, Sout, A, B, Cin);
    input A, B, Cin;
    output Cout, Sout;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
    assign Sout = A ^ B ^ Cin;
endmodule

module four_bit_adder(Cout, S, A, B, Cin);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    
    output [3:0] S;
    output Cout;

    wire [3:0] Ci;

    full_adder fa1(
        .Cout(Ci[0]),
        .Sout(S[0]),
        .A(A[0]), 
        .B(B[0]),
        .Cin(Cin)
    );
    
    full_adder fa2(
        .Cout(Ci[1]),
        .Sout(S[1]),
        .A(A[1]), 
        .B(B[1]),
        .Cin(Ci[0])
    );
    
    full_adder fa3(
        .Cout(Ci[2]),
        .Sout(S[2]),
        .A(A[2]), 
        .B(B[2]),
        .Cin(Ci[1])
    );
    
    full_adder fa4(
        .Cout(Cout),
        .Sout(S[3]),
        .A(A[3]), 
        .B(B[3]),
        .Cin(Ci[2])
    );
endmodule

module alublock(ALUout, A, B, f);
    output reg [7:0] ALUout;
    input [3:0] A, B;
    input [2:0] f;
    
    wire N;
    wire Low;

    assign Low = 0;
    wire [3:0] PlusOne, APlusB;

    wire [7:0] LowerXorUpperOr, Echo;

    four_bit_adder fa0(N, PlusOne, A, 4'b0001, Low);
    four_bit_adder fa1(N, APlusB, A, B, Low);

    assign LowerXorUpperOr[7:4] = A | B;
    assign LowerXorUpperOr[3:0] = A ^ B;

    assign Echo[7:4] = A;
    assign Echo[3:0] = B;

    always @(*)
    begin
        case (f)
            0: ALUout = PlusOne;
            1: ALUout = APlusB;
            2: ALUout = A + B;
            3: ALUout = LowerXorUpperOr;
            4: ALUout = ((|A) + (|B));
            5: ALUout = Echo;
            default: ALUout = 8'b00000000;
        endcase
    end
endmodule

module alu(IN, KEY, LEDR, HEX0, HEX1, HEX2, HEX3);
    input [9:0] IN;
    input [2:0] KEY;

    output [7:0] LEDR;

    output [0:7] HEX0, HEX1, HEX2, HEX3;

    wire [3:0] A, B;
    
    wire [7:0] out;

    assign A = IN[7:4];
    assign B = IN[3:0];

    assign LEDR = out;

    sevenseg z1(HEX1, 4'b0000);
    sevenseg z3(HEX3, 4'b0000);

    alublock alu(out, A, B, KEY);

    sevenseg h0(HEX0, B);
    sevenseg h1(HEX2, A);

endmodule