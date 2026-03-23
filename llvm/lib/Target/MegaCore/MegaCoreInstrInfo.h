#ifndef LLVM_LIB_TARGET_MEGACORE_MEGACOREINSTRINFO_H
#define LLVM_LIB_TARGET_MEGACORE_MEGACOREINSTRINFO_H

#include "MegaCoreRegisterInfo.h"
#include "MCTargetDesc/MegaCoreInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

#define GET_INSTRINFO_HEADER
#include "MegaCoreGenInstrInfo.inc"

namespace llvm {

class MegaCoreSubtarget;

class MegaCoreInstrInfo : public MegaCoreGenInstrInfo {
public:
  MegaCoreInstrInfo();

};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_MEGACORE_MEGACOREINSTRINFO_H