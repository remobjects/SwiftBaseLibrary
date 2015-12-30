
//74077: Allow GetSequence() to actually be used to implement ISequence
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
		return "Range(\(String(reflecting: startIndex))..<\(String(reflecting: endIndex)))"
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
