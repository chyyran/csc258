module shiftreg(SW, KEY, LEDR);
	input [9:0] SW;
	input [3:0] KEY;
	input [7:0] LEDR;
	Shifter s0(
	.LoadVal(SW[7:0]), 
	.Load_n(~KEY[1]), 
	.ShiftRight(~KEY[2]), 
	.ASR(~KEY[3]), 
	.clk(~KEY[0]), 
	.reset_n(SW[9]), 
	.Q(LEDR[7:0])
	);

endmodule

module Shifter(LoadVal, Load_n, ShiftRight, ASR, clk, reset_n, Q);
	input [7:0] LoadVal;
	input Load_n, ShiftRight, ASR, clk, reset_n;
	output [7:0] Q;
	wire w0;
	
	asrcircuit asr7(
		.asr(ASR),
		.first(LoadVal[7]),
		.m(w0)
	);
	
	ShifterBit SB7(LoadVal[7], w0, ShiftRight, Load_n, clk, reset_n, Q[7]);
	ShifterBit SB6(LoadVal[6], Q[7], ShiftRight, Load_n, clk, reset_n, Q[6]);
	ShifterBit SB5(LoadVal[5], Q[6], ShiftRight, Load_n, clk, reset_n, Q[5]);
	ShifterBit SB4(LoadVal[4], Q[5], ShiftRight, Load_n, clk, reset_n, Q[4]);
	ShifterBit SB3(LoadVal[3], Q[4], ShiftRight, Load_n, clk, reset_n, Q[3]);
	ShifterBit SB2(LoadVal[2], Q[3], ShiftRight, Load_n, clk, reset_n, Q[2]);
	ShifterBit SB1(LoadVal[1], Q[2], ShiftRight, Load_n, clk, reset_n, Q[1]);
	ShifterBit SB0(LoadVal[0], Q[1], ShiftRight, Load_n, clk, reset_n, Q[0]);

endmodule

module ShifterBit(load_val, in, shift, load_n, clk, reset_n, out);
	input load_val, in, shift, load_n, clk, reset_n;
	output out;
	wire data_to_dff;
	wire data_from_other_mux;
	
	mux2to1 M0(
	.x(out),
	.y(in),
	.s(shift),
	.m(data_from_other_mux)
	);
	
	mux2to1 M1(
	.x(load_val),
	.y(data_from_other_mux),
	.s(load_n),
	.m(data_to_dff)
	);
	
	flipflop F0(
	.d(data_to_dff),
	.q(out),
	.clock(clk),
	.reset_n(reset_n)
	);
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
endmodule

module flipflop(d, q, clock, reset_n);
	input clock;
	input reset_n;
	input d;
	output q;
	reg q;

	always @(posedge clock)
	begin
		if (reset_n == 1'b0)
			q <= 1'b0;
		else
			q <= d;
	end
endmodule

module asrcircuit(asr, first, m);
	input asr, first;
	output reg m;
	always @(*)
	begin
		if (asr == 1'b1)
			m <= first;
		else
			m <= 1'b0;
	end
endmodule