// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See VSingleCycleCPU.h for the primary calling header

#ifndef VERILATED_VSINGLECYCLECPU___024ROOT_H_
#define VERILATED_VSINGLECYCLECPU___024ROOT_H_  // guard

#include "verilated.h"

class VSingleCycleCPU__Syms;

class VSingleCycleCPU___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(start,0,0);
    CData/*0:0*/ SingleCycleCPU__DOT__memRead;
    CData/*0:0*/ SingleCycleCPU__DOT____Vcellinp__m_ALUCtrl__funct7;
    CData/*0:0*/ SingleCycleCPU__DOT__branch;
    CData/*0:0*/ SingleCycleCPU__DOT__memtoReg;
    CData/*0:0*/ SingleCycleCPU__DOT__memWrite;
    CData/*0:0*/ SingleCycleCPU__DOT__ALUSrc;
    CData/*0:0*/ SingleCycleCPU__DOT__regWrite;
    CData/*1:0*/ SingleCycleCPU__DOT__ALUOp;
    CData/*6:0*/ SingleCycleCPU__DOT____Vcellinp__m_Control__opcode;
    CData/*4:0*/ SingleCycleCPU__DOT____Vcellinp__m_Register__writeReg;
    CData/*3:0*/ SingleCycleCPU__DOT__ALUCtl;
    CData/*2:0*/ SingleCycleCPU__DOT____Vcellinp__m_ALUCtrl__funct3;
    CData/*7:0*/ __VdfgTmp_hd796c470__0;
    CData/*7:0*/ __VdfgTmp_hd5bcde41__0;
    CData/*7:0*/ __VdfgTmp_hd7ec2e3b__0;
    CData/*6:0*/ __Vdlyvdim0__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v0;
    CData/*7:0*/ __Vdlyvval__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v0;
    CData/*0:0*/ __Vdlyvset__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v0;
    CData/*6:0*/ __Vdlyvdim0__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v1;
    CData/*7:0*/ __Vdlyvval__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v1;
    CData/*6:0*/ __Vdlyvdim0__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v2;
    CData/*7:0*/ __Vdlyvval__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v2;
    CData/*6:0*/ __Vdlyvdim0__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v3;
    CData/*7:0*/ __Vdlyvval__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v3;
    CData/*0:0*/ __Vdlyvset__SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory__v4;
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __Vtrigrprev__TOP__start;
    CData/*1:0*/ __Vtrigrprev__TOP__SingleCycleCPU__DOT__ALUOp;
    CData/*2:0*/ __Vtrigrprev__TOP__SingleCycleCPU__DOT____Vcellinp__m_ALUCtrl__funct3;
    CData/*0:0*/ __Vtrigrprev__TOP__SingleCycleCPU__DOT____Vcellinp__m_ALUCtrl__funct7;
    CData/*3:0*/ __Vtrigrprev__TOP__SingleCycleCPU__DOT__ALUCtl;
    CData/*0:0*/ __Vtrigrprev__TOP__SingleCycleCPU__DOT__memRead;
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    SData/*15:0*/ __VdfgTmp_hadda32df__0;
    IData/*31:0*/ SingleCycleCPU__DOT__pc_curr;
    IData/*31:0*/ SingleCycleCPU__DOT__pc_next;
    IData/*31:0*/ SingleCycleCPU__DOT__inst;
    IData/*31:0*/ SingleCycleCPU__DOT__writeData;
    IData/*31:0*/ SingleCycleCPU__DOT__readData1;
    IData/*31:0*/ SingleCycleCPU__DOT__readData2;
    IData/*31:0*/ SingleCycleCPU__DOT__imm;
    IData/*31:0*/ SingleCycleCPU__DOT__ALU_B;
    IData/*31:0*/ SingleCycleCPU__DOT__ALUOut;
    IData/*31:0*/ SingleCycleCPU__DOT__readData;
    IData/*31:0*/ __VdfgTmp_h2696b87a__0;
    IData/*23:0*/ __VdfgTmp_hd4ca694a__0;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __Vtrigrprev__TOP__SingleCycleCPU__DOT__inst;
    IData/*31:0*/ __Vtrigrprev__TOP__SingleCycleCPU__DOT__ALU_B;
    IData/*31:0*/ __Vtrigrprev__TOP__SingleCycleCPU__DOT__readData1;
    IData/*31:0*/ __Vtrigrprev__TOP__SingleCycleCPU__DOT__ALUOut;
    IData/*31:0*/ __VactIterCount;
    VL_OUT(r[32],31,0);
    VlUnpacked<CData/*7:0*/, 128> SingleCycleCPU__DOT__m_InstMem__DOT__insts;
    VlUnpacked<IData/*31:0*/, 32> SingleCycleCPU__DOT__m_Register__DOT__regs;
    VlUnpacked<CData/*7:0*/, 128> SingleCycleCPU__DOT__m_DataMemory__DOT__data_memory;
    VlUnpacked<CData/*0:0*/, 5> __Vm_traceActivity;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<6> __VactTriggered;
    VlTriggerVec<6> __VnbaTriggered;

    // INTERNAL VARIABLES
    VSingleCycleCPU__Syms* const vlSymsp;

    // CONSTRUCTORS
    VSingleCycleCPU___024root(VSingleCycleCPU__Syms* symsp, const char* v__name);
    ~VSingleCycleCPU___024root();
    VL_UNCOPYABLE(VSingleCycleCPU___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
