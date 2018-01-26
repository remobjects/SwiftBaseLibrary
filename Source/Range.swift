
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

	internal init(_ lowerBound: Bound?, _ upperBound: Bound?, closed: Bool = false) {
		self.lowerBound = lowerBound
		self.upperBound = upperBound
		self.closed = closed
	}

	//
	// Properties
	//

	public var lowerBound: Bound?
	public var upperBound: Bound?
	public var closed: Bool

	var isEmpty: Bool {
		if let lowerBound = lowerBound, let upperBound = upperBound {
			if closed {
				return upperBound == lowerBound
			} else {
				return upperBound < lowerBound
			}
		} else {
			return false
		}
	}

	//
	// Methods
	//

	public func contains(_ element: Bound) -> Bool {
		if let lowerBound = lowerBound {
			if let upperBound = upperBound {
				if closed {
					return element >= lowerBound && element <= upperBound
				} else {
					return element >= lowerBound && element < upperBound
				}
			} else {
				return element >= lowerBound
			}
		} else if let upperBound = upperBound {
			if closed {
				return element <= upperBound
			} else {
				return element < upperBound
			}
		} else {
			return true
		}
	}

	@ToString public func description() -> NativeString {
		var result = ""
		if let lowerBound = lowerBound {
			result += "\(lowerBound)"
		}
		if closed {
			result += "..."
		} else {
			result += "..<"
		}
		if let upperBound = upperBound {
			result = "\(upperBound)"
		}
		return result
	}

	#if COCOA
	override var debugDescription: NativeString! {
		var result = ""
		if let lowerBound = lowerBound {
			result += String(reflecting: lowerBound)
		}
		if closed {
			result += "..."
		} else {
			result += "..<"
		}
		if let upperBound = upperBound {
			result = String(reflecting: upperBound)
		}
		return result
	}
	#else
	var debugDescription: NativeString! {
		var result = ""
		if let lowerBound = lowerBound {
			result += String(reflecting: lowerBound)
		}
		if closed {
			result += "..."
		} else {
			result += "..<"
		}
		if let upperBound = upperBound {
			result = String(reflecting: upperBound)
		}
		return result
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
		if let lowerBound = lowerBound {
			return lowerBound + i
		} else {
			throw Exception("Cannot random-access \(self) because it has no well-defined lower bound")
		}
		return i
	}

	public func GetSequence() -> ISequence<Bound> {
		if let lowerBound = lowerBound {
			var i = lowerBound
			if let upperBound = upperBound {
				if closed {
					while i <= upperBound {
						__yield i
						i += 1
					}
				} else {
					while i < upperBound {
						__yield i
						i += 1
					}
				}
			} else {
				while true {
					__yield i
				}
			}
		} else {
			throw Exception("Cannot iterate over \(self) because it has no well-defined lower bound")
		}
	}

	//
	// Silver-specific extensions not defined in standard Swift.Range:
	//

	public var length: Bound {
		if let lowerBound = lowerBound, let upperBound = upperBound {
			if closed {
				return upperBound-lowerBound+1
			} else {
				return upperBound-lowerBound
			}
		} else {
			throw Exception("Cannot determine the length of \(self) because it has no well-defined lower and upper bounds")
		}
	}

	#if COCOA
	// todo: make a cast operator
	public var nativeRange: NSRange {
		if let lowerBound = lowerBound, upperBound != nil {
			return NSMakeRange(lowerBound, length)
		} else {
			throw Exception("Cannot convert \(self) to NSRange because it has no well-defined lower and upper bounds")
		}
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