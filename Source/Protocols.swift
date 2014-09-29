
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

/* Ranges, Sequences andf the like */

protocol Equatable {
	func ==(lhs: Self, rhs: Self) -> Bool
}

protocol _Incrementable : Equatable {
	func successor() -> Self
}

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

