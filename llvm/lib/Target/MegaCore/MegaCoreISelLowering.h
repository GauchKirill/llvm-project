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

class MegaCoreTargetLowering : public TargetLowering {
public:
  explicit MegaCoreTargetLowering(const TargetMachine &TM, const MegaCoreSubtarget &STI);

  /// This method returns the name of a target specific DAG node.
  const char *getTargetNodeName(unsigned Opcode) const override;

  MegaCoreSubtarget const &getSubtarget() const { return STI; }

private:
  const MegaCoreSubtarget &STI;
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_MEGACORE_MEGACOREISELLOWERING_H