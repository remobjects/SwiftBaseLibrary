
#if NOUGAT
@unsafe_no_objc_tagged_pointer protocol _CocoaArrayType {
	func objectAtIndex(index: Int) -> AnyObject
	//func getObjects(_: UnsafeMutablePointer<AnyObject>, range: _SwiftNSRange)
	//func countByEnumeratingWithState(state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>, objects buffer: UnsafeMutablePointer<AnyObject>, count len: Int) -> Int
	//func copyWithZone(_: COpaquePointer) -> _CocoaArrayType
	var count: Int { get }
}
#endif

protocol Printable {
	var description: String { get }
}

protocol DebugPrintable {
	var debugDescription: String { get }
}


protocol Hashable : Equatable {
	var hashValue: Int { get }
}


protocol ArrayBoundType {
	typealias ArrayBound
	var arrayBoundValue: ArrayBound { get }
}


/* Numbers */

protocol IntegerLiteralConvertible {
	typealias IntegerLiteralType
	//class func convertFromIntegerLiteral(value: IntegerLiteralType) -> Self
}

protocol _IntegerArithmeticType {
	//class func addWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func subtractWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func multiplyWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func divideWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
	//class func remainderWithOverflow(lhs: Self, _ rhs: Self) -> (Self, overflow: Bool)
}

protocol IntegerArithmeticType : _IntegerArithmeticType, Comparable {
	//func +(lhs: Self, rhs: Self) -> Self
	//func -(lhs: Self, rhs: Self) -> Self
	//func *(lhs: Self, rhs: Self) -> Self
	//func /(lhs: Self, rhs: Self) -> Self
	//func %(lhs: Self, rhs: Self) -> Self
	func toIntMax() -> IntMax
}


protocol BitwiseOperationsType {
	//func &(_: Self, _: Self) -> Self //69825: Silver: two probs with operators in protocols
	//func |(_: Self, _: Self) -> Self
	//func ^(_: Self, _: Self) -> Self
	//prefix func ~(_: Self) -> Self //69825: Silver: two probs with operators in protocols

	/// The identity value for "|" and "^", and the fixed point for "&".
	///
	/// ::
	///
	///   x | allZeros == x
	///   x ^ allZeros == x
	///   x & allZeros == allZeros
	///   x & ~allZeros == x
	///
	//class var allZeros: Self { get }
}

#if !ECHOES
protocol IEquatable<T> {
	func Equals(rhs: T) -> Bool
}

protocol IComparable< /*in*/ T> {
	func CompareTo(rhs: T) -> Int
}
#endif

protocol Equatable {
	//func ==(lhs: Self, rhs: Self) -> Bool
}

protocol _Comparable {
	//func <(lhs: Self, rhs: Self) -> Bool
}

protocol Comparable : _Comparable, Equatable {
	//func <=(lhs: Self, rhs: Self) -> Bool
	//func >=(lhs: Self, rhs: Self) -> Bool
	//func >(lhs: Self, rhs: Self) -> Bool
}

protocol _Incrementable : Equatable {
	//func successor() -> Self
}

protocol _IntegerType : IntegerLiteralConvertible, Printable, ArrayBoundType, Hashable, IntegerArithmeticType, BitwiseOperationsType, _Incrementable {
}

protocol _SignedNumberType : Comparable, IntegerLiteralConvertible {
	//func -(lhs: Self, rhs: Self) -> Self
}

protocol SignedNumberType : _SignedNumberType {
	//refix func -(x: Self) -> Self
}

protocol _SignedIntegerType : _IntegerType, SignedNumberType {
	func toIntMax() -> IntMax
	//class func from(_: IntMax) -> Self
}

/* Ranges, Sequences andf the like */

protocol _ForwardIndexType : _Incrementable {
	//typealias Distance : _SignedIntegerType = Int
	//typealias _DisabledRangeIndex = _DisabledRangeIndex_
}

protocol ForwardIndexType : _ForwardIndexType {
}

protocol GeneratorType {
	typealias Element
	mutating func next() -> Element?
}

protocol _SequenceType {
}

protocol _Sequence_Type : _SequenceType {
	//typealias Generator : GeneratorType
	//func generate() -> Generator
}

protocol SequenceType : _Sequence_Type {
	//typealias Generator : GeneratorType
	//func generate() -> Generator
}

protocol _CollectionType : _SequenceType {
	//typealias Index : ForwardIndexType
	//var startIndex: Index { get }
	//var endIndex: Index { get }
	typealias _Element
	//subscript (i: Index) -> _Element { get }
}

protocol CollectionType : _CollectionType, SequenceType {
	//subscript (i: Self.Index) -> Self.Generator.Element { get }
}

protocol _Sliceable : CollectionType {
}

protocol Sliceable : _Sliceable {
	//typealias SubSlice : _Sliceable
	//subscript (bounds: Range<Self.Index>) -> SubSlice { get }
}

