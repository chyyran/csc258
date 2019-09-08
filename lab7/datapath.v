module offset_counter (input clock, input enable, input reset_n, input [1:0] off_edge, output reg [2:0] curr_off);
	always @(posedge clock, negedge reset_n) begin
		if (~reset_n) begin 
			curr_off <= 0;
		end
		else if (enable) begin
			if (curr_off == off_edge) begin // counter = 0
				curr_off <= 0;
			end
			else begin 
				curr_off <= curr_off + 1;
			end
		end
	end
endmodule


module datapath
	(
		input clock, reset_n, enable, ld_x, ld_y, ld_colour, 
		input [6:0] buf_pos, output [2:0] buf_colour,
		output [7:0] out_x, [6:0] out_y, output [2:0] out_colour
	);

	reg [7:0] draw_x;
	reg [6:0] draw_y;
	reg [2:0] draw_colour;

	wire [2:0] off_x, off_y;

	// output box corrdinates
	assign out_x = draw_x + off_x;
	assign out_y = draw_y + off_y;
	assign out_colour = draw_colour;

	// Read in from buf.
	always @(posedge clock) begin
		if (!reset_n) begin
			draw_x <= 8'b0;
			draw_y <= 7'b0;
			draw_colour <= 3'b0;
		end
		else begin
			if (ld_x)
				draw_x <= {1'b0, buf_pos};
			if (ld_y)
				draw_y <= buf_pos;
			if (ld_colour)
				draw_colour <= buf_colour;
		end
	end

	offset_counter c_off_x( .clock(clock),
						  .enable(enable),
						  .reset_n(reset_n),
						  .off_edge(2'b11),
						  .curr_off(off_x)
					);
				
	offset_counter c_off_y(
						.clock(clock),
						.enable(enable),
						.reset_n(reset_n),
						.off_edge(2'b11),
						.curr_off(off_y)
				);
endmodule