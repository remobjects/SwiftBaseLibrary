infix operator ... { precedence 135 associativity none } 
infix operator ..< { precedence 135 associativity none }

public extension Int32 {
	
	public func ... (a: Int32, b: Int32) -> ISequence<Int32> {
		for var i = a; i <= b; i++ {
			__yield i;
		}
	}
	
	public func ... (a: Int64, b: Int32) -> ISequence<Int64> {
		for var i: Int64 = a; i <= b; i++ {
			__yield i;
		}
	}
	
	public func ... (a: Int32, b: Int64) -> ISequence<Int64> {
		for var i: Int64 = a; i <= b; i++ {
			__yield i;
		}
	}
	
	public func ..< (a: Int32, b: Int32) -> ISequence<Int32> {
		for var i = a; i < b; i++ {
			__yield i;
		}
	}
	
	public func ..< (a: Int64, b: Int32) -> ISequence<Int64> {
		for var i: Int64 = a; i < b; i++ {
			__yield i;
		}
	}
	
	public func ..< (a: Int32, b: Int64) -> ISequence<Int64> {
		for var i: Int64 = a; i < b; i++ {
			__yield i;
		}
	}
}

public extension Int64 {
	
	public func ... (a: Int64, b: Int64) -> ISequence<Int64> {
		for var i = a; i <= b; i++ {
			__yield i;
		}
	}
	
	public func ..< (a: Int64, b: Int64) -> ISequence<Int64> {
		for var i = a; i < b; i++ {
			__yield i;
		}
	}
}

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

public class Range /*: ISequence<IntMax>*/ {//<T : IntMax/*ForwardIndexType, IEquatable<T>*/> : IEquatable<Range<T>> {//, CollectionType, PrIntMaxable, DebugPrIntMaxable {

	//
	// Initializers
	//

	public init(_ x: Range) {
		startIndex = x.startIndex
		endIndex = x.endIndex
	}
	
	public init(start: IntMax, end: IntMax) {
		startIndex = start
		endIndex = end
	}
	
	#if NOUGAT 
	public init(_ nativeRange: NSRange) {
		startIndex = nativeRange.location
		endIndex = nativeRange.location+nativeRange.length
	}
	#endif
	
	//
	// Properties
	//
	
	public var startIndex: IntMax 
	public var endIndex: IntMax
	
	//
	// Methods
	//
	
	#if NOUGAT
	override var description: String! {
	#else
	public var description: String {
	#endif
		return "\(startIndex)..<\(endIndex)"
	}

	#if NOUGAT
	override var debugDescription: String! {
	#else
	public var debugDescription: String {
		#endif
		//return "Range(\(String(reflecting: startIndex))..<\(String(reflecting: endIndex)))"
		return "Range(\(startIndex)..<\(endIndex))"
	}
	
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

	//
	// Subscripts & Iterators
	//
	
	public subscript (i: IntMax) -> IntMax { 
		//return startIndex + i
		return i
	}
	
	public func GetSequence() -> ISequence<IntMax> {
		var i = startIndex
		while i < endIndex {
			__yield i
			i += 1
		}
	}
	
	//
	// Silver-specific extensions not defined in standard Swift.Range:
	//

	public var length: IntMax {
		return endIndex-startIndex
	}
	
	#if NOUGAT 
	// todo: make a cast operator
	public var nativeRange: NSRange {
		return NSMakeRange(startIndex, endIndex-startIndex)
	}
	#endif

}
