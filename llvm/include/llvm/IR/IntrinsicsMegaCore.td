//===----------------------------------------------------------------------===//
// MegaCore Intrinsics
//===----------------------------------------------------------------------===//

let TargetPrefix = "megacore" in {
    def int_megacore_putpixel : ClangBuiltin<"simPutPixel">,
        Intrinsic<[], [llvm_i32_ty, llvm_i32_ty, llvm_i32_ty], 
                  [IntrNoMem, IntrHasSideEffects]>;
    def int_megacore_flush : ClangBuiltin<"simFlush">,
        Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;
}