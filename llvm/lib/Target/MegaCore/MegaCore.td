include "llvm/Target/Target.td"
include "MegaCoreRegisterInfo.td"
include "MegaCoreInstrInfo.td"

def MegaCoreInstrInfo : InstrInfo;
def MegaCore : Target {
  let InstructionSet = MegaCoreInstrInfo;
}