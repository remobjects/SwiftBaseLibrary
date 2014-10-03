
#if ECHOES
typealias Int = IntPtr
typealias UInt = UIntPtr
#elseif NOUGAT
typealias Int = NSInteger
typealias UInt = NSUInteger
#elseif COOPER
typealias Int = Int32
typealias UInt = UInt32
#endif
typealias Int8 = SByte
typealias UInt8 = Byte

typealias IntMax = Int64
typealias UIntMax = UInt64

typealias Bool = Boolean

typealias Character = Char // for now
typealias UnicodeScalar = Char // for now

typealias Float = Single
typealias Float32 = Single
typealias Float64 = Double

typealias Any = protocol<> //Dynamic;
typealias AnyObject = protocol<> //Dynamic;

