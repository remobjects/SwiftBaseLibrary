
public protocol ForwardIndexType {
	associatedtype Distance /*: SignedIntegerType*/ = Int
	@warn_unused_result func advancedBy(n: Self.Distance) -> Self
	@warn_unused_result func advancedBy(n: Self.Distance, limit: Self) -> Self
	@warn_unused_result func distanceTo(end: Self) -> Self.Distance
}

public protocol BidirectionalIndexType : ForwardIndexType {
	//@warn_unused_result func advancedBy(_ n: Self.Distance) -> Self					// duped from ForwardIndexType?
	//@warn_unused_result func advancedBy(_ n: Self.Distance, limit limit: Self) -> Self // duped from ForwardIndexType?
	@warn_unused_result func predecessor() -> Self
	@warn_unused_result func successor() -> Self
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
	
	@warn_unused_result func advancedBy(n: Self.Stride) -> Self
	@warn_unused_result func distanceTo(other: Self) -> Self.Stride
	@warn_unused_result func stride(# through: Self, by: Self) -> ISequence<Self>
	@warn_unused_result func stride(# to: Self, by: Self) -> ISequence<Self>
}

public protocol RandomAccessIndexType : BidirectionalIndexType, Strideable {
	//@warn_unused_result func advancedBy(_ n: Self.Distance) -> Self					// duped from ForwardIndexType?
	//@warn_unused_result func advancedBy(_ n: Self.Distance, limit limit: Self) -> Self // duped from ForwardIndexType?
	//@warn_unused_result func distanceTo(_ other: Self) -> Self.Distance				// duped from ForwardIndexType?
}

// workaround for error E36: Interface type expected, found "IntegerLiteralConvertible<T>!"
public protocol IntegerType : RandomAccessIndexType {
	// no members
}

