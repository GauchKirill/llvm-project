#include "MegaCore.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/raw_ostream.h"

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeMegaCoreTargetMC() {

    MEGACORE_DUMP_MAGENTA;
    
}