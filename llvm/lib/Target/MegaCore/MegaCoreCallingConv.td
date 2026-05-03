//===----------------------------------------------------------------------===//
// MegaCore Return Value Calling Convention
//===----------------------------------------------------------------------===//

def RetCC_MegaCore : CallingConv<[
  // Возвращаемое значение в R0
  CCIfType<[i32], CCAssignToReg<[R0]>>
]>;

//===----------------------------------------------------------------------===//
// MegaCore Argument Calling Conventions
//===----------------------------------------------------------------------===//

def CC_MegaCore : CallingConv<[
  // Продвинуть i8/i16 до i32
  CCIfType<[i8, i16], CCPromoteToType<i32>>,

  // Первые 6 аргументов передаются в регистрах R2-R7
  CCIfType<[i32], CCAssignToReg<[R2, R3, R4, R5, R6, R7]>>,

  // Остальные аргументы передаются на стеке
  CCIfType<[i32], CCAssignToStack<4, 4>>
]>;

// Callee-saved registers
def CSR_MegaCore : CalleeSavedRegs<(add R8, R9, R10, R11, R12, R13, R14, R15)>;