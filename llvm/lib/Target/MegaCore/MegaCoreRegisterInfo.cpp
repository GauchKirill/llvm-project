#include "MegaCoreRegisterInfo.h"
#include "MegaCore.h"
#include "MegaCoreFrameLowering.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

using namespace llvm;

#define GET_REGINFO_TARGET_DESC
#include "MegaCoreGenRegisterInfo.inc"

MegaCoreRegisterInfo::MegaCoreRegisterInfo() : MegaCoreGenRegisterInfo(MegaCore::R0) {
  MEGACORE_DUMP_GREEN
}