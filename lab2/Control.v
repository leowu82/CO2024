module Control (
    input [6:0] opcode,
    output reg branch,
    output reg memRead,
    output reg [1:0] memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc_A,
    output reg ALUSrc_B,
    output reg regWrite,
    output reg PCSel
);

    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal
    always @(*) begin
        case(opcode)
            // R-type
            7'b0110011: begin
                ALUSrc_A   = 0;
                ALUSrc_B   = 0;
                memtoReg = 2'b00;
                regWrite = 1;
                memRead  = 0;
                memWrite = 0;
                branch   = 0;
                ALUOp[1] = 1;
                ALUOp[0] = 0;
                PCSel = 0;
            end
            // ld
            7'b0000011: begin
                ALUSrc_A   = 0;
                ALUSrc_B   = 1;
                memtoReg = 2'b01;
                regWrite = 1;
                memRead  = 1;
                memWrite = 0;
                branch   = 0;
                ALUOp[1] = 0;
                ALUOp[0] = 0;
                PCSel = 0;
            end
            // sd
            7'b0100011: begin
                ALUSrc_A   = 0;
                ALUSrc_B   = 1;
                memtoReg = 2'bxx;
                regWrite = 0;
                memRead  = 0;
                memWrite = 1;
                branch   = 0;
                ALUOp[1] = 0;
                ALUOp[0] = 0;
                PCSel = 0;
            end
            // beq
            7'b1100011: begin
                ALUSrc_A   = 0;
                ALUSrc_B   = 0;
                memtoReg = 2'bxx;
                regWrite = 0;
                memRead  = 0;
                memWrite = 0;
                branch   = 1;
                ALUOp[1] = 0;
                ALUOp[0] = 1;
                PCSel = 0;
            end
            // I-type
            7'b0010011: begin
                ALUSrc_A   = 0;
                ALUSrc_B   = 1;
                memtoReg = 2'b00;
                regWrite = 1;
                memRead  = 0;
                memWrite = 0;
                branch   = 0;
                ALUOp[1] = 1;
                ALUOp[0] = 1;
                PCSel = 0;
            end
            // jal
            7'b1101111: begin
                ALUSrc_A   = 1;
                ALUSrc_B   = 1;
                memtoReg = 2'b10;
                regWrite = 1;
                memRead  = 0;
                memWrite = 0;
                branch   = 1;
                ALUOp[1] = 1'bx;
                ALUOp[0] = 1'bx;
                PCSel = 0;
            end
            // jalr
            7'b1100111: begin
                ALUSrc_A   = 0;
                ALUSrc_B   = 1;
                memtoReg = 2'b10;
                regWrite = 1;
                memRead  = 0;
                memWrite = 0;
                branch   = 0;
                ALUOp[1] = 1;
                ALUOp[0] = 1;
                PCSel = 1;
            end
            default: begin
                ALUSrc_A   = 1'bx;
                ALUSrc_B   = 1'bx;
                memtoReg = 2'bxx;
                regWrite = 1'bx;
                memRead  = 1'bx;
                memWrite = 1'bx;
                branch   = 1'bx;
                ALUOp[1] = 1'bx;
                ALUOp[0] = 1'bx;
                PCSel = 1'bx;
            end
        endcase
    end

endmodule

