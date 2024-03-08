module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] inst,
    output reg signed [31:0] imm
);
    // ImmGen generate imm value base opcode

    wire [6:0] opcode = inst[6:0];
    always @(inst) begin
        case(opcode)
            // TODO: implement your ImmGen here
            // Hint: follow the RV32I opcode map (table in spec) to set imm value

            // beq
            7'b1100011: imm <= {{21{inst[31]}}, inst[7], inst[30:25], inst[11:8]};
            // lw
            7'b0000011: imm <= {{21{inst[31]}}, inst[30:20]};
            // sw
            7'b0100011: imm <= {{21{inst[31]}}, inst[30:25], inst[11:7]};
            // i-type
            7'b0010011: imm <= {{21{inst[31]}}, inst[30:20]};
        endcase
    end

endmodule

