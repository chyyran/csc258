// Part 2 skeleton

module vga_adapter_drv
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire ld_x, ld_y, ld_col, en;


	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
  // Instansiate datapath
	// datapath d0(...);
	datapath d0(	.clock(CLOCK_50),
					.enable(en),
					.ld_x(ld_x),
					.ld_y(ld_y),
					.ld_colour(ld_c),
					.reset_n(resetn),
					.buf_colour(SW[9:7]),
					.buf_pos(SW[6:0]),
					.out_x(x),
					.out_y(y),
					.out_colour(colour));

					//ld_x, ld_y, ld_colour, plot, en
	
    // Instansiate FSM control
   control c0(	.clock(CLOCK_50),
				.reset_n(resetn),
				.ld_state(KEY[3]),
				.start_plot(KEY[0]),
				.ld_x(ld_x),
				.ld_y(ld_y),
				.ld_colour(ld_c),
				.plot(writeEn),
				.enable(en));
    
endmodule

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


module control
	(
		input clock, reset_n, ld_state, start_plot,
		output reg ld_x, ld_y, ld_colour, plot, enable
	);
	
	reg [2:0] curr, next;

	localparam 	Load_x = 3'b000,
				Load_y = 3'b001,
				Load_colour = 3'b010,
				Plot = 3'b100;
					
	always @(*) begin
		case (curr)
			Load_x: next = ld_state ? Load_y : Load_x;
			Load_y: next = ld_state ? Load_colour : Load_y;
			Load_colour: next = start_plot ? Plot : Load_colour;
			Plot: next = ld_state ? Load_x : Plot;
		endcase
	end
	
	always @(*) begin
		ld_x = 1'b0;
		ld_y = 1'b0;
		ld_colour = 1'b0;
		
		case (curr)
			Load_x: begin
				ld_x = 1;
				enable = 1;
			end
			Load_y: begin
				ld_y = 1; 
				enable = 1;
			end
			Load_colour: begin
				ld_colour = 1;
				enable = 1;
			end
			Plot: begin
				plot = 1; enable = 1;
			end
		endcase
	end
	
	always @(posedge ld_state, negedge reset_n, posedge start_plot) begin
		if (!reset_n)
			curr <= Load_x;
		else
			curr <= next;
	end

endmodule