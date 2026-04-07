#ifndef LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREMCTARGETDESC_H
#define LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREMCTARGETDESC_H

namespace llvm {
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCAsmBackend;
class MCObjectTargetWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class MCTargetOptions;
class Target;

MCCodeEmitter *createMegaCoreMCCodeEmitter(const MCInstrInfo &MCII, MCContext &Ctx);
MCAsmBackend *createMegaCoreAsmBackend(const Target &T, const MCSubtargetInfo &STI,
                                        const MCRegisterInfo &MRI,
                                        const MCTargetOptions &Options);
} // namespace llvm

// Defines symbolic names for MegaCore registers.  This defines a mapping from
// register name to register number.
//
#define GET_REGINFO_ENUM
#include "MegaCoreGenRegisterInfo.inc"

// Defines symbolic names for the MegaCore instructions.
#define GET_INSTRINFO_ENUM
#include "MegaCoreGenInstrInfo.inc"

#endif // LLVM_LIB_TARGET_MEGACORE_MCTARGETDESC_MEGACOREMCTARGETDESC_H