module PipelineReg #(
    parameter size = 32
) 
(
    input clk, 
    input rst, 
    input flush,
    input write,
    input [size-1:0] data_i, 
    output reg [size-1:0] data_o
);

always @(posedge clk, negedge rst) begin
    if (~rst) data_o <= 0; 
    else if (flush) data_o <= 0;
    else if (write) data_o <= data_i;
    else data_o <= data_o;
end

endmodule
