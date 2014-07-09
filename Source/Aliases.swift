
#if ECHOES || NOUGAT
typealias Int = IntPtr
typealias UInt = UIntPtr
#elseif COOPER
typealias Int = Int32
typealias UInt = UInt32
#endif
typealias Int8 = SByte

typealias UInt8 = Byte

typealias Bool = Boolean
let false: Bool = 0 as Bool
let true: Bool = 1 as Bool

typealias UnicodeScalar = Char // for now

typealias Float = Single
typealias Float32 = Single
typealias Float64 = Double

typealias Any = protocol<> //Dynamic;