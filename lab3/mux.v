
module mux7_1(Out, Input, MuxSelect);
    output reg Out;
    input [6:0] Input;
    input [2:0] MuxSelect;

    always @(*)
    begin
      case (MuxSelect[2:0])
        3'b000: Out = Input[0];
        3'b001: Out = Input[1];
        3'b010: Out = Input[2];
        3'b011: Out = Input[3];
        3'b100: Out = Input[4];
        3'b101: Out = Input[5];
        3'b110: Out = Input[6];
        default: Out = Input[0];
      endcase
    end
endmodule

module mux(SW, LEDR);
    input [9:0] SW;
    output [9:0] LEDR;


    mux7_1 mux0(
        .Out(LEDR[0]), 
        .Input(SW[6:0]), 
        .MuxSelect(SW[9:7])
    );

endmodule
