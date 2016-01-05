
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

public typealias OutputStreamType = IOutputStreamType
public protocol IOutputStreamType {
	mutating func write(_ string: String)
}

public typealias Streamable = IStreamable
public protocol IStreamable {
	func writeTo<Target: OutputStreamType>(inout _ target: Target)
}

//
// Collections, Sequences and the like
//

/*public protocol GeneratorType {
	typealias Element
	mutating func next() -> Element?
}*/

public typealias SequenceType<T> = ISequence<T>
//public protocol ISequence<T> // is priovided by the compiler

public typealias LazySequenceType<T> = ILazySequence<T>
public typealias ILazySequence<T> = ISequence<T> // for now; maybe eventually we'=ll make non-lazy sequences too

public protocol ForwardIndexType {
	typealias Distance : SignedIntegerType = Int
}

public typealias Indexable = IIndexable // <> should't be needed in ancestor
public protocol IIndexable {
	typealias Index : ForwardIndexType // <> shoudlnt be needed
	typealias Distance // should not be needed, should inherit
	typealias Element
	var startIndex: Index { get }
	var endIndex: Index { get }
	subscript(position: Index) -> Element { get }
}

public typealias CollectionType = ICollectionType
public protocol ICollectionType : IIndexable {
	typealias Index : ForwardIndexType, Comparable // should not be needed, should inherit
	typealias Distance // should not be needed, should inherit
	typealias Element // should not be needed, should inherit
	var startIndex: ForwardIndexType { get } // <> shoudlnt be needed
	var endIndex: ForwardIndexType { get } // <> shoudlnt be needed
	subscript (i: Int) -> Element { get }
}

public typealias Sliceable = ISliceable
public protocol ISliceable : ICollectionType {
	typealias SubSlice : Sliceable // 71477: Silver: can't use constraint on type alias in public protocol
	subscript (bounds: Range/*<Index>*/) -> SubSlice { get } // //71476: Silver: can't use "Self." prefix on type aliases in generic public protocol
}
