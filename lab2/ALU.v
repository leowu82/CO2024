module ALU (
    input [3:0] ALUctl,
    input signed [31:0] A,B,
    output reg signed [31:0] ALUOut,
    output zero,
    output less_than
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not (or you can change the design as you wish)

    // TODO: implement your ALU here
    // Hint: you can use operator to implement

    assign zero = (ALUOut == 0);
    assign less_than = (ALUOut < 0);

    always @(*) begin
        case (ALUctl)
            // ADD
            4'b0010: ALUOut = A + B;
            // SUB
            4'b0110: ALUOut = A + (~B + 1);
            // AND
            4'b0000: ALUOut = A & B;
            // OR
            4'b0001: ALUOut = A | B;
            // SLT
            4'b0100: begin
                if (A < B) ALUOut = 1;
                else ALUOut = 0;
            end
            default: ALUOut = 0;
        endcase
    end
    
endmodule

