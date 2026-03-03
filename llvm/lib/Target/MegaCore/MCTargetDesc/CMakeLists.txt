add_llvm_component_library(LLVMMegaCoreDesc
  MegaCoreMCTargetDesc.cpp

  LINK_COMPONENTS
  MC
  Support
  MegaCoreInfo

  ADD_TO_COMPONENT
  MegaCore
)