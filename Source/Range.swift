
struct RangeGenerator_IntMax { 
	
	init(_ bounds: Range){
		_bounds = bounds
		_index = bounds.startIndex
	}
	private var _bounds: Range!// todo:should not need !
	private var _index: IntMax

	/* GeneratorType */
	public mutating func next() -> IntMax? {
		if _index < _bounds.endIndex {
			return _index++
		}
		return nil
	}
}

public class Range /*ISequence<IntMax>*/ {//<T : IntMax/*ForwardIndexType, IEquatable<T>*/> : IEquatable<Range<T>> {//, CollectionType, PrIntMaxable, DebugPrIntMaxable {
	init(_ x: Self) {
		startIndex = x.startIndex
		endIndex = x.endIndex
	}
	
	init(start: IntMax, end: IntMax) {
		startIndex = start
		endIndex = end
	}
	
	public var isEmpty: Bool { 
		return startIndex == endIndex
	}
	
	typealias T = IntMax
	typealias Index = IntMax
	//typealias Slice = Range<Index>
	
	public subscript (i: IntMax) -> IntMax { 
		return startIndex + i;
	}
	
	//typealias Generator = RangeGenerator_IntMax
	func generate() -> RangeGenerator_IntMax {
		return RangeGenerator_IntMax(self)
	}
	
	public var startIndex: IntMax 
	public var endIndex: IntMax

	/* Equatable */

	public func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.startIndex == rhs.startIndex && lhs.endIndex == rhs.endIndex
	}
	
	/* IEquatable<T> */
	public func Equals(rhs: /*Self*/Range) -> Bool { // 69955: Silver: two issues wit "Self" vs concrete generic type
		return startIndex == rhs.startIndex && endIndex == rhs.endIndex 
	}
	
	/* IComparable<T> */
	//func CompareTo(rhs: T) -> IntMax {
	// }

}
