#ifndef LLVM_LIB_TARGET_MegaCore_MegaCore_H
#define LLVM_LIB_TARGET_MegaCore_MegaCore_H

#include "MCTargetDesc/MegaCoreMCTargetDesc.h"
#include "llvm/Support/raw_ostream.h"

#define MEGACORE_DUMP(Color)                                                   \
  {                                                                            \
    llvm::errs().changeColor(Color)                                            \
        << __func__ << "\n\t\t" << __FILE__ << ":" << __LINE__ << "\n";        \
    llvm::errs().changeColor(llvm::raw_ostream::WHITE);                        \
  }
// #define MEGACORE_DUMP(Color) {}

#define MEGACORE_DUMP_RED MEGACORE_DUMP(llvm::raw_ostream::RED)
#define MEGACORE_DUMP_GREEN MEGACORE_DUMP(llvm::raw_ostream::GREEN)
#define MEGACORE_DUMP_YELLOW MEGACORE_DUMP(llvm::raw_ostream::YELLOW)
#define MEGACORE_DUMP_BLUE MEGACORE_DUMP(llvm::raw_ostream::BLUE)
#define MEGACORE_DUMP_CYAN MEGACORE_DUMP(llvm::raw_ostream::CYAN)
#define MEGACORE_DUMP_MAGENTA MEGACORE_DUMP(llvm::raw_ostream::MAGENTA)
#define SIM_DUMP_WHITE MEGACORE_DUMP(llvm::raw_ostream::WHITE)

#endif // LLVM_LIB_TARGET_MegaCore_MegaCore_H