module BranchComp (
    input signed [31:0] A, B,
    output zero,
    output less_than
);
    
    assign zero = (A - B == 0);
    assign less_than = (A - B < 0);

endmodule

