include "llvm/Target/Target.td"
include "MegaCoreRegisterInfo.td"
include "MegaCoreInstrInfo.td"
include "MegaCoreCallingConv.td"

class Proc<string Name, list<SubtargetFeature> Features>
 : Processor<Name, NoItineraries, Features>;

def : Proc<"generic", []>;

def MegaCoreInstrInfo : InstrInfo;
def MegaCore : Target {
  let InstructionSet = MegaCoreInstrInfo;
}