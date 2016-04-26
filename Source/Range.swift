
//74077: Allow GetSequence() to actually be used to implement ISequence
public class Range/*<Element: ForwardIndexType, Comparable>*/: /*Equatable, CollectionType,*/ CustomStringConvertible, CustomDebugStringConvertible/* ISequence<IntMax>*/ {

	//typealias Index = Int64//Element
	typealias Element = Int64
	
	//
	// Initializers
	//

	public init(_ x: Range/*<Element>*/) {
		startIndex = x.startIndex
		endIndex = x.endIndex
	}
	
	@Obsolete("Use ... or ..< operator instead") public init(start: Element, end: Element) {
		startIndex = start
		endIndex = end
	}
	
	//
	// Properties
	//
	
	public var startIndex: Element 
	public var endIndex: Element
	
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
	//func CompareTo(rhs: T) -> Element {
	// }

	//
	// Subscripts & Iterators
	//
	
	public subscript (i: Element) -> Element { 
		//return startIndex + i
		return i
	}
	
	public func GetSequence() -> ISequence<Element> {
		var i = startIndex
		while i < endIndex {
			__yield i
			i += 1
		}
	}
	
	//
	// Silver-specific extensions not defined in standard Swift.Range:
	//

	public var length: Element {
		return endIndex-startIndex
	}
	
	#if NOUGAT 
	// todo: make a cast operator
	public var nativeRange: NSRange {
		return NSMakeRange(startIndex, endIndex-startIndex)
	}
	#endif

}

//74138: Silver: constrained type extensions
/*extension Range where Element == Int32 {
	#if NOUGAT 
	public init(_ nativeRange: NSRange) {
		startIndex = nativeRange.location
		endIndex = nativeRange.location+nativeRange.length
	}
	#endif	
}*/
