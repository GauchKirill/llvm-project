#include "MegaCore.h"
#include "clang/Basic/Builtins.h"
#include "clang/Basic/MacroBuilder.h"

using namespace clang;
using namespace clang::targets;

void MegaCoreTargetInfo::getTargetDefines(const LangOptions &Opts,
                                           MacroBuilder &Builder) const {
    Builder.defineMacro("__megacore__");
}

ArrayRef<Builtin::Info> MegaCoreTargetInfo::getTargetBuiltins() const {
    return std::nullopt;
}