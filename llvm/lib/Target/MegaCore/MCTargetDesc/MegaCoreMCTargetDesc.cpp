#include "MCTargetDesc/MegaCoreInfo.h"
#include "MegaCore.h"
#include "MegaCoreInstPrinter.h"
#include "MegaCoreMCAsmInfo.h"
#include "TargetInfo/MegaCoreTargetInfo.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCDwarf.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

#define GET_REGINFO_MC_DESC
#include "MegaCoreGenRegisterInfo.inc"

#define GET_INSTRINFO_MC_DESC
#include "MegaCoreGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "MegaCoreGenSubtargetInfo.inc"


static MCRegisterInfo *createMegaCoreMCRegisterInfo(const Triple &TT) {
  MEGACORE_DUMP_MAGENTA
  MCRegisterInfo *X = new MCRegisterInfo();
  InitMegaCoreMCRegisterInfo(X, MegaCore::R0);
  return X;
}

static MCInstrInfo *createMegaCoreMCInstrInfo() {
  MEGACORE_DUMP_MAGENTA
  MCInstrInfo *X = new MCInstrInfo();
  InitMegaCoreMCInstrInfo(X);
  return X;
}

static MCSubtargetInfo *createMegaCoreMCSubtargetInfo(const Triple &TT,
                                                 StringRef CPU, StringRef FS) {
  MEGACORE_DUMP_MAGENTA
  return createMegaCoreMCSubtargetInfoImpl(TT, CPU, /*TuneCPU*/ CPU, FS);
}

static MCAsmInfo *createMegaCoreMCAsmInfo(const MCRegisterInfo &MRI,
                                     const Triple &TT,
                                     const MCTargetOptions &Options) {
  MEGACORE_DUMP_MAGENTA
  MCAsmInfo *MAI = new MegaCoreELFMCAsmInfo(TT);
  unsigned SP = MRI.getDwarfRegNum(MegaCore::R1, true);
  MCCFIInstruction Inst = MCCFIInstruction::cfiDefCfa(nullptr, SP, 0);
  MAI->addInitialFrameState(Inst);
  return MAI;
}

static MCInstPrinter *createMegaCoreMCInstPrinter(const Triple &T,
                                             unsigned SyntaxVariant,
                                             const MCAsmInfo &MAI,
                                             const MCInstrInfo &MII,
                                             const MCRegisterInfo &MRI) {
  MEGACORE_DUMP_MAGENTA
  return new MegaCoreInstPrinter(MAI, MII, MRI);
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeMegaCoreTargetMC() {
  MEGACORE_DUMP_MAGENTA
  Target &TheMegaCoreTarget = getTheMegaCoreTarget();
  RegisterMCAsmInfoFn X(TheMegaCoreTarget, createMegaCoreMCAsmInfo);
  // Register the MC register info.
  TargetRegistry::RegisterMCRegInfo(TheMegaCoreTarget, createMegaCoreMCRegisterInfo);
  // Register the MC instruction info.
  TargetRegistry::RegisterMCInstrInfo(TheMegaCoreTarget, createMegaCoreMCInstrInfo);
  // Register the MC subtarget info.
  TargetRegistry::RegisterMCSubtargetInfo(TheMegaCoreTarget,
                                          createMegaCoreMCSubtargetInfo);

  // Register the MCInstPrinter
  TargetRegistry::RegisterMCInstPrinter(TheMegaCoreTarget, createMegaCoreMCInstPrinter);
  // Register the MC Code Emitter.
  TargetRegistry::RegisterMCCodeEmitter(TheMegaCoreTarget, createMegaCoreMCCodeEmitter);
}