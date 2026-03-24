#include "MegaCoreISelLowering.h"
#include "MegaCore.h"
#include "MegaCoreRegisterInfo.h"
#include "MegaCoreSubtarget.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFunction.h"

#define DEBUG_TYPE "MegaCore-lower"

using namespace llvm;

MegaCoreTargetLowering::MegaCoreTargetLowering(const TargetMachine &TM,
                                     const MegaCoreSubtarget &STI)
    : TargetLowering(TM), STI(STI) {
  MEGACORE_DUMP_RED
  addRegisterClass(MVT::i32, &MegaCore::GPRRegClass);
}

const char *MegaCoreTargetLowering::getTargetNodeName(unsigned Opcode) const {
  MEGACORE_DUMP_RED
  switch (Opcode) {
  case MegaCoreISD::CALL:
    return "MegaCoreISD::CALL";
  case MegaCoreISD::RET:
    return "MegaCoreISD::RET";
  }
  return nullptr;
}