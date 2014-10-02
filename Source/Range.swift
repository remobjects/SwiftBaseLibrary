
struct RangeGenerator<T: ForwardIndexType> { //: /*GeneratorType,*/ SequenceType {
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

public class Range<T : ForwardIndexType/*, IEquatable<T>*/> : IEquatable<Range<T>> {//, CollectionType, Printable, DebugPrintable {
	init(_ x: Range<T>) {
		startIndex = x.startIndex
		endIndex = x.endIndex
	}
	
	init(start: T, end: T) {
		startIndex = start
		endIndex = end
	}
	
	var isEmpty: Bool { 
		//return startIndex.Equals(endIndex)
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
	
	var startIndex: T! // shoudolnt need ! since all int()s set it
	var endIndex: T! // shoudolnt need ! since all int()s set it


	/* Equatable */

	func ==(lhs: Self, rhs: Self) -> Bool {
		//return lhs.startIndex.Equals(rhs.startIndex) && lhs.endIndex.Equals(rhs.endIndex)
	}
	
	/* IEquatable<T> */
	func Equals(rhs: Range<T> /*Self*/) -> Bool {
		//return startIndex.Equals(rhs.startIndex) && endIndex.Equals(rhs.endIndex)
	}
	
	/* IComparable<T> */
	//func CompareTo(rhs: T) -> Int {
	// }


	/* Printable, DebugPrintable */

	var description: String { 
		//todo
	}

	var debugDescription: String { 
		//todo
	}
}
