add_llvm_component_group(MegaCore)

set(LLVM_TARGET_DEFINITIONS MegaCore.td)

tablegen(LLVM MegaCoreGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM MegaCoreGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM MegaCoreGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM MegaCoreGenMCPseudoLowering.inc -gen-pseudo-lowering)
tablegen(LLVM MegaCoreGenDAGISel.inc -gen-dag-isel)

add_public_tablegen_target(MegaCoreCommonTableGen)

add_llvm_target(MegaCoreCodeGen
  MegaCoreTargetMachine.cpp
  MegaCoreRegisterInfo.cpp
  MegaCoreInstrInfo.cpp
  MegaCoreSubtarget.cpp
  MegaCoreAsmPrinter.cpp
  MegaCoreISelDagToDag.cpp
  MegaCoreISelLowering.cpp

  LINK_COMPONENTS
  CodeGen
  Core
  Support
  Target
  MegaCoreInfo
  AsmPrinter
  SelectionDAG

  ADD_TO_COMPONENT
  MegaCore
)

add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)