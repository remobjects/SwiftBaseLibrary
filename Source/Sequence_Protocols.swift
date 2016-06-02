
public typealias ISequenceType = SequenceType
public typealias SequenceType<T> = ISequence<T>
//public protocol ISequence<T> is priovided by the compiler

public typealias ILazySequenceType<T> = LazySequenceType<T>
public typealias LazySequenceType<T> = ILazySequence<T>
public typealias ILazySequence<T> = ISequence<T> // for now; maybe eventually we'll make non-lazy sequences too

public typealias IIndexable = Indexable
public protocol Indexable {
	associatedtype Index: ForwardIndexType
	associatedtype Element
	var startIndex: Index { get }
	var endIndex: Index { get }
	subscript(position: Index) -> Element { get }
}

public typealias ICollectionType = CollectionType
public protocol CollectionType : Indexable {
	associatedtype SubSequence: Indexable, SequenceType<Index> = ISequence<Index>
	subscript(bounds: Range/*<Index>*/) -> SubSequence { get }
	
	@warn_unused_result func prefixUpTo(_ end: Index) -> SubSequence
	@warn_unused_result func suffixFrom(_ start: Index) -> SubSequence
	@warn_unused_result func prefixThrough(_ position: Index) -> SubSequence
	
	var isEmpty: Bool { get }
	//74969: Silver: compiler can't see nested associated type from associated type
	var count: Int/*Index.Distance*/ { get }
	
	var first: Element? { get }
}

public typealias Sliceable = ISliceable
public protocol ISliceable : ICollectionType {
	associatedtype SubSlice : Sliceable // 71477: Silver: can't use constraint on type alias in public protocol
	subscript (bounds: Range/*<Index>*/) -> SubSlice { get } // //71476: Silver: can't use "Self." prefix on type aliases in generic public protocol
}
