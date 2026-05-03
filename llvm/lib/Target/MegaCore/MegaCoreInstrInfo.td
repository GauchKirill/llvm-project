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

// MOVLI - загрузка младших 16 бит
let isAsCheapAsAMove = 1, isCodeGenOnly = 1, isReMaterializable = 1 in
def MOVLI : MegaCoreInst<0xAA, (outs GPR:$rd), (ins simm16:$imm),
                         "movli $rd, $imm",
                         [(set GPR:$rd, simm16:$imm)]>;

// MOVHI - загрузка старших 16 бит
let isAsCheapAsAMove = 1, isCodeGenOnly = 1, isReMaterializable = 1 in
def MOVHI : MegaCoreInst<0xAB, (outs GPR:$rd), (ins simm16:$imm),
                         "movhi $rd, $imm", []>;

// simInit
let r1 = 0, r2 = 0, r3_imm = 0 in
def SIMINIT : MegaCoreInst<0xFC, (outs), (ins), "SIMINIT", [(int_megacore_sim_init)]>;

// simExit
let r1 = 0, r2 = 0, r3_imm = 0 in
def SIMEXIT : MegaCoreInst<0xFD, (outs), (ins), "SIMEXIT", [(int_megacore_sim_exit)]>;

// sim - псевдо-инструкция (без прямой кодировки)
let isPseudo = 1, isCodeGenOnly = 1, hasSideEffects = 1 in
def SIM : MegaCorePseudoInst<(outs GPR:$dst), (ins GPR:$arg1, GPR:$arg2, GPR:$arg3,
                                              GPR:$arg4, GPR:$arg5, GPR:$arg6, GPR:$arg7),
                             "SIM $arg1, $arg2, $arg3, $arg4, $arg5, $arg6, $arg7",
                             [(set GPR:$dst, (int_megacore_sim GPR:$arg1, GPR:$arg2, GPR:$arg3,
                                                               GPR:$arg4, GPR:$arg5, GPR:$arg6,
                                                               GPR:$arg7))]>;

//===----------------------------------------------------------------------===//
// Арифметические инструкции - RR форма (регистр-регистр)
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  def ADD_RR : MegaCoreInst<0x30, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                            "add $rd, $rs1, $rs2",
                            [(set GPR:$rd, (add GPR:$rs1, GPR:$rs2))]>;
  
  def SUB_RR : MegaCoreInst<0x31, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                            "sub $rd, $rs1, $rs2",
                            [(set GPR:$rd, (sub GPR:$rs1, GPR:$rs2))]>;
  
  def MUL_RR : MegaCoreInst<0x32, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                            "mul $rd, $rs1, $rs2",
                            [(set GPR:$rd, (mul GPR:$rs1, GPR:$rs2))]>;
  
  def DIV_RR : MegaCoreInst<0x33, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                            "div $rd, $rs1, $rs2",
                            [(set GPR:$rd, (sdiv GPR:$rs1, GPR:$rs2))]>;
  
  def AND_RR : MegaCoreInst<0x34, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                            "and $rd, $rs1, $rs2",
                            [(set GPR:$rd, (and GPR:$rs1, GPR:$rs2))]>;
  
  def OR_RR : MegaCoreInst<0x35, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                           "or $rd, $rs1, $rs2",
                           [(set GPR:$rd, (or GPR:$rs1, GPR:$rs2))]>;
  
  def XOR_RR : MegaCoreInst<0x36, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                            "xor $rd, $rs1, $rs2",
                            [(set GPR:$rd, (xor GPR:$rs1, GPR:$rs2))]>;
  
  def SRA_RR : MegaCoreInst<0x3D, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                            "sra $rd, $rs1, $rs2",
                            [(set GPR:$rd, (sra GPR:$rs1, GPR:$rs2))]>;
  
  def SRL_RR : MegaCoreInst<0x3E, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                            "srl $rd, $rs1, $rs2",
                            [(set GPR:$rd, (srl GPR:$rs1, GPR:$rs2))]>;
  
  def SHL_RR : MegaCoreInst<0x3F, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                            "shl $rd, $rs1, $rs2",
                            [(set GPR:$rd, (shl GPR:$rs1, GPR:$rs2))]>;
}

//===----------------------------------------------------------------------===//
// Арифметические инструкции - RI форма (регистр-непосредственное значение)
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  def ADDI : MegaCoreInst<0x40, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm),
                          "addi $rd, $rs1, $imm",
                          [(set GPR:$rd, (add GPR:$rs1, simm16:$imm))]>;
  
  def SUBI : MegaCoreInst<0x41, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm),
                          "subi $rd, $rs1, $imm",
                          [(set GPR:$rd, (sub GPR:$rs1, simm16:$imm))]>;
  
  def MULI : MegaCoreInst<0x42, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm),
                          "muli $rd, $rs1, $imm",
                          [(set GPR:$rd, (mul GPR:$rs1, simm16:$imm))]>;
  
  def ANDI : MegaCoreInst<0x44, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm),
                          "andi $rd, $rs1, $imm",
                          [(set GPR:$rd, (and GPR:$rs1, simm16:$imm))]>;
  
  def ORI : MegaCoreInst<0x45, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm),
                         "ori $rd, $rs1, $imm",
                         [(set GPR:$rd, (or GPR:$rs1, simm16:$imm))]>;
  
  def XORI : MegaCoreInst<0x46, (outs GPR:$rd), (ins GPR:$rs1, simm16:$imm),
                          "xori $rd, $rs1, $imm",
                          [(set GPR:$rd, (xor GPR:$rs1, simm16:$imm))]>;
}

//===----------------------------------------------------------------------===//
// Инструкции загрузки и сохранения
//===----------------------------------------------------------------------===//

// Загрузка слова
let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in
def LDW : MegaCoreInst<0xE0, (outs GPR:$rd), (ins GPR:$addr),
                       "ldw $rd, ($addr)",
                       [(set GPR:$rd, (load GPR:$addr))]>;

// Сохранение слова
let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in
def STW : MegaCoreInst<0xE1, (outs), (ins GPR:$addr, GPR:$rs),
                       "stw $addr, $rs",
                       [(store GPR:$rs, GPR:$addr)]>;

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

// Безусловный переход
let isBranch = 1, isTerminator = 1, hasSideEffects = 0 in
def B : MegaCoreInst<0xB0, (outs), (ins btarget16:$target),
                     "b $target", [(br bb:$target)]>;

// Условный переход
let isBranch = 1, isTerminator = 1, hasSideEffects = 0 in
def BCOND : MegaCoreInst<0xBC, (outs), (ins GPR:$cond, btarget16:$target),
                         "b$cond $target", []>;

// Паттерн для brcond
def : Pat<(brcond (i32 GPR:$cond), bb:$target), (BCOND GPR:$cond, btarget16:$target)>;

// //===----------------------------------------------------------------------===//
// // Векторные инструкции
// //===----------------------------------------------------------------------===//

// // Векторная загрузка
// let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in
// def VLD : MegaCoreInst<0xF0, (outs VecReg:$rd), (ins GPR:$addr),
//                        "vld $rd, ($addr)",
//                        [(set VecReg:$rd, (load (v4i32 GPR:$addr)))]>;

// // Векторное сохранение
// let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in
// def VST : MegaCoreInst<0xF1, (outs), (ins GPR:$addr, VecReg:$rs),
//                        "vst $addr, $rs",
//                        [(store VecReg:$rs, GPR:$addr)]>;

// // Векторное сложение
// let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
// def VADD : MegaCoreInst<0xF2, (outs VecReg:$rd), (ins VecReg:$rs1, VecReg:$rs2),
//                         "vadd $rd, $rs1, $rs2",
//                         [(set VecReg:$rd, (add VecReg:$rs1, VecReg:$rs2))]>;

//===----------------------------------------------------------------------===//
// Инструкции сложения с сравнением (для оптимизации циклов)
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def INC_EQi : MegaCoreInst<0x90, (outs GPR:$rd, GPR:$flag), (ins GPR:$rs, simm16:$limit),
                           "inc_eq $rd, $rs, $limit", []>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def INC_NEi : MegaCoreInst<0x91, (outs GPR:$rd, GPR:$flag), (ins GPR:$rs, simm16:$limit),
                           "inc_ne $rd, $rs, $limit", []>;