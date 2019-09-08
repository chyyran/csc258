

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
			Load_colour: next = ld_state ? Plot : Load_colour;
			Plot: next = start_plot ? Load_x : Plot;
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
	
	always @(posedge ld_state, negedge reset_n) begin
		if (!reset_n)
			curr <= Load_x;
		else
			curr <= next;
	end

endmodule