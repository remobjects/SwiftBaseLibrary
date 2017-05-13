
public protocol ForwardIndexType {
	associatedtype Distance /*: SignedIntegerType*/ = Int
	func advancedBy(_ n: Self.Distance) -> Self
	func advancedBy(_ n: Self.Distance, limit: Self) -> Self
	func distanceTo(_ end: Self) -> Self.Distance
}

public protocol BidirectionalIndexType : ForwardIndexType {
	//func advancedBy(_ n: Self.Distance) -> Self                    // duped from ForwardIndexType?
	//func advancedBy(_ n: Self.Distance, limit limit: Self) -> Self // duped from ForwardIndexType?
	func predecessor() -> Self
	func successor() -> Self
}

public protocol ReverseIndexType : BidirectionalIndexType {
	associatedtype Base : BidirectionalIndexType
	//associatedtype Distance : SignedIntegerType = Self.Base.Distance // duped from ForwardIndexType?
	init(_ base: Self.Base)
	var base: Self.Base { get }
}

public protocol Strideable : Comparable {
	associatedtype Stride : SignedNumberType
	//74968: Silver: compiler ignores undefined associated type (`Self.whatever`)

	func advancedBy(_ n: Self.Stride) -> Self
	func distanceTo(_ other: Self) -> Self.Stride
	func stride(# through: Self, by: Self) -> ISequence<Self>
	func stride(# to: Self, by: Self) -> ISequence<Self>
}

public protocol RandomAccessIndexType : BidirectionalIndexType, Strideable {
	//func advancedBy(_ n: Self.Distance) -> Self                    // duped from ForwardIndexType?
	//func advancedBy(_ n: Self.Distance, limit limit: Self) -> Self // duped from ForwardIndexType?
	//func distanceTo(_ other: Self) -> Self.Distance                // duped from ForwardIndexType?
}

// workaround for error E36: Interface type expected, found "IntegerLiteralConvertible<T>!"
public protocol IntegerType : RandomAccessIndexType {
	// no members
}