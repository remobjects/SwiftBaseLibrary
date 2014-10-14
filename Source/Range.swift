
struct RangeGenerator_Int { 
	
	init(_ bounds: Range){
		_bounds = bounds
		_index = bounds.startIndex
	}
	private var _bounds: Range!// todo:should not need !
	private var _index: Int

	/*mutating func next() -> Int { //use to test 69957: Silver: lets me overload a fun just by nullability of result value.
		return 1
	}*/
	/* GeneratorType */
	mutating func next() -> Int? {
		if _index < _bounds.endIndex {
			let result = _index;
			_index = _index+1
			return result;
			//return _index++ //69956: Silver: can't return and ++ in one statement
		}
		return nil
	}
}

public class Range {//<T : Int/*ForwardIndexType, IEquatable<T>*/> : IEquatable<Range<T>> {//, CollectionType, Printable, DebugPrintable {
	init(_ x: Self) {
		startIndex = x.startIndex
		endIndex = x.endIndex
	}
	
	init(start: Int/*T*/, end: Int/*T*/) {
		startIndex = start
		endIndex = end
	}
	
	var isEmpty: Bool { 
		return startIndex == endIndex
	}
	
	typealias T = Int
	typealias Index = Int/*T*/
	//typealias Slice = Range<Index>
	
	subscript (i: Int/*T*/) -> Int/*T*/ { 
		return startIndex + i;
	}
	
	/*subscript (_: T._DisabledRangeIndex) -> T { 
	}*/
	
	//typealias Generator = RangeGenerator_Int
	func generate() -> RangeGenerator_Int {
		return RangeGenerator_Int(self)
	}
	
	var startIndex: Int/*T*/ 
	var endIndex: Int/*T*/

	/* Equatable */

	func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.startIndex == rhs.startIndex && lhs.endIndex == rhs.endIndex
	}
	
	/* IEquatable<T> */
	func Equals(rhs: /*Self*/Range) -> Bool { // 69955: Silver: two issues wit "Self" vs concrete generic type
		return startIndex == rhs.startIndex && endIndex == rhs.endIndex 
	}
	
	/* IComparable<T> */
	//func CompareTo(rhs: T) -> Int {
	// }

}
