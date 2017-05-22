
//74077: Allow GetSequence() to actually be used to implement ISequence

public class Range/*<Element: ForwardIndexType, Comparable>*/: CustomStringConvertible, CustomDebugStringConvertible/* ISequence<IntMax>*/ {

	//typealias Index = Int64//Element
	typealias Bound = Int64

	//
	// Initializers
	//

	public init(_ x: Range/*<Element>*/) {
		self.lowerBound = x.lowerBound
		self.upperBound = x.upperBound
		self.closed = x.closed
	}

	internal init(_ lowerBound: Bound, _ upperBound: Bound, closed: Bool = false) {
		self.lowerBound = lowerBound
		self.upperBound = upperBound
		self.closed = closed
	}

	//
	// Properties
	//

	public var lowerBound: Bound
	public var upperBound: Bound
	public var closed: Bool

	var isEmpty: Bool {
		if closed {
			return upperBound == lowerBound
		} else {
			return upperBound < lowerBound
		}
	}

	//
	// Methods
	//

	public func contains(_ element: Bound) -> Bool {
		if closed {
			return element >= lowerBound && element <= upperBound
		} else {
			return element >= lowerBound && element < upperBound
		}
	}

	@ToString public func description() -> NativeString {
		if closed {
			return "\(lowerBound)...\(upperBound)"
		} else {
			return "\(lowerBound)..<\(upperBound)"
		}
	}

	#if COCOA
	override var debugDescription: NativeString! {
		if closed {
			return "Range(\(String(reflecting: lowerBound))...\(String(reflecting: upperBound)))"
		} else {
			return "Range(\(String(reflecting: lowerBound))..<\(String(reflecting: upperBound)))"
		}
	}
	#else
	public var debugDescription: NativeString {
		if closed {
			return "Range(\(String(reflecting: lowerBound))...\(String(reflecting: upperBound)))"
		} else {
			return "Range(\(String(reflecting: lowerBound))..<\(String(reflecting: upperBound)))"
		}
	}
		#endif
	
	/* Equatable */

	public func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.lowerBound == rhs.lowerBound && lhs.upperBound == rhs.upperBound && lhs.closed == rhs.closed
	}

	/* IEquatable<T> */
	public func Equals(rhs: /*Self*/Range) -> Bool { // 69955: Silver: two issues wit "Self" vs concrete generic type
		return lowerBound == rhs.lowerBound && upperBound == rhs.upperBound && closed == rhs.closed
	}

	/* IComparable<T> */
	//func CompareTo(rhs: T) -> Element {
	// }

	//
	// Subscripts & Iterators
	//

	public subscript (i: Bound) -> Bound {
		//return startIndex + i
		return i
	}

	public func GetSequence() -> ISequence<Bound> {
		var i = lowerBound
		if closed {
			while i < upperBound {
				__yield i
				i += 1
			}
		} else {
			while i <= upperBound {
				__yield i
				i += 1
			}
		}
	}

	//
	// Silver-specific extensions not defined in standard Swift.Range:
	//

	public var length: Bound {
		if closed {
			return upperBound-lowerBound+1
		} else {
			return upperBound-lowerBound
		}
	}
	
	#if COCOA 
	// todo: make a cast operator
	public var nativeRange: NSRange {
		return NSMakeRange(lowerBound, length)
	}
	#endif

}

//74138: Silver: constrained type extensions
/*extension Range where Element == Int32 {
	#if COCOA 
	public init(_ nativeRange: NSRange) {
		startIndex = nativeRange.location
		endIndex = nativeRange.location+nativeRange.length
	}
	#endif	
}*/
