module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    // TODO: implement your ALU control here
    // For testbench verifying, Do not modify input and output pin
    // Hint: using ALUOp, funct7, funct3 to select exact operation

    always @(*) begin
        case(ALUOp) 
            2'b00: ALUCtl = 4'b0010;
            2'b01: ALUCtl = 4'b0110;
            2'b10: begin
                if (funct7 == 0 && funct3 == 3'b000) ALUCtl = 4'b0010;
                else if (funct7 == 1 && funct3 == 3'b000) ALUCtl = 4'b0110;
                else if (funct7 == 0 && funct3 == 3'b111) ALUCtl = 4'b0000;
                else if (funct7 == 0 && funct3 == 3'b110) ALUCtl = 4'b0001;
                else if (funct7 == 0 && funct3 == 3'b010) ALUCtl = 4'b0100;
                else ALUCtl = 4'bxxxx;
            end
            2'b11: begin
                if (funct3 == 3'b000) ALUCtl = 4'b0010; // addi
                else if(funct3 == 3'b111) ALUCtl = 4'b0000; // andi
                else if(funct3 == 3'b110) ALUCtl = 4'b0001; // ori
                else if(funct3 == 3'b010) ALUCtl = 4'b0100; // slti
                else ALUCtl = 4'bxxxx;
            end
            default: ALUCtl = 4'bxxxx;
        endcase
    end

endmodule

