module flipflop(input reset_n, input clock, input d, output reg q);
    always @(posedge clock)
    begin
        if (reset_n == 1'b0)
            q <= 0;
        else
            q <= d;
    end
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
endmodule


module bit_shifter(input clock, input in, input shift, input load_val, input load_n, input reset_n, output out);

	 wire data_to_dff, data_from_other_mux;

    mux2to1 m0(
	     .x(out),
        .y(in),
        .s(shift),
        .m(data_from_other_mux)
    );

    mux2to1 m1(
        .x(load_val),
        .y(data_from_other_mux),
        .s(load_n),
        .m(data_to_dff)
    );

    flipflop f0(
        .d(data_to_dff),
        .reset_n(reset_n),
        .clock(clock),
        .q(out)
    );

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

module eight_bit_shifter(input clock, input shift, input asr_bit, input [7:0] load_val, input load_n, input reset_n, output [7:0] out);
     wire asr_out;
    // asr asr0(asr_bit, asr_out);

		 asrcircuit asr7(
			.asr(asr_bit),
			.first(load_val[7]),
			.m(asr_out)
		 );
	 
	 
//	 	ShifterBit SB7(.load_val(LoadVal[7]), .in(w0), .shift(ShiftRight), .load_n(Load_n), .clock(clk), .reset_n(reset_n), .out(Q[7]));
//
//		
//	 
//	 ShifterBit SB7(LoadVal[7], w0, ShiftRight, Load_n, clk, reset_n, Q[7]);
//		ShifterBit SB6(LoadVal[6], Q[7], ShiftRight, Load_n, clk, reset_n, Q[6]);
//		ShifterBit SB5(LoadVal[5], Q[6], ShiftRight, Load_n, clk, reset_n, Q[5]);
//		ShifterBit SB4(LoadVal[4], Q[5], ShiftRight, Load_n, clk, reset_n, Q[4]);
//		ShifterBit SB3(LoadVal[3], Q[4], ShiftRight, Load_n, clk, reset_n, Q[3]);
//		ShifterBit SB2(LoadVal[2], Q[3], ShiftRight, Load_n, clk, reset_n, Q[2]);
//		ShifterBit SB1(LoadVal[1], Q[2], ShiftRight, Load_n, clk, reset_n, Q[1]);
//		ShifterBit SB0(LoadVal[0], Q[1], ShiftRight, Load_n, clk, reset_n, Q[0]);
	 
    bit_shifter b7(
	     .load_val(load_val[7]),
        .in(asr_out),
		  .shift(shift),
		  .load_n(load_n),
        .clock(clock),
		   .reset_n(reset_n),
        .out(out[7]),
    );
	 
	  bit_shifter b6(
	     .load_val(load_val[6]),
        .in(out[7]),
		  .shift(shift),
		  .load_n(load_n),
        .clock(clock),
		   .reset_n(reset_n),
        .out(out[6]),
    );
    
	  bit_shifter b5(
	     .load_val(load_val[5]),
        .in(out[6]),
		  .shift(shift),
		  .load_n(load_n),
        .clock(clock),
		   .reset_n(reset_n),
        .out(out[5]),
    );
	 
	  bit_shifter b4(
	     .load_val(load_val[4]),
        .in(out[5]),
		  .shift(shift),
		  .load_n(load_n),
        .clock(clock),
		   .reset_n(reset_n),
        .out(out[4]),
    );
	 
	  bit_shifter b3(
	     .load_val(load_val[3]),
        .in(out[4]),
		  .shift(shift),
		  .load_n(load_n),
        .clock(clock),
		   .reset_n(reset_n),
        .out(out[3]),
    );
    
	 
	  bit_shifter b2(
	     .load_val(load_val[2]),
        .in(out[3]),
		  .shift(shift),
		  .load_n(load_n),
        .clock(clock),
		   .reset_n(reset_n),
        .out(out[2]),
    );
    
	 
	  bit_shifter b1(
	     .load_val(load_val[1]),
        .in(out[2]),
		  .shift(shift),
		  .load_n(load_n),
        .clock(clock),
		   .reset_n(reset_n),
        .out(out[1]),
    );
    
    
	  bit_shifter b0(
	     .load_val(load_val[0]),
        .in(out[1]),
		  .shift(shift),
		  .load_n(load_n),
        .clock(clock),
		   .reset_n(reset_n),
        .out(out[0]),
    );
    
    
    
endmodule



module shifter(SW, KEY, LEDR);

    input [9:0] SW;
    input [3:0] KEY;
    output [7:0] LEDR;
	
	
    eight_bit_shifter shift(
        .load_val(SW[7:0]),
        .reset_n(SW[9]),
        .clock(~KEY[0]),
        .load_n(KEY[1]),
        .shift(KEY[2]),
        .asr_bit(KEY[3]),
        .out(LEDR)
    );
endmodule