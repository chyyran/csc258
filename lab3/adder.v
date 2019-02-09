
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


module adder(SW, LEDR);
    input [9:0] SW;
    output [9:0] LEDR;

    four_bit_adder fa(
        .Cout(LEDR[8]),
        .S(LEDR[3:0]),
        .A(SW[3:0]),
        .B(SW[7:4]),
        .Cin(SW[8])
    );
endmodule