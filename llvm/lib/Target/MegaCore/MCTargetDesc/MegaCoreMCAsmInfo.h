#ifndef LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREMCASMINFO_H
#define LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREMCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {

class Triple;

class MegaCoreELFMCAsmInfo : public MCAsmInfoELF {
public:
  explicit MegaCoreELFMCAsmInfo(const Triple &TheTriple);
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREMCASMINFO_H