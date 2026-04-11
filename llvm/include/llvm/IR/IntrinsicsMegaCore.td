//===----------------------------------------------------------------------===//
// MegaCore Intrinsics
//===----------------------------------------------------------------------===//

let TargetPrefix = "megacore" in {  // Все интринсики начинаются с "llvm.megacore."

    def int_megacore_putpixel : 
        Intrinsic<[], [llvm_i32_ty, llvm_i32_ty, llvm_i32_ty], 
                  [IntrNoMem, IntrHasSideEffects]>;

    def int_megacore_flush : 
        Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;

} // TargetPrefix = "megacore"