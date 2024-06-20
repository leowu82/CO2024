module PC (
    input clk,
    input rst,
    input PCWrite,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);

    // TODO: implement your program counter here
    always @(posedge clk, negedge rst) begin
        if (~rst) pc_o <= 0;
        else if (PCWrite) pc_o <= pc_i;
        else pc_o <= pc_o;
    end

endmodule

