add_llvm_component_group(MegaCore)

add_llvm_target(MegaCoreCodeGen
  MegaCoreTargetMachine.cpp

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