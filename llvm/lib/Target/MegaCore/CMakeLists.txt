add_llvm_component_group(MegaCore)

set(LLVM_TARGET_DEFINITIONS MegaCore.td)

tablegen(LLVM MegaCoreGenRegisterInfo.inc -gen-register-info)

add_public_tablegen_target(MegaCoreCommonTableGen)

add_llvm_target(MegaCoreCodeGen
  MegaCoreTargetMachine.cpp
  MegaCoreRegisterInfo.cpp

  LINK_COMPONENTS
  CodeGen
  Core
  Support
  Target

  ADD_TO_COMPONENT
  MegaCore
)

add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)