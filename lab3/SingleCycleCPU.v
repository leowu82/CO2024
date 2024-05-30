module SingleCycleCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

wire [31:0] pc_curr;
wire [31:0] pc_next;
PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_next),
    .pc_o(pc_curr)
);

// pc add 4
wire [31:0] pc_add4;
Adder m_Adder_1(
    .a(pc_curr),
    .b(4),
    .sum(pc_add4)
);

wire [31:0] inst;
InstructionMemory m_InstMem(
    .readAddr(pc_curr),
    .inst(inst)
);

// IF_ID
wire [63:0] IF_ID;
PipelineReg #(.size(64)) m_IF_ID(
    .clk(clk),
    .rst(start),
    .data_i({pc_curr, inst}),
    .data_o(IF_ID)
);

wire branch, memRead, memWrite, ALUSrc_A, ALUSrc_B, regWrite;
wire [1:0] ALUOp, memtoReg;
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

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

wire [31:0] writeDataa, RD1, RD2;
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

wire [31:0] imm;
ImmGen m_ImmGen(
    .inst(IF_ID[31:0]),
    .imm(imm)
);

wire [153:0] ID_EX;
PipelineReg #(.size(154)) m_ID_EX(
    .clk(clk),
    .rst(start), 
    .data_i({
        // controls
        ALUSrc_A,      // 153
        ALUSrc_B,      // 152
        memtoReg,      // 151:150
        regWrite,      // 149
        memRead,       // 148
        memWrite,      // 147
        branch,        // 146
        ALUOp[1],      // 145
        ALUOp[0],      // 144
        // pipe reg
        IF_ID[63:32],  // pc  143:112
        RD1,           // 32  111: 80
        RD2,           // 32   79: 48
        imm,           // 32   47: 16
        IF_ID[30],     // func7     15
        IF_ID[14:12],  // func3     14:12
        IF_ID[11:7],   // rsW       11:7
        IF_ID[6:0]     // opcode    6:0
    }), 
    .data_o(ID_EX)
);

// wire [31:0] sl1;
// ShiftLeftOne m_ShiftLeftOne(
//     .i(ID_EX[63:32]),
//     .o(sl1)
// );

// wire [31:0] pc_addImm;
// Adder m_Adder_2(
//     .a(ID_EX[159:128]),
//     .b(sl1),
//     .sum(pc_addImm)
// );

// BranchComp
wire zero, less_than;
BranchComp m_BranchComp (
    .A(ID_EX[111:80]),
    .B(ID_EX[79:48]),
    .zero(zero),
    .less_than(less_than)
);

// Asel
wire [31:0] ALU_A;
Mux2to1 #(.size(32)) m_Mux_ALU_A(
    .sel(ID_EX[153]),
    .s0(ID_EX[111:80]),
    .s1(ID_EX[143:112]),
    .out(ALU_A)
);

// Bsel
wire [31:0] ALU_B;
Mux2to1 #(.size(32)) m_Mux_ALU_B(
    .sel(ID_EX[152]),
    .s0(ID_EX[79:48]),
    .s1(ID_EX[47:16]),
    .out(ALU_B)
);

wire [3:0] ALUCtl;
ALUCtrl m_ALUCtrl(
    .ALUOp(ID_EX[145:144]),
    .funct7(ID_EX[15]),
    .funct3(ID_EX[14:12]),
    .ALUCtl(ALUCtl)
);

wire [31:0] ALUOut;
ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(ALU_A),
    .B(ALU_B),
    .ALUOut(ALUOut)
);

// EX_MEM
wire [118:0] EX_MEM;
PipelineReg #(.size(119)) m_EX_MEM (
    .clk(clk),
    .rst(start),
    .data_i({
        // controls
        ID_EX[151:150], // memtoReg 118:117
        ID_EX[149],     // regWrite 116
        ID_EX[148],     // memRead  115
        ID_EX[147],     // memWrite 114
        ID_EX[146],     // branch   113
        zero,           // 112
        less_than,      // 111
        // pipe reg
        ID_EX[143:112], // pc  110:79
        ALUOut,         // 32   78:47
        ID_EX[79:48],   // RD2  46:15
        ID_EX[14:12],  // func3     14:12
        ID_EX[11:7],   // rsW       11:7
        ID_EX[6:0]     // opcode    6:0
    }),
    .data_o(EX_MEM)
);

// pc add 4
wire [31:0] pc_add4_recalc;
Adder m_Adder_2(
    .a(EX_MEM[110:79]),
    .b(4),
    .sum(pc_add4_recalc)
);

// PCSel
wire branchSel = EX_MEM[113] && ((EX_MEM[6:0] == 7'b1101111) || (EX_MEM[6:0] == 7'b1100111) || (EX_MEM[14:12] == 3'b000 && EX_MEM[112]) || (EX_MEM[14:12] == 3'b001 && ~EX_MEM[112]) || (EX_MEM[14:12] == 3'b100 && EX_MEM[111]) || (EX_MEM[14:12] == 3'b101 && ~EX_MEM[111]));
Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(branchSel),
    .s0(pc_add4),
    .s1(EX_MEM[78:47]),
    .out(pc_next)
);

wire [31:0] readData;
DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(EX_MEM[114]),
    .memRead(EX_MEM[115]),
    .address(EX_MEM[78:47]),
    .writeData(EX_MEM[46:15]),
    .readData(readData)
);

// MEM_WB
wire [103:0] MEM_WB;
PipelineReg #(.size(104)) m_MEM_WB (
    .clk(clk),
    .rst(start),
    .data_i({
        // controls
        EX_MEM[118:117], // memtoReg 103:102
        EX_MEM[116],     // regWrite 101
        // pipe reg
        pc_add4_recalc,  // 32   100:69
        EX_MEM[78:47],   // ALUOut 32   68:37
        readData,        // 32   36:5
        EX_MEM[11:7]     // rsW  4:0
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
