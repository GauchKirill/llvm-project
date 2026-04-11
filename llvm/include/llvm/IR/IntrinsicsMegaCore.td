let TargetPrefix = "megacore" in {
    def int_megacore_sim_init : ClangBuiltin<"simInit">,
        Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;
    def int_megacore_sim : ClangBuiltin<"sim">,
        Intrinsic<[llvm_i32_ty], 
                  [llvm_ptr_ty, llvm_ptr_ty, llvm_ptr_ty, 
                   llvm_ptr_ty, llvm_ptr_ty, llvm_ptr_ty, llvm_i32_ty], 
                  [IntrNoMem, IntrHasSideEffects]>;
    def int_megacore_sim_exit : ClangBuiltin<"simExit">,
        Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;
}