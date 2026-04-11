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