
module rate_divider (input clock , input enable, input reset_n, input [2:0] rate, output reg clock_out);
	
	reg [2:0] counter;

	always @(posedge clock, negedge reset_n) begin
		if (~reset_n) begin 
			counter <= rate;
		end
		else if (enable) begin
			if (~counter) begin // counter = 0
				counter <= rate;
			end
			else begin 
				counter <= counter - 1;
			end
		end
	end
	
	assign clock_out = ~counter;
endmodule
