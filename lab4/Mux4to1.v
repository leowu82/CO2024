module Mux4to1 #(
    parameter size = 32
) 
(
    input [1:0] sel,
    input signed [size-1:0] s0,
    input signed [size-1:0] s1,
    input signed [size-1:0] s2,
    output signed [size-1:0] out
);
    // TODO: implement your 2to1 multiplexer here

    reg signed [size-1:0] temp;

    always@ (*) begin
        case (sel)
            2'b00: temp = s0;
            2'b01: temp = s1;
            2'b10: temp = s2;
            default: temp = 32'bx;
        endcase
    end

    assign out = temp;
    
endmodule

