
#if NOUGAT
/*@unsafe_no_objc_tagged_pointer*/ public protocol _CocoaArrayType {
	func objectAtIndex(index: Int) -> AnyObject
	//func getObjects(_: UnsafeMutablePointer<AnyObject>, range: _SwiftNSRange)
	//func countByEnumeratingWithState(state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>, objects buffer: UnsafeMutablePointer<AnyObject>, count len: Int) -> Int
	//func copyWithZone(_: COpaquePointer) -> _CocoaArrayType
	var count: Int { get }
}
#endif

public typealias CustomStringConvertible = ICustomStringConvertible
public protocol ICustomStringConvertible {
	var description: String! { get } // unwrapped nullable for better Nougat compatibility
}

public typealias CustomDebugStringConvertible = ICustomDebugStringConvertible
public protocol ICustomDebugStringConvertible {
	#if NOUGAT
	var debugDescription: String! { get }
	#else
	var debugDescription: String { get }
	#endif
}

public typealias Hashable = IHashable
public protocol IHashable /*: Equatable*/ {
	var hashValue: Int { get }
}

/* Numbers */

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

//public typealias Equatable = IEquatable
public protocol Equatable { // NE19 The public type "IEquatable" has a duplicate with the same short name in reference "Nougat", which is not allowed on Cocoa
	func ==(lhs: Self, rhs: Self) -> Bool
}

public protocol Comparable : Equatable {
	func <(lhs: Self, rhs: Self) -> Bool
	func <=(lhs: Self, rhs: Self) -> Bool
	func >=(lhs: Self, rhs: Self) -> Bool
	func >(lhs: Self, rhs: Self) -> Bool
}

public protocol Incrementable : Equatable {
	func successor() -> Self
}

// workaround for error E36: Interface type expected, found "IntegerLiteralConvertible<T>!"
/*public protocol IntegerType : IntegerLiteralConvertible, Printable, ArrayBoundType, Hashable, IntegerArithmeticType, BitwiseOperationsType, Incrementable {
}

public protocol SignedNumberType : Comparable, IntegerLiteralConvertible {
	func -(lhs: Self, rhs: Self) -> Self
	prefix func -(x: Self) -> Self
}

public protocol SignedIntegerType : IntegerType, SignedNumberType {
	func toIntMax() -> IntMax
	static/*class*/ func from(_: IntMax) -> Self
}*/

/* Ranges, Sequences and the like */

public protocol ForwardIndexType {
	//typealias Distance : _SignedIntegerType = Int
	//typealias _DisabledRangeIndex = _DisabledRangeIndex_
}

public protocol GeneratorType {
	typealias Element
	mutating func next() -> Element?
}

/*public protocol SequenceType */

public typealias OutputStreamType = IOutputStreamType
public protocol IOutputStreamType {
	mutating func write(_ string: String)
}

public typealias Streamable = IStreamable
public protocol IStreamable {
	func writeTo<Target: OutputStreamType>(inout _ target: Target)
}

public typealias CollectionType<T> = ICollectionType<T>
public protocol ICollectionType<T> : ISequence<T> {
	var startIndex: Int { get }
	var endIndex: Int { get }
	subscript (i: Int) -> T { get }
}

/*public protocol Sliceable : CollectionType {
	typealias SubSlice /*: _Sliceable*/ // 71477: Silver: can't use constraint on type alias in public protocol
	//subscript (bounds: Range</*Self.*/Index>) -> SubSlice { get } // //71476: Silver: can't use "Self." prefix on type aliases in generic public protocol
}*/
