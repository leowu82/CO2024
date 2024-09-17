module ForwardingUnit (
    input branch,
    input [4:0] IFID_rs1,
    input [4:0] IFID_rs2,
    input [4:0] IDEX_rs1,
    input [4:0] IDEX_rs2,
    input [4:0] EXMEM_rd,
    input [4:0] MEMWB_rd,
    input       EXMEM_regWrite,
    input       MEMWB_regWrite,
    output reg [1:0] Forward_ID_A,
    output reg [1:0] Forward_ID_B,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);

always @(*) begin
    // Forward EXMEM->EX
    if (EXMEM_regWrite==1'b1 && IDEX_rs1 == EXMEM_rd && EXMEM_rd != 0) ForwardA = 2'b01;
    // Forward MEMWB->EX (load)
    else if (MEMWB_regWrite==1'b1 && IDEX_rs1 == MEMWB_rd && MEMWB_rd != 0) ForwardA = 2'b10;
    else ForwardA = 2'b00;

    // Forward EXMEM->ID (addi->nop->beq)
    if (branch && EXMEM_regWrite==1'b1 && IFID_rs1 == EXMEM_rd && EXMEM_rd != 0) Forward_ID_A = 2'b01;
    //Forward MEMWB->ID (load->nop->nop->beq)
    else if (branch && MEMWB_regWrite==1'b1 && IFID_rs1 == MEMWB_rd && MEMWB_rd != 0) Forward_ID_A = 2'b10;
    else Forward_ID_A = 2'b00;
    
    // For RD2
    if (EXMEM_regWrite==1'b1 && IDEX_rs2 == EXMEM_rd && EXMEM_rd != 0) ForwardB =  2'b01;
    else if (MEMWB_regWrite==1'b1 && IDEX_rs2 == MEMWB_rd && MEMWB_rd != 0) ForwardB = 2'b10;
    else ForwardB = 2'b00;

    // Forward EXMEM->ID (addi->nop->beq)
    if (branch && EXMEM_regWrite==1'b1 && IFID_rs2 == EXMEM_rd && EXMEM_rd != 0) Forward_ID_B = 2'b01;
    //Forward MEMWB->ID (load->nop->nop->beq)
    else if (branch && MEMWB_regWrite==1'b1 && IFID_rs2 == MEMWB_rd && MEMWB_rd != 0) Forward_ID_B = 2'b10;
    else Forward_ID_B = 2'b00;
end

endmodule
