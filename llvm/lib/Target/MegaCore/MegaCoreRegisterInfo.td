// MegaCore Register file declaration
class MegaCoreReg<bits<16> Enc, string n> : Register<n>{
    let HWEncoding = Enc;
    let Namespace = "MegaCore";
}

// Registers
foreach I = 0-15 in {
    def R#I : MegaCoreReg<I, "r"#I>;
}

// Classes
def GPR : RegisterClass<"MegaCore", [i32], 32, (add
  R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15)>;

// //===----------------------------------------------------------------------===//
// // Векторные регистры (128-битные для 4 x i32)
// //===----------------------------------------------------------------------===//

// foreach I = 0-15 in {
//   def V#I : MegaCoreReg<I, "v"#I>;
// }

// def VecReg : RegisterClass<"MegaCore", [v4i32], 128, (add
//   V0, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15)>;