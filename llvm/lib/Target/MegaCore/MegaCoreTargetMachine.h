#ifndef LLVM_LIB_TARGET_MEGACORE_MEGACORETARGETMACHINE_H
#define LLVM_LIB_TARGET_MEGACORE_MEGACORETARGETMACHINE_H

#include "MegaCoreSubtarget.h"
#include "llvm/CodeGen/CodeGenTargetMachineImpl.h"
#include <optional>

namespace llvm {

class MegaCoreTargetMachine : public CodeGenTargetMachineImpl {
  std::unique_ptr<TargetLoweringObjectFile> TLOF;
  MegaCoreSubtarget Subtarget;

public:
  MegaCoreTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                        StringRef FS, const TargetOptions &Options,
                        std::optional<Reloc::Model> RM,
                        std::optional<CodeModel::Model> CM,
                        CodeGenOptLevel OL, bool JIT);

  const MegaCoreSubtarget *getSubtargetImpl(const Function &) const override {
    MEGACORE_DUMP_CYAN
    return &Subtarget;
  }
  
  // Pass Pipeline Configuration
  TargetPassConfig *createPassConfig(PassManagerBase &PM) override;
  TargetLoweringObjectFile *getObjFileLowering() const override;
};

} // end namespace llvm

#endif