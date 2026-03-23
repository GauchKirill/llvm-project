#ifndef LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREINFO_H
#define LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREINFO_H

#include "llvm/MC/MCInstrDesc.h"

namespace llvm {

namespace MegaCoreOp {
enum OperandType : unsigned {
  OPERAND_MEGACOREM16 = MCOI::OPERAND_FIRST_TARGET,
};
} // namespace MegaCoreOp

} // end namespace llvm

#endif