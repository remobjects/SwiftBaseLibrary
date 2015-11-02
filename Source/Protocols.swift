
#if NOUGAT
/*@unsafe_no_objc_tagged_pointer*/ public protocol _CocoaArrayType {
	func objectAtIndex(index: Int) -> AnyObject
	//func getObjects(_: UnsafeMutablePointer<AnyObject>, range: _SwiftNSRange)
	//func countByEnumeratingWithState(state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>, objects buffer: UnsafeMutablePointer<AnyObject>, count len: Int) -> Int
	//func copyWithZone(_: COpaquePointer) -> _CocoaArrayType
	var count: Int { get }
}
#endif

public protocol Printable {
	var description: String { get }
}

public protocol DebugPrintable {
	var debugDescription: String { get }
}

public protocol Hashable : Equatable {
	var hashValue: Int { get }
}

public protocol ArrayBoundType {
	typealias ArrayBound
	var arrayBoundValue: ArrayBound { get }
}

/* Numbers */

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

public protocol Equatable {
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

/*public protocol SequenceType {
	typealias Generator /*: GeneratorType*/ // 71477: Silver: can't use constraint on type alias in public protocol
	func generate() -> Generator
}

public protocol CollectionType : SequenceType {
	typealias Index /*: ForwardIndexType*/ // 71477: Silver: can't use constraint on type alias in public protocol
	var startIndex: Index { get }
	var endIndex: Index { get }
	typealias _Element
	subscript (i: Index) -> _Element { get }

	//71476: Silver: can't use "Self." prefix on type aliases in generic public protocol
	//subscript (i: /*Self.*/Index) -> /*Self.*/Generator.Element { get } // 71478: Silver: can't use indirect generic type in public protocol
}

public protocol Sliceable : CollectionType {
	typealias SubSlice /*: _Sliceable*/ // 71477: Silver: can't use constraint on type alias in public protocol
	//subscript (bounds: Range</*Self.*/Index>) -> SubSlice { get } // //71476: Silver: can't use "Self." prefix on type aliases in generic public protocol
}*/
