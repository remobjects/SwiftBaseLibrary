
/* Numbers */

//public typealias Equatable = IEquatable
public protocol Equatable { // NE19 The public type "IEquatable" has a duplicate with the same short name, which is not allowed on Cocoa
	func ==(lhs: Self, rhs: Self) -> Bool
}

//public typealias Comparable = IComparable
public protocol Comparable : Equatable {
	func <(lhs: Self, rhs: Self) -> Bool
	func <=(lhs: Self, rhs: Self) -> Bool
	func >=(lhs: Self, rhs: Self) -> Bool
	func >(lhs: Self, rhs: Self) -> Bool
}

public typealias IIncrementable = Incrementable
public protocol Incrementable : Equatable {
	func successor() -> Self
}

// CAUTION: Magic type name.
// The compiler will allow any value implementing Swift.IBooleanType type to be used as boolean
public typealias IBooleanType = BooleanType
public protocol BooleanType {
	var boolValue: Bool { get }
}

public typealias IntegerArithmetic = IntegerArithmeticType
public protocol IntegerArithmeticType : Comparable {
	//class func addWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool) //71481: Silver: can't use Self in tuple on static funcs i(in public protocols?)
	//class func subtractWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func multiplyWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func divideWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func remainderWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)

	func +(lhs: Self, rhs: Self) -> Self
	func -(lhs: Self, rhs: Self) -> Self
	func *(lhs: Self, rhs: Self) -> Self
	func /(lhs: Self, rhs: Self) -> Self
	func %(lhs: Self, rhs: Self) -> Self
	func toIntMax() -> IntMax
}

public typealias BitwiseOperations = BitwiseOperationsType
public protocol BitwiseOperationsType {
	//func &(_: Self, _: Self) -> Self //69825: Silver: two probs with operators in public protocols
	func |(_: Self, _: Self) -> Self
	func ^(_: Self, _: Self) -> Self
	prefix func ~(_: Self) -> Self

	/// The identity value for "|" and "^", and the fixed point for "&".
	///
	/// ::
	///
	///   x | allZeros == x
	///   x ^ allZeros == x
	///   x & allZeros == allZeros
	///   x & ~allZeros == x
	///
	//static/*class*/ var allZeros: Self { get }
}

public typealias SignedNumber = ISignedNumberType
public typealias SignedNumberType = ISignedNumberType
public protocol ISignedNumberType : Comparable, IntegerLiteralConvertible {
	prefix func -(_ x: Self) -> Self
	func -(_ lhs: Self, _ rhs: Self) -> Self
}

public protocol AbsoluteValuable : SignedNumberType {
	static func abs(_ x: Self) -> Self
}

public typealias SignedInteger = ISignedIntegerType
public typealias SignedIntegerType = ISignedIntegerType
public protocol ISignedIntegerType {
	init(_ value: IntMax)
	func toIntMax() -> IntMax
}

public typealias UnsignedInteger = IUnsignedIntegerType
public typealias UnsignedIntegerType = IUnsignedIntegerType
public protocol IUnsignedIntegerType {
	init(_ value: UIntMax)
	func toUIntMax() -> UIntMax
}