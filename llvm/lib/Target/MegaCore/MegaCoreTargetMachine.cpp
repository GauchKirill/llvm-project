#include "MegaCoreTargetMachine.h"
#include "MegaCore.h"
#include "TargetInfo/MegaCoreTargetInfo.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/IR/IntrinsicsMegaCore.h"

using namespace llvm;

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeMegaCoreTarget() {
  MEGACORE_DUMP_CYAN;
  RegisterTargetMachine<MegaCoreTargetMachine> X(getTheMegaCoreTarget());
}

MegaCoreTargetMachine::MegaCoreTargetMachine(
    const Target &T, const Triple &TT, StringRef CPU, StringRef FS,
    const TargetOptions &Options, std::optional<Reloc::Model> RM,
    std::optional<CodeModel::Model> CM, CodeGenOptLevel OL, bool JIT)
      : CodeGenTargetMachineImpl(T, "e-m:e-p:32:32-i8:8:32-i16:16:32-i64:64-n32",
                               TT, CPU, FS, Options, Reloc::Static,
                               getEffectiveCodeModel(CM, CodeModel::Small), OL),
      TLOF(std::make_unique<TargetLoweringObjectFileELF>()),
      Subtarget(TT, std::string(CPU), std::string(FS), *this) {
  MEGACORE_DUMP_CYAN;

  initAsmInfo();
}


namespace {

/// MegaCore Code Generator Pass Configuration Options.
class MegaCorePassConfig : public TargetPassConfig {
public:
  MegaCorePassConfig(MegaCoreTargetMachine &TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {}

  MegaCoreTargetMachine &getMegaCoreTargetMachine() const {
    return getTM<MegaCoreTargetMachine>();
  }

  bool addInstSelector() override {
    MEGACORE_DUMP_CYAN
    addPass(createMegaCoreISelDag(getMegaCoreTargetMachine(), getOptLevel()));
    return false;
  }
};

} // end anonymous namespace

TargetPassConfig *MegaCoreTargetMachine::createPassConfig(PassManagerBase &PM) {
  MEGACORE_DUMP_CYAN
  return new MegaCorePassConfig(*this, PM);
}

TargetLoweringObjectFile *MegaCoreTargetMachine::getObjFileLowering() const {
  MEGACORE_DUMP_CYAN
  return TLOF.get();
}