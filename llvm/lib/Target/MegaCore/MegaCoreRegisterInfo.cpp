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
const MCPhysReg *
MegaCoreRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  MEGACORE_DUMP_GREEN
  return CSR_MegaCore_SaveList;
}

BitVector MegaCoreRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  MEGACORE_DUMP_GREEN
  MegaCoreFrameLowering const *TFI = getFrameLowering(MF);

  BitVector Reserved(getNumRegs());
  Reserved.set(MegaCore::R1);

  if (TFI->hasFP(MF)) {
    Reserved.set(MegaCore::R2);
  }
  return Reserved;
}

bool MegaCoreRegisterInfo::requiresRegisterScavenging(
    const MachineFunction &MF) const {
  return false;
}

bool MegaCoreRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                          int SPAdj, unsigned FIOperandNum,
                                          RegScavenger *RS) const {
  MEGACORE_DUMP_GREEN
  assert(SPAdj == 0 && "Unexpected non-zero SPAdj value");

  MachineInstr &MI = *II;
  MachineFunction &MF = *MI.getParent()->getParent();
  DebugLoc DL = MI.getDebugLoc();

  int FrameIndex = MI.getOperand(FIOperandNum).getIndex();
  Register FrameReg;
  int Offset = getFrameLowering(MF)
                   ->getFrameIndexReference(MF, FrameIndex, FrameReg)
                   .getFixed();
  Offset += MI.getOperand(FIOperandNum + 1).getImm();

  if (!isInt<16>(Offset)) {
    llvm_unreachable("");
  }

  MI.getOperand(FIOperandNum).ChangeToRegister(FrameReg, false, false, false);
  MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset);
  return false;
}

Register MegaCoreRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  MEGACORE_DUMP_GREEN
  const TargetFrameLowering *TFI = getFrameLowering(MF);
  return TFI->hasFP(MF) ? MegaCore::R2 : MegaCore::R1;
}

const uint32_t *
MegaCoreRegisterInfo::getCallPreservedMask(const MachineFunction &MF,
                                      CallingConv::ID CC) const {
  MEGACORE_DUMP_GREEN
  return CSR_MegaCore_RegMask;
}