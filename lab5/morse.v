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


module lookup_table