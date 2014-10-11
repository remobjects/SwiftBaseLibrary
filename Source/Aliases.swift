
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
//typealias AnyClass = AnyObject.Type


/* more absucre integer aliases */

typealias BooleanLiteralType = Bool
typealias CBool = Bool
typealias CChar = Int8
typealias CChar16 = UInt16
typealias CChar32 = UnicodeScalar
typealias CDouble = Double
typealias CFloat = Float
typealias CInt = Int32
typealias CLong = Int
typealias CLongLong = Int64
typealias CShort = Int16
typealias CSignedChar = Int8
typealias CUnsignedChar = UInt8
typealias CUnsignedInt = UInt32
typealias CUnsignedLong = UInt
typealias CUnsignedLongLong = UInt64
typealias CUnsignedShort = UInt16
typealias CWideChar = UnicodeScalar
typealias ExtendedGraphemeClusterType = String
typealias FloatLiteralType = Double
typealias IntegerLiteralType = Int
typealias StringLiteralType = String
typealias UWord = UInt
typealias UnicodeScalarType = String
//typealias Void = () // define dby Compiler
typealias Word = Int

//struct Float80 { // A record needs to have at least 1 field or a "StructLayoutAttribute" with "Size > 0"
//}