module HazardDetect(
    input [4:0] IFID_rs1,
    input [4:0] IFID_rs2,
    input [4:0] IDEX_rd,
    input [4:0] EXMEM_rd,
    input IDEX_memRead,
    input IDEX_regWrite,
    input EXMEM_memRead,
    input PCSel,
    input branch,
    output reg PC_write,
    output reg IFID_write,
    output reg IFID_flush,
    output reg control_flush
);

always @(*) begin
    // load data hazard
    if (IDEX_memRead==1'b1 && (IDEX_rd == IFID_rs1 || IDEX_rd == IFID_rs2)) begin
        PC_write = 1'b0;
        IFID_write = 1'b0;
        IFID_flush = 1'b0;
        control_flush = 1'b1;
    end 
    
    // beq data hazard (load->nop->beq)
    else if (branch && EXMEM_memRead==1'b1 && (EXMEM_rd == IFID_rs1 || EXMEM_rd == IFID_rs2)) begin
        PC_write = 1'b0;
        IFID_write = 1'b0;
        IFID_flush = 1'b0;
        control_flush = 1'b1;
    end

    // beq data hazard (addi->beq)
    else if (branch && IDEX_memRead==1'b0 && IDEX_regWrite==1'b1 && (IDEX_rd == IFID_rs1 || IDEX_rd == IFID_rs2)) begin
        PC_write = 1'b0;
        IFID_write = 1'b0;
        IFID_flush = 1'b0;
        control_flush = 1'b1;
    end

    // beq flush (PCTaken)
    else if (PCSel) begin
        PC_write = 1'b1;
        IFID_write = 1'b0;
        IFID_flush = 1'b1;
        control_flush = 1'b0;
    end
    
    else begin
        PC_write = 1'b1;
        IFID_write = 1'b1;
        IFID_flush = 1'b0;
        control_flush = 1'b0;
    end         
end

endmodule
