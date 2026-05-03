//===----------------------------------------------------------------------===//
// MegaCore Intrinsics
//===----------------------------------------------------------------------===//

let TargetPrefix = "megacore" in {

  class MegaCoreIntrinsic<list<LLVMType> results, list<LLVMType> params,
                          list<IntrinsicProperty> properties>
      : Intrinsic<results, params, properties>;

  def int_megacore_sim_init : MegaCoreIntrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;
  
  def int_megacore_sim : MegaCoreIntrinsic<[llvm_i32_ty],
                         [llvm_ptr_ty, llvm_ptr_ty, llvm_ptr_ty,
                          llvm_ptr_ty, llvm_ptr_ty, llvm_ptr_ty, llvm_i32_ty],
                         [IntrNoMem, IntrHasSideEffects]>;
  
  def int_megacore_sim_exit : MegaCoreIntrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;

} // TargetPrefix = "megacore"