#include "MegaCoreSubtarget.h"
#include "MegaCore.h"
#include "llvm/Target/TargetMachine.h"

using namespace llvm;

#define DEBUG_TYPE "megacore-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "MegaCoreGenSubtargetInfo.inc"

MegaCoreSubtarget::MegaCoreSubtarget(const StringRef &CPU, const StringRef &TuneCPU,
                           const StringRef &FS, const TargetMachine &TM)
    : MegaCoreGenSubtargetInfo(TM.getTargetTriple(), CPU, TuneCPU, FS) {
  MEGACORE_DUMP_CYAN
}