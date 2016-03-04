
/* Numbers */

//public typealias Equatable = IEquatable
public protocol Equatable { // NE19 The public type "IEquatable" has a duplicate with the same short name in reference "Nougat", which is not allowed on Cocoa
	func ==(lhs: Self, rhs: Self) -> Bool
}

//public typealias Comparable = IComparable
public protocol Comparable : Equatable {
	func <(lhs: Self, rhs: Self) -> Bool
	func <=(lhs: Self, rhs: Self) -> Bool
	func >=(lhs: Self, rhs: Self) -> Bool
	func >(lhs: Self, rhs: Self) -> Bool
}

public typealias Incrementable = IIncrementable
public protocol IIncrementable : Equatable {
	func successor() -> Self
}

// CAUTION: Magic type name. 
// The compiler will allow any value implementing Swift.IBooleanType type to be used as boolean
// ToDo: compiler issue 74064 to enable this behaviour
public typealias BooleanType = IBooleanType
public protocol IBooleanType {
	var boolValue: Bool { get }
}

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

// workaround for error E36: Interface type expected, found "IntegerLiteralConvertible<T>!"
public protocol IntegerType : IntegerLiteralConvertible, CustomStringConvertible, /*ArrayBoundType,*/ Hashable, IntegerArithmeticType, BitwiseOperationsType, Incrementable {
}

public protocol SignedNumberType : Comparable, IntegerLiteralConvertible {
	func -(lhs: Self, rhs: Self) -> Self
	prefix func -(x: Self) -> Self
}

public protocol SignedIntegerType : IntegerType, SignedNumberType {
	func toIntMax() -> IntMax
	static/*class*/ func from(_: IntMax) -> Self
}

/*public protocol Strideable : Equatable, Comparable {
	func advancedBy(n: Self.Stride) -> Self
	func distanceTo(other: Self) -> Self.Stride
	//74693: Silver: can't overload interface methods by secondary names
	func stride(# through: Self, by: Self) -> ISequence<Self>
	//func stride(# to: Self, by: Self) -> ISequence<Self>
}*/
