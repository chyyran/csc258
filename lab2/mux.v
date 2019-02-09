//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display


module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    mux2to1 u0(
        .x(SW[0]),
        .y(SW[1]),
        .s(SW[9]),
        .m(LEDR[0])
        );
endmodule

module mux4(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    wire ConnectionUV ;
    wire ConnectionWX ;
    
    mux2to1 u0(
        .x(SW[0]), // U
        .y(SW[1]), // V
        .s(SW[9]), // S0
        .m(ConnectionUV)
    );
    
    mux2to1 u1(
        .x(SW[2]), // W
        .y(SW[3]), // X
        .s(SW[9]), //S0
        .m(ConnectionWX)
    );

    mux2to1 u_switch(
        .x(ConnectionUV), // UV
        .y(ConnectionWX), // WX
        .s(SW[8]), // S1
        .m(LEDR[0])
    );

endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;
endmodule

