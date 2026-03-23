#include "MegaCore.h"
#include "TargetInfo/MegaCoreTargetInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

#define GET_REGINFO_MC_DESC
#include "MegaCoreGenRegisterInfo.inc"

static MCRegisterInfo *createMegaCoreMCRegisterInfo(const Triple &TT) {
  MEGACORE_DUMP_MAGENTA
  MCRegisterInfo *X = new MCRegisterInfo();
  InitMegaCoreMCRegisterInfo(X, MegaCore::R0);
  return X;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeMegaCoreTargetMC() {
  MEGACORE_DUMP_MAGENTA
  Target &TheMegaCoreTarget = getTheMegaCoreTarget();
  // Register the MC register info.
  TargetRegistry::RegisterMCRegInfo(TheMegaCoreTarget, createMegaCoreMCRegisterInfo);
}