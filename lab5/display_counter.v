
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


module rate_divider(input clock, input clear_b, input [31:0] load_cycles, output trigger);
    reg [31:0] q;

    always @(posedge clock) begin
        if (~clear_b) 
            q <= load_cycles;
        else if (q == 0)
            q <= load_cycles;
        else 
            q = q-1;
    end

    assign trigger = (q == 0) ? 1 : 0;
endmodule

module rate_divider_mux(input clock, input clear_b, input [1:0] modes, output enable);

    reg [31:0] rate;

    always @(*) begin
        case (modes)
            2'b00: rate = 1;
            2'b01: rate = 50 000 000;
            2'b10: rate = 100 000 000;
            2'b11: rate = 200 000 000;
        endcase
    end

    rate_divider rd0(clock, clear_b, rate, enable);
endmodule

module counter(input clock, input enable, input reset_n, input load_n, input [3:0] d, output reg [3:0] q);
    always @(posedge clock) begin
        if (~reset_n)
            q <= 0;
        else if (load_n)
            q <= d;
        else if (enable) begin
            if (q == 4'b1111)
                q <= 0;
            else
                q <= q + 1; 
        end
    end
endmodule

module display_counter(output [6:0] HEX0, input CLOCK_50, input [9:0] SW);
    wire [3:0] count;
    wire enable;

    rate_divider_mux rd(CLOCK_50, SW[9], SW[1:0], enable);
    counter c0(CLOCK_50, enable, SW[9], SW[8], 4'b0000, count);
    sevenseg seg0(HEX0, count, 1'b0);
endmodule