
struct RangeGenerator<T /*: ForwardIndexType*/> : /*GeneratorType,*/ SequenceType {
	typealias Element = T
	/*init(_ bounds: Range<T>){
	}*/
	mutating func next() -> T?{
	}
	typealias Generator = RangeGenerator<T>
	/*func generate() -> RangeGenerator<T> {
	}*/
	var startIndex: T! // shoudolnt need ! once set from init
	var endIndex: T! // shoudolnt need ! once set from init
	
	/* GeneratorType */
	/*mutating func next() -> Element? {
	}*/
}

struct Range<T /*: ForwardIndexType*/> {//: Equatable, CollectionType, Printable, DebugPrintable {

	/// Construct a copy of `x`
	/*init(_ x: Range<T>) {
	}*/
	
	init(start: T, end: T) {
		startIndex = start
		endIndex = end
	}
	
	var isEmpty: Bool { 
		return startIndex == endIndex
	}
	
	typealias Index = T
	typealias Slice = Range<T>
	
	subscript (i: T) -> T { 
	}
	
	/*subscript (_: T._DisabledRangeIndex) -> T { 
	}*/
	
	typealias Generator = RangeGenerator<T>
	
	/*func generate() -> RangeGenerator<T> {
	}*/
	
	var startIndex: T! // shoudolnt need !
	var endIndex: T! // shoudolnt need !

	/// The `Range`\ 's printed representation
	var description: String { 
	}

	/// The `Range`\ 's verbose printed representation
	var debugDescription: String { 
	}
}
