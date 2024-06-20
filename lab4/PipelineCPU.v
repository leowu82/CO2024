module PipelineCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize PipelineCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

// Init
wire [31:0] pc_curr;
wire [31:0] pc_next;
wire PCWrite;
wire [31:0] pc_add4;
wire [31:0] inst;
wire [63:0] IF_ID;
wire IFID_flush, IFID_write;
wire control_flush;
wire branch, memRead, memWrite, ALUSrc_A, ALUSrc_B, regWrite;
wire [1:0] ALUOp, memtoReg;
wire [31:0] writeDataa, RD1, RD2;
wire [31:0] imm;
wire [1:0] ForwardA, ForwardB, Forward_ID_A, Forward_ID_B;
wire [31:0] RD1_Forward, RD2_Forward;
wire PCSel;
wire [31:0] pc_addImm;
wire [155:0] ID_EX;
wire [31:0] Forward_ALU_A, Forward_ALU_B;
wire [31:0] ALU_A;
wire [31:0] ALU_B;
wire [3:0] ALUCtl;
wire [31:0] ALUOut;
wire [105:0] EX_MEM;
wire [31:0] pc_add4_recalc;
wire [31:0] readData;
wire [103:0] MEM_WB;

// pc add 4
Adder m_Adder_1(
    .a(pc_curr),
    .b(4),
    .sum(pc_add4)
);

// PCSel
Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(PCSel),
    .s0(pc_add4),
    .s1(pc_addImm),
    .out(pc_next)
);

PC m_PC(
    .clk(clk),
    .rst(start),
    .PCWrite(PCWrite),
    .pc_i(pc_next),
    .pc_o(pc_curr)
);

InstructionMemory m_InstMem(
    .readAddr(pc_curr),
    .inst(inst)
);

// IF_ID
PipelineReg #(.size(64)) m_IF_ID(
    .clk(clk),
    .rst(start),
    .flush(IFID_flush),
    .write(IFID_write),
    .data_i({pc_curr, inst}),
    .data_o(IF_ID)
);

// Hazard detect
HazardDetect HD_Unit(
    .IFID_opcode(IF_ID[6:0]),
    .IFID_reg1(IF_ID[19:15]),
    .IFID_reg2(IF_ID[24:20]),
    .IDEX_regRd(ID_EX[4:0]),
    .EXMEM_regRd(EX_MEM[4:0]),
    .IDEX_memRead(ID_EX[140]),
    .IDEX_regWrite(ID_EX[141]),
    .EXMEM_memRead(EX_MEM[102]),
    .PCSel(PCSel),
    .branch(branch),
    .PC_write(PCWrite),
    .IFID_write(IFID_write),
    .IFID_flush(IFID_flush),
    .control_flush(control_flush)
);

Control m_Control(
    .opcode(IF_ID[6:0]),
    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc_A(ALUSrc_A),
    .ALUSrc_B(ALUSrc_B),
    .regWrite(regWrite)
);

// control flush
wire [8:0] EX_control;
Mux2to1 #(.size(9)) MUX_control_flush(
    .sel(control_flush),
    .s0({memRead, memtoReg, ALUOp, memWrite, ALUSrc_A, ALUSrc_B, regWrite}),
    .s1(9'b000000000),
    .out(EX_control)
);

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(MEM_WB[101]),
    .readReg1(IF_ID[19:15]),
    .readReg2(IF_ID[24:20]),
    .writeReg(MEM_WB[4:0]),
    .writeData(writeDataa),
    .readData1(RD1),
    .readData2(RD2)
);

// ======= for validation ======= 
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen(
    .inst(IF_ID[31:0]),
    .imm(imm)
);

ForwardingUnit FW_Unit(
    .branch(branch),
    .IDEX_RD1(ID_EX[155:151]),
    .IDEX_RD2(ID_EX[150:146]),
    .IFID_RD1(IF_ID[19:15]),
    .IFID_RD2(IF_ID[24:20]),
    .EXMEM_rsW(EX_MEM[4:0]),
    .MEMWB_WD(MEM_WB[4:0]),
    .EXMEM_RegWrite(EX_MEM[103]),
    .MEMWB_RegWrite(MEM_WB[101]),
    .Forward_ID_A(Forward_ID_A),
    .Forward_ID_B(Forward_ID_B),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

// Branch Mux
Mux4to1 #(.size(32)) BranchMuxA(
    .sel(Forward_ID_A),
    .s0(RD1),
    .s1(EX_MEM[68:37]),
    .s2(MEM_WB[36:5]),
    .out(RD1_Forward)
);

Mux4to1 #(.size(32)) BranchMuxB(
    .sel(Forward_ID_B),
    .s0(RD2),
    .s1(EX_MEM[68:37]),
    .s2(MEM_WB[36:5]),
    .out(RD2_Forward)
);

// BranchComp
BranchComp m_BranchComp (
    .A(RD1_Forward),
    .B(RD2_Forward),
    .IFID_opcode(IF_ID[6:0]),
    .branch(branch),
    .funct3(IF_ID[14:12]),
    .PCSel(PCSel)
);

Adder m_Adder_2(
    .a((IF_ID[6:0] == 7'b1100111) ? RD1_Forward : IF_ID[63:32]),
    .b(imm),
    .sum(pc_addImm)
);

PipelineReg #(.size(156)) m_ID_EX(
    .clk(clk),
    .rst(start), 
    .flush(1'b0),
    .write(1'b1),
    .data_i({
        IF_ID[19:15],  // rs1 155:151
        IF_ID[24:20],  // rs2 150:146
        // controls
        EX_control[2],   // ALUSrc_A 145
        EX_control[1],   // ALUSrc_B 144
        EX_control[7:6], // memtoReg 143:142
        EX_control[0],   // regWrite 141
        EX_control[8],   // memRead  140
        EX_control[3],   // memWrite 139
        EX_control[5],   // ALUOp[1] 138
        EX_control[4],   // ALUOp[0] 137
        // pipe reg
        IF_ID[63:32],  // pc  136:105
        RD1_Forward,   // 32  104: 73
        RD2_Forward,   // 32   72: 41
        imm,           // 32   40: 9
        IF_ID[30],     // func7     8
        IF_ID[14:12],  // func3     7:5
        IF_ID[11:7]    // rsW       4:0
    }), 
    .data_o(ID_EX)
);

// wire [31:0] sl1;
// ShiftLeftOne m_ShiftLeftOne(
//     .i(ID_EX[63:32]),
//     .o(sl1)
// );

// Forward A
Mux4to1 #(.size(32)) MUX_ForwardA(
    .sel(ForwardA),
    .s0(ID_EX[104:73]), // RD1_Forward
    .s1(EX_MEM[68:37]),  // ALUOut
    .s2(MEM_WB[36:5]),   // readData (from DMEM)
    .out(Forward_ALU_A)
);

// Forward B
Mux4to1 #(.size(32)) MUX_ForwardB(
    .sel(ForwardB),
    .s0(ID_EX[72: 41]),  // RD2_Forward
    .s1(EX_MEM[68:37]),  // ALUOut
    .s2(MEM_WB[36:5]),   // readData (from DMEM)
    .out(Forward_ALU_B)
);

// Asel
Mux2to1 #(.size(32)) m_Mux_ALU_A(
    .sel(ID_EX[145]),
    .s0(Forward_ALU_A),
    .s1(ID_EX[136:105]),
    .out(ALU_A)
);

// Bsel
Mux2to1 #(.size(32)) m_Mux_ALU_B(
    .sel(ID_EX[144]),
    .s0(Forward_ALU_B),
    .s1(ID_EX[40:9]),
    .out(ALU_B)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ID_EX[138:137]),
    .funct7(ID_EX[8]),
    .funct3(ID_EX[7:5]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(ALU_A),
    .B(ALU_B),
    .ALUOut(ALUOut)
);

// EX_MEM
PipelineReg #(.size(106)) m_EX_MEM (
    .clk(clk),
    .rst(start),
    .flush(1'b0),
    .write(1'b1),
    .data_i({
        // controls
        ID_EX[143:142], // memtoReg 105:104
        ID_EX[141],     // regWrite 103
        ID_EX[140],     // memRead  102
        ID_EX[139],     // memWrite 101
        // pipe reg
        ID_EX[136:105], // pc  100:69
        ALUOut,         // 32   68:37
        Forward_ALU_B,  // RD2  36:5
        ID_EX[4:0]     // rsW   4:0
    }),
    .data_o(EX_MEM)
);

// pc add 4
Adder m_Adder_3(
    .a(EX_MEM[100:69]),
    .b(4),
    .sum(pc_add4_recalc)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(EX_MEM[101]),
    .memRead(EX_MEM[102]),
    .address(EX_MEM[68:37]),
    .writeData(EX_MEM[36:5]),
    .readData(readData)
);

// MEM_WB
PipelineReg #(.size(104)) m_MEM_WB (
    .clk(clk),
    .rst(start),
    .flush(1'b0),
    .write(1'b1),
    .data_i({
        // controls
        EX_MEM[105:104], // memtoReg 103:102
        EX_MEM[103],     // regWrite 101
        // pipe reg
        pc_add4_recalc,  // 32   100:69
        EX_MEM[68:37],   // ALUOut 32   68:37
        readData,        // 32   36:5
        EX_MEM[4:0]     // rsW  4:0
    }),
    .data_o(MEM_WB)
);

// write back to reg
Mux4to1 #(.size(32)) m_Mux_WriteData(
    .sel(MEM_WB[103:102]),
    .s0(MEM_WB[68:37]),
    .s1(MEM_WB[36:5]),
    .s2(MEM_WB[100:69]),
    .out(writeDataa)
);

endmodule
