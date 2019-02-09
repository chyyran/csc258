module t_ff(input clk, input clr, input t, output reg q);
    always @(posedge clk, negedge clr) begin
        if (~clr)
            q <= 0;
        else    
            q <= q ^ t;
    end
endmodule


module eight_bit_counter(input clk, input enable, input reset, output [7:0] q);
    
    t_tff t0(
        .t(enable), 
        .clk(clk), 
        .clr(reset), 
        .q(q[7])
    );

    t_tff t1(
        .t(enable && q[7]), 
        .clk(clk), 
        .clr(reset), 
        .q(q[6])
    );   

    t_tff t2(
        .t(enable && q[6]), 
        .clk(clk), 
        .clr(reset), 
        .q(q[5])
    );   

    t_tff t3(
        .t(enable && q[5]), 
        .clk(clk), 
        .clr(reset), 
        .q(q[4])
    );   

    t_tff t4(
        .t(enable && q[4]), 
        .clk(clk), 
        .clr(reset), 
        .q(q[3])
    );   

    t_tff t5(
        .t(enable && q[3]), 
        .clk(clk), 
        .clr(reset), 
        .q(q[2])
    );   
    
    t_tff t6(
        .t(enable && q[2]), 
        .clk(clk), 
        .clr(reset), 
        .q(q[1])
    );   

     t_tff t7(
        .t(enable && q[1]), 
        .clk(clk), 
        .clr(reset), 
        .q(q[0])
    );   
endmodule;

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

module counter(input [3:0] KEY, input [9:0] SW, output [6:0] HEX0, output [6:0] HEX1);
    wire [7:0] Counter;
    eight_bit_counter c(~KEY[0], SW[0], SW[1]);
    sevenseg s0(HEX0, Counter[3:0], 1'b0);
    sevenseg s1(HEX1, Counter[7:4], 1'b0);
endmodule;