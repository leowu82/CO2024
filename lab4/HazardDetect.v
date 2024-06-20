module HazardDetect(
    input [6:0] IFID_opcode,
    input [4:0] IFID_reg1,
    input [4:0] IFID_reg2,
    input [4:0] IDEX_regRd,
    input [4:0] EXMEM_regRd,
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
    if (IDEX_memRead==1'b1 && (IDEX_regRd == IFID_reg1 || IDEX_regRd == IFID_reg2)) begin
        PC_write = 1'b0;
        IFID_write = 1'b0;
        IFID_flush = 1'b0;
        control_flush = 1'b1;
    end 
    
    // beq data hazard (load->nop->beq)
    else if (IFID_opcode!=7'b1101111 && branch && EXMEM_memRead==1'b1 && (EXMEM_regRd == IFID_reg1 || EXMEM_regRd == IFID_reg2)) begin
        PC_write = 1'b0;
        IFID_write = 1'b0;
        IFID_flush = 1'b0;
        control_flush = 1'b1;
    end

    // beq data hazard (addi->beq)
    else if (IFID_opcode!=7'b1101111 && branch && IDEX_memRead==1'b0 && IDEX_regWrite==1'b1 && (IDEX_regRd == IFID_reg1 || IDEX_regRd == IFID_reg2)) begin
        PC_write = 1'b0;
        IFID_write = 1'b0;
        IFID_flush = 1'b0;
        control_flush = 1'b1;
    end

    // beq flush (jump)
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
