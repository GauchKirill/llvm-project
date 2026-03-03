#include "TargetInfo/MegaCoreTargetInfo.h"
#include "MegaCore.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

Target &llvm::getTheMegaCoreTarget() {
  MEGACORE_DUMP_YELLOW;
  static Target TheMegaCoreTarget;
  return TheMegaCoreTarget;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeMegaCoreTargetInfo() {
  MEGACORE_DUMP_YELLOW;
  RegisterTarget<Triple::megacore> X(getTheMegaCoreTarget(), "megacore",
                                      "My custom target for LLVM course", "MEGACORE");
}