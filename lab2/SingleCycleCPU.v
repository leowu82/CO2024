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
wire [31:0] pc_mult0;
Adder m_Adder_1(
    .a(pc_curr),
    .b(4),
    .sum(pc_mult0)
);

wire [31:0] inst;
InstructionMemory m_InstMem(
    .readAddr(pc_curr),
    .inst(inst)
);

wire branch, memRead, memtoReg, memWrite, ALUSrc, regWrite;
wire [1:0] ALUOp;
Control m_Control(
    .opcode(inst[6:0]),
    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite)
);

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

wire [31:0] writeDataa, RD1, RD2;
Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(inst[19:15]),
    .readReg2(inst[24:20]),
    .writeReg(inst[11: 7]),
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
    .inst(inst),
    .imm(imm)
);

wire [31:0] sl1;
ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(sl1)
);

wire [31:0] pc_mult1;
Adder m_Adder_2(
    .a(pc_curr),
    .b(sl1),
    .sum(pc_mult1)
);

wire zero;
Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(branch && zero),
    .s0(pc_mult0),
    .s1(pc_mult1),
    .out(pc_next)
);

wire [31:0] ALU_B;
Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(RD2),
    .s1(imm),
    .out(ALU_B)
);

wire [3:0] ALUCtl;
ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(inst[30]),
    .funct3(inst[14:12]),
    .ALUCtl(ALUCtl)
);

wire [31:0] ALUOut;
ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(RD1),
    .B(ALU_B),
    .ALUOut(ALUOut),
    .zero(zero)
);

wire [31:0] readData;
DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(RD2),
    .readData(readData)
);

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(readData),
    .out(writeDataa)
);

endmodule
