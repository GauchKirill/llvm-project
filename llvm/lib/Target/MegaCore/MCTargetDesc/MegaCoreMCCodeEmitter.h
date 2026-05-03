#ifndef LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREMCCODECEMITTER_H
#define LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREMCCODECEMITTER_H

#include "llvm/MC/MCCodeEmitter.h"

namespace llvm {

class MegaCoreMCCodeEmitter : public MCCodeEmitter {
  MCContext &Ctx;

public:
  MegaCoreMCCodeEmitter(const MCInstrInfo &, MCContext &ctx);
  ~MegaCoreMCCodeEmitter() override = default;

  void encodeInstruction(const MCInst &MI, SmallVectorImpl<char> &CB,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const override;

  unsigned getMachineOpValue(const MCInst &MI, const MCOperand &MO,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;
  unsigned getSImm16OpValue(const MCInst &MI, unsigned OpNo,
                            SmallVectorImpl<MCFixup> &Fixups,
                            const MCSubtargetInfo &STI) const;
  unsigned getBranchTarget16OpValue(const MCInst &MI, unsigned OpNo,
                                    SmallVectorImpl<MCFixup> &Fixups,
                                    const MCSubtargetInfo &STI) const;
};

} // end namespace llvm

#endif