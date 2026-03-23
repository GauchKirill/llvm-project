#ifndef LLVM_LIB_TARGET_MEGACORE_MEGACOREREGISTERINFO_H
#define LLVM_LIB_TARGET_MEGACORE_MEGACOREREGISTERINFO_H

#define GET_REGINFO_HEADER
#include "MegaCoreGenRegisterInfo.inc"

namespace llvm {

struct MegaCoreRegisterInfo : public MegaCoreGenRegisterInfo {
public:
  MegaCoreRegisterInfo();
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_MEGACORE_MEGACOREREGISTERINFO_H