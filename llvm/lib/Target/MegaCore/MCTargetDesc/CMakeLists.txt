add_llvm_component_library(LLVMMegaCoreDesc
  MegaCoreMCTargetDesc.cpp
  MegaCoreMCAsmInfo.cpp
  MegaCoreInstPrinter.cpp
  MegaCoreMCCodeEmitter.cpp
  MegaCoreAsmBackend.cpp
  MegaCoreELFObjectWriter.cpp
  
  LINK_COMPONENTS
  MC
  Support
  MegaCoreInfo

  ADD_TO_COMPONENT
  MegaCore
)