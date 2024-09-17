module BranchComp (
    input signed [31:0] A, B,
    input [6:0] IFID_opcode,
    input branch,
    input [2:0] funct3,
    output reg PCSel
);
    
    wire zero = (A - B == 0);
    wire less_than = (A - B < 0);

    always @(*) begin
    	// jal
        if (IFID_opcode == 7'b1101111) PCSel = 1;
        else if (branch) begin
            // jalr
            if (IFID_opcode == 7'b1100111) PCSel = 1;
            // beq
            else if (funct3 == 3'b000 && zero) PCSel = 1;
            // bne
            else if (funct3 == 3'b001 && ~zero) PCSel = 1;
            // blt
            else if (funct3 == 3'b100 && less_than) PCSel = 1;
            // bge
            else if (funct3 == 3'b101 && ~less_than) PCSel = 1;
            else PCSel = 0;
        end
        else PCSel = 0;
    end

endmodule

