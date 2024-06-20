module ForwardingUnit (
    input branch,
    input [4:0] IDEX_RD1,
    input [4:0] IDEX_RD2,
    input [4:0] IFID_RD1,
    input [4:0] IFID_RD2,
    input [4:0] EXMEM_rsW,
    input [4:0] MEMWB_WD,
    input       EXMEM_RegWrite,
    input       MEMWB_RegWrite,
    output reg [1:0] Forward_ID_A,
    output reg [1:0] Forward_ID_B,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);

always @(*) begin
    // Forward EXMEM->EX
    if (EXMEM_RegWrite==1'b1 && IDEX_RD1 == EXMEM_rsW && EXMEM_rsW != 0) ForwardA = 2'b01;
    // Forward MEMWB->EX (load)
    else if (MEMWB_RegWrite==1'b1 && IDEX_RD1 == MEMWB_WD && MEMWB_WD != 0) ForwardA = 2'b10;
    else ForwardA = 2'b00;

    // Forward EXMEM->ID (addi->nop->beq)
    if (EXMEM_RegWrite==1'b1 && IFID_RD1 == EXMEM_rsW && EXMEM_rsW != 0) Forward_ID_A = 2'b01;
    //Forward MEMWB->ID (load->nop->nop->beq)
    else if (branch && MEMWB_RegWrite==1'b1 && IFID_RD1 == MEMWB_WD && MEMWB_WD != 0) Forward_ID_A = 2'b10;
    else Forward_ID_A = 2'b00;
    
    // For RD2
    if (EXMEM_RegWrite==1'b1 && IDEX_RD2 == EXMEM_rsW && EXMEM_rsW != 0) ForwardB =  2'b01;
    else if (MEMWB_RegWrite==1'b1 && IDEX_RD2 == MEMWB_WD && MEMWB_WD != 0) ForwardB = 2'b10;
    else ForwardB = 2'b00;

    // Forward EXMEM->ID (addi->nop->beq)
    if (EXMEM_RegWrite==1'b1 && IFID_RD2 == EXMEM_rsW && EXMEM_rsW != 0) Forward_ID_B = 2'b01;
    //Forward MEMWB->ID (load->nop->nop->beq)
    else if (branch && MEMWB_RegWrite==1'b1 && IFID_RD2 == MEMWB_WD && MEMWB_WD != 0) Forward_ID_B = 2'b10;
    else Forward_ID_B = 2'b00;
end

endmodule
