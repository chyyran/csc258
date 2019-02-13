module rate_divider(input clock, input clear_b, input [31:0] load_cycles, output trigger);
    reg [31:0] q;

    always @(posedge clock, negedge clear_b) begin
        if (~clear_b) 
            q <= load_cycles;
        else if (~|q)
            q <= load_cycles;
        else 
            q <= q-1;
    end

    assign trigger ~|q;
endmodule

module bit_shifter(input clock, input reset_n, input [13:0] load_val, input load_n, output out);

   reg [13:0] r_reg;
 
   always @(posedge clock, negedge reset_n, posedge load_n) begin
      if (~reset_n)
         r_reg <= 0;
      else if (load_n)
         r_reg <= load_val;
      else
         r_reg <= { 1'b0, r_reg[13:1] };
	end

	assign out = r_reg[13];
endmodule

// 25 000 000  = 0.5 seconds


/*
 * S | * * *   |
 * T | -       |
 * U | * * -   |
 * V | * * * - |
 * W | * - -   |
 * X | - * * - | 
 * Y | - * - - |
 * Z | - - * * |
 */
module lookup_table(input [2:0] letter, output reg [13:0] sequence);
    always @(*) begin
        case (letter)
            0: sequence = 14'b10101000000000; // S 10 10 10
            1: sequence = 14'b11100000000000; // T 1110
            2: sequence = 14'b10101110000000; // U 10 10 1110
            3: sequence = 14'b10101011100000; // V 10 10 10 1110
            4: sequence = 14'b10111011100000; // W 10 1110 1110
            5: sequence = 14'b11101010111000; // X 1110 10 10 1110 
            6: sequence = 14'b11101011101110; // Y 1110 10 1110 1110
            7: sequence = 14'b11101110101000; // Z 1110 1110 10 10
        endcase
    end
endmodule

module morse(input [9:0] SW, input [3:0] KEY, input CLOCK_50, output [9:0] LEDR);
    wire [13:0] sequence;
    wire enable;
    lookup_table lut0(SW[2:0], sequence);
    rate_divider rd0(CLOCK_50, KEY[1], 25000000, enable);
    bit_shifter shift0(enable, KEY[0], sequence, ~KEY[1], LEDR[0]);
endmodule