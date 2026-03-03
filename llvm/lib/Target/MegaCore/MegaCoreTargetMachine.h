#ifndef LLVM_LIB_TARGET_MEGACORE_MEGACORETARGETMACHINE_H
#define LLVM_LIB_TARGET_MEGACORE_MEGACORETARGETMACHINE_H

#include "llvm/CodeGen/CodeGenTargetMachineImpl.h"
#include <optional>

namespace llvm {

class MegaCoreTargetMachine : public CodeGenTargetMachineImpl {
public:
  MegaCoreTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                        StringRef FS, const TargetOptions &Options,
                        std::optional<Reloc::Model> RM,
                        std::optional<CodeModel::Model> CM,
                        CodeGenOptLevel OL, bool JIT);
};

} // end namespace llvm

#endif