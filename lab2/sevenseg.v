module sevenseg(HEX0, A, B, C, D);
    input A, B, C, D;
    output [6:0] HEX0;

    assign HEX0[0] = (~A & ~B & ~C & D) | (~A & B & ~C & ~D) | (A & B & ~C & D) | (A & ~B & C & D);
    assign HEX0[1] = (~A & ~C & ~D) | (B & ~C & D) |  (~A & B & C & ~D) | (A & ~B & C & D);
    assign HEX0[2] = (~A & ~B & C & ~D) | (A & B & ~D) | (A & B & C);
    assign HEX0[3] = (~A & ~B & ~C & ~D) | (~A & B & ~C & D) | (B & C & D) | (A & ~B & ~C & D) | (A & ~B & C & ~D);
    assign HEX0[4] = (~A & B & ~C) | (~B & ~C & D) | (~A & D);
    assign HEX0[5] = (~A & ~B & D) | (~A & B & C) | (~A & C & D) | (A & B & ~C & D);
    assign HEX0[6] = (~A & ~B & ~C) | (~A & B & C & D) | (A & B & ~C & ~D);
endmodule

module main(HEX0, SW);
    input [4:0] SW;
    output [6:0] HEX0;
    sevenseg h0(
        .HEX0(HEX0),
        .A(SW[0]),
        .B(SW[1]),
        .C(SW[2]),
        .D(SW[3])
    );
endmodule