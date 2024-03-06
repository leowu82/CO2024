module Control (
    input [6:0] opcode,
    output reg branch,
    output reg memRead,
    output reg memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite
);

    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal
    always @(opcode) begin
        branch = opcode[0];
        memRead = opcode[1];
        memtoReg = opcode[2];
        ALUOp = opcode[3];
        memwrite = opcode[4];
        ALUSrc = opcode[5];
        regWrite = opcode[6];
    end

endmodule

