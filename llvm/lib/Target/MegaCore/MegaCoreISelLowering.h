#ifndef LLVM_LIB_TARGET_MEGACORE_MEGACOREISELLOWERING_H
#define LLVM_LIB_TARGET_MEGACORE_MEGACOREISELLOWERING_H

#include "MegaCore.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/TargetLowering.h"

namespace llvm {

class MegaCoreSubtarget;
class MegaCoreTargetMachine;

namespace MegaCoreISD {

enum NodeType : unsigned {
  // Start the numbering where the builtin ops and target ops leave off.
  FIRST_NUMBER = ISD::BUILTIN_OP_END,
  RET,
  CALL,
  BR_CC,
};

} // namespace MegaCoreISD

} // end namespace llvm

#endif // LLVM_LIB_TARGET_MEGACORE_MEGACOREISELLOWERING_H