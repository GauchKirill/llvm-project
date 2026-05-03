//===----------------------------------------------------------------------===//
// MegaCore profiles and nodes
//===----------------------------------------------------------------------===//

def megacore_ret      : SDNode<"MegaCoreISD::RET", SDTNone,
                            [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

//===----------------------------------------------------------------------===//
// Instruction format superclass
//===----------------------------------------------------------------------===//

include "MegaCoreInstrFormats.td"

//===----------------------------------------------------------------------===//
// MegaCore Operand, Complex Patterns and Transformations Definitions.
//===----------------------------------------------------------------------===//

class SImmAsmOperand<int width> : AsmOperandClass {
  let Name = "SImm" # width;
  let RenderMethod = "addImmOperands";
  let DiagnosticType = !strconcat("Invalid", Name);
}

def simm16 : Operand<i32>, ImmLeaf<i32, [{return isInt<16>(Imm);}]> {
  let ParserMatchClass = SImmAsmOperand<16>;
  let EncoderMethod = "getSImm16OpValue";
  let DecoderMethod = "decodeSImmOperand<16>";
  let MCOperandPredicate = [{
    int64_t Imm;
    if (MCOp.evaluateAsConstantImm(Imm))
      return isInt<16>(Imm);
    return MCOp.isBareSymbolRef();
  }];
  let OperandType = "OPERAND_MEGACOREM16";
  let OperandNamespace = "MegaCoreOp";
}

//===----------------------------------------------------------------------===//
// MegaCore Instructions
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isCall = 1, isBranch = 1, isTerminator = 1, r2 = 0, r3_imm = 0 in
def BR : MegaCoreInst<0xBB, (outs), (ins GPR:$r1), "BR $r1",
                 [(brind GPR:$r1)]>;

let isBarrier = 1, isReturn = 1, isTerminator = 1 in
def PseudoRET : MegaCorePseudoInst<(outs), (ins), "# PseudoRET",
                [(megacore_ret)]>,
                PseudoInstExpansion<(BR R0)>;

// movli
let isAsCheapAsAMove = 1, isCodeGenOnly = 1, isReMaterializable = 1, r2 = 0 in
def MOVLI : MegaCoreInst<0xAA, (outs GPR:$r1), (ins simm16:$r3_imm),
                    "MOVli $r1 $r3_imm",
                    [(set GPR:$r1, simm16:$r3_imm)]>;

// simInit
let r1 = 0, r2 = 0, r3_imm = 0 in
def SIMINIT : MegaCoreInst<0xFC, (outs), (ins), "SIMINIT", [(int_megacore_sim_init)]>;

// simExit
let r1 = 0, r2 = 0, r3_imm = 0 in
def SIMEXIT : MegaCoreInst<0xFD, (outs), (ins), "SIMEXIT", [(int_megacore_sim_exit)]>;

// sim - принимает 7 аргументов: 6 указателей (в регистрах r1..r6) и количество (r7)
// Предполагается, что в ISA MegaCore есть достаточно регистров.
def SIM : MegaCoreInst<0xFE, (outs), (ins GPR:$r1, GPR:$r2, GPR:$r3, GPR:$r4, GPR:$r5, GPR:$r6, GPR:$r7),
                       "SIM $r1 $r2 $r3 $r4 $r5 $r6 $r7",
                       [(set GPR:$dst, (int_megacore_sim GPR:$r1, GPR:$r2, GPR:$r3, GPR:$r4, GPR:$r5, GPR:$r6, GPR:$r7))]>;


//===----------------------------------------------------------------------===//
// Арифметические инструкции
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  // RR-форма
  multiclass ArithRR<bits<8> op, string OpcStr, SDNode OpNode> {
    def _RR : MegaCoreInst<op, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                           !strconcat(OpcStr, " $rd, $rs1, $rs2"),
                           [(set GPR:$rd, (OpNode GPR:$rs1, GPR:$rs2))]>;
  }
  // RI-форма (с 16-битным непосредственным значением)
  multiclass ArithRI<bits<8> op, string OpcStr, SDNode OpNode> {
    def _RI : MegaCoreInst<op, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm),
                           !strconcat(OpcStr, "i $rd, $rs1, $imm"),
                           [(set GPR:$rd, (OpNode GPR:$rs1, simm16:$imm))]>;
  }
}

// Коды операций (выберите свободные, например 0x30-0x3F)
defm ADD : ArithRR<0x30, "add", add>;
defm ADD : ArithRI<0x31, "add", add>;
defm SUB : ArithRR<0x32, "sub", sub>;
defm SUB : ArithRI<0x33, "sub", sub>;
defm MUL : ArithRR<0x34, "mul", mul>;
defm MUL : ArithRI<0x35, "mul", mul>;
defm DIV : ArithRR<0x36, "div", sdiv>;          // для srem
defm AND : ArithRR<0x37, "and", and>;
defm AND : ArithRI<0x38, "and", and>;
defm OR  : ArithRR<0x39, "or",  or>;
defm OR  : ArithRI<0x3A, "or",  or>;
defm XOR : ArithRR<0x3B, "xor", xor>;
defm XOR : ArithRI<0x3C, "xor", xor>;

//===----------------------------------------------------------------------===//
// Инструкции загрузки и сохранения
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in
def LDW : MegaCoreInst<0xE0, (outs GPR:$rd), (ins GPR:$addr),
                       "ldw $rd, ($addr)",
                       [(set GPR:$rd, (load GPR:$addr))]>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in
def STW : MegaCoreInst<0xE1, (outs), (ins GPR:$addr, GPR:$rs),
                       "stw $addr, $rs",
                       [(store GPR:$rs, GPR:$addr)]>;

// movhi - загрузка старших 16 бит (будет сдвинута влево на 16 при использовании с OR)
let isAsCheapAsAMove = 1, isCodeGenOnly = 1, isReMaterializable = 1, r2 = 0 in
def MOVHI : MegaCoreInst<0xAB, (outs GPR:$r1), (ins simm16:$r3_imm),
                         "MOVhi $r1 $r3_imm", []>;

//===----------------------------------------------------------------------===//
// Операнд для PC-относительных переходов
//===----------------------------------------------------------------------===//

def btarget16 : Operand<OtherVT> {
  let ParserMatchClass = SImmAsmOperand<16>;
  let PrintMethod = "printBranchOperand";
  let EncoderMethod = "getBranchTarget16OpValue";
  let DecoderMethod = "decodeSImmOperand<16>";
  let MCOperandPredicate = [{
    int64_t Imm;
    if (MCOp.evaluateAsConstantImm(Imm))
      return isInt<16>(Imm);
    return MCOp.isBareSymbolRef();
  }];
  let OperandType = "OPERAND_PCREL";
}

//===----------------------------------------------------------------------===//
// Инструкции ветвления
//===----------------------------------------------------------------------===//

let isBranch = 1, isTerminator = 1, hasSideEffects = 0, r1 = 0, r2 = 0 in
def B : MegaCoreInst<0xB0, (outs), (ins btarget16:$target),
                     "b $target", [(br bb:$target)]>;

let isBranch = 1, isTerminator = 1, hasSideEffects = 0, r2 = 0 in
def BCOND : MegaCoreInst<0xBC, (outs), (ins GPR:$cond, btarget16:$target),
                         "b$cond $target", []>;

// Паттерн для brcond
def : Pat<(brcond (i32 GPR:$cond), bb:$target), (BCOND GPR:$cond, btarget16:$target)>;

//===----------------------------------------------------------------------===//
// Векторные инструкции
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in
def VLD : MegaCoreInst<0xF0, (outs VecReg:$rd), (ins GPR:$addr),
                       "vld $rd, ($addr)",
                       [(set VecReg:$rd, (load (v4i32 GPR:$addr)))]>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in
def VST : MegaCoreInst<0xF1, (outs), (ins GPR:$addr, VecReg:$rs),
                       "vst $addr, $rs",
                       [(store VecReg:$rs, GPR:$addr)]>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def VADD : MegaCoreInst<0xF2, (outs VecReg:$rd), (ins VecReg:$rs1, VecReg:$rs2),
                        "vadd $rd, $rs1, $rs2",
                        [(set VecReg:$rd, (add VecReg:$rs1, VecReg:$rs2))]>;