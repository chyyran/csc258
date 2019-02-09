module sevenseg(Segments, Input, Off);
    output reg [6:0] Segments;
    input Off;
    input [3:0] Input;

    always @(*)
    begin
        if (Off == 1'b1)
            Segments = 7'b1111111;
        else
            case (Input)
                4'b0000: Segments = 7'b1000000; // 0
                4'b0001: Segments = 7'b1111001; // 1 
                4'b0010: Segments = 7'b0100100; // 2 
                4'b0011: Segments = 7'b0110000; // 3  
                4'b0100: Segments = 7'b0011001; // 4
                4'b0101: Segments = 7'b0010010; // 5 
                4'b0110: Segments = 7'b0000010; // 6
                4'b0111: Segments = 7'b1111000; // 7
                4'b1000: Segments = 7'b0000000; // 8
                4'b1001: Segments = 7'b0011000; // 9 
                4'b1010: Segments = 7'b0001000; // A 
                4'b1011: Segments = 7'b0000011; // b
                4'b1100: Segments = 7'b1000110; // c 
                4'b1101: Segments = 7'b0100001; // d 
                4'b1110: Segments = 7'b0000110; // E 
                4'b1111: Segments = 7'b0001110; // F 
                default: Segments = 7'b1111111; // default 
            endcase
    end
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

module alublock(input [3:0] A, input [3:0] B, input [2:0] f, output reg [7:0] ALUout);
    // output reg [7:0] ALUout;
    // input [3:0] A, B;
    // input [2:0] f;
    
    wire N;
    wire Low;

    assign Low = 0;
    wire [3:0] PlusOne, APlusB;

    wire [7:0] LowerXorUpperOr, Echo, LeftShift, RightShift, Multiply;

    four_bit_adder fa0(N, PlusOne, A, 4'b0001, Low);
    four_bit_adder fa1(N, APlusB, A, B, Low);

    assign LowerXorUpperOr[7:4] = A | B;
    assign LowerXorUpperOr[3:0] = A ^ B;

    assign LeftShift = B << A;
    assign RightShift = B >> A;
    assign Echo[7:4] = A;
    assign Echo[3:0] = B;

    always @(*)
    begin
        case (f)
            0: ALUout = PlusOne;
            1: ALUout = APlusB;
            2: ALUout = A + B;
            3: ALUout = LowerXorUpperOr;
            4: ALUout = ((|A) | (|B));
            5: ALUout = LeftShift;
            6: ALUout = RightShift;
            7: ALUout = A * B;
            default: ALUout = 8'b00000000;
        endcase
    end
endmodule

module seven_bit_register(input reset_n, input clock, input [7:0] d, output reg [7:0] q);
    always @(posedge clock)
    begin
        if (reset_n == 1'b0)
            q <= 0;
        else
            q <= d;
    end
endmodule

module alu(SW, KEY, LEDR, HEX0, HEX1, HEX2,  HEX3, HEX4, HEX5, HEX6, HEX7);
    input [9:0] SW;
    input [4:0] KEY;

    output [9:0] LEDR;

    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

    wire [3:0] A, B;
    wire [7:0] aluout, Register;
    wire [2:0] F;
    assign A = SW[3:0];
    assign B = Register[3:0];
    assign F = SW[7:5];
    assign LEDR[7:0] = Register;

    alublock alu(A, B, F, aluout);

    seven_bit_register r1(
        .reset_n(SW[9]),
        .clock(~KEY[0]),
        .d(aluout),
        .q(Register)
    );

    sevenseg h0(HEX0, A, 1'b0);


    sevenseg z1(HEX1, 4'b0000, 1'b1);
    sevenseg z2(HEX2, F, 1'b0);
    sevenseg z3(HEX3, 4'b0000, 1'b1);

    sevenseg r4(HEX4, Register[3:0], 1'b0);
    sevenseg r5(HEX5, Register[7:4], 1'b0);

  

endmodule