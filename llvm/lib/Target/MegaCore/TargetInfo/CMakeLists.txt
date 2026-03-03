add_llvm_component_library(LLVMMegaCoreInfo
  MegaCoreTargetInfo.cpp

  LINK_COMPONENTS
  Support

  ADD_TO_COMPONENT
  MegaCore
)