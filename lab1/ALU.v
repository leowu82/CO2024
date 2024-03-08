module ALU (
    input [3:0] ALUctl,
    input signed [31:0] A,B,
    output reg signed [31:0] ALUOut,
    output zero
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not (or you can change the design as you wish)

    // TODO: implement your ALU here
    // Hint: you can use operator to implement

    assign zero = (ALUOut == 0);

    always @(ALUctl, A, B) begin
        case (ALUctl)
            // ADD
            4'b0010: ALUOut <= A + B;
            // SUB
            4'b0110: ALUOut <= A + (~B + 1);
            // AND
            4'b0000: ALUOut <= A & B;
            // OR
            4'b0001: ALUOut <= A | B;
            default: ALUOut <= 0;
        endcase
    end
    
endmodule

