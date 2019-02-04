
//74077: Allow GetSequence() to actually be used to implement ISequence

public infix operator >.. {}

public class Range/*<Element: ForwardIndexType, Comparable>*/: CustomStringConvertible, CustomDebugStringConvertible {

	//typealias Index = Int64//Element
	typealias Bound = Int64

	//
	// Initializers
	//

	public init(_ x: Range/*<Element>*/) {
		self.lowerBound = x.lowerBound
		self.upperBound = x.upperBound
		self.lowerBoundClosed = x.lowerBoundClosed
		self.upperBoundClosed = x.upperBoundClosed
		self.reversed = false
	}

	internal init(_ lowerBound: Bound?, _ upperBound: Bound?, upperBoundClosed: Bool = false, lowerBoundClosed: Bool = false) {
		self.lowerBound = lowerBound
		self.upperBound = upperBound
		self.lowerBoundClosed = lowerBoundClosed
		self.upperBoundClosed = upperBoundClosed
		self.reversed = false
	}

	internal init(_ lowerBound: Bound?, _ upperBound: Bound?, upperBoundClosed: Bool = false, lowerBoundClosed: Bool = false, reversed: Bool) {
		self.lowerBound = lowerBound
		self.upperBound = upperBound
		self.lowerBoundClosed = lowerBoundClosed
		self.upperBoundClosed = upperBoundClosed
		self.reversed = reversed
	}

	//
	// Properties
	//

	public var lowerBound: Bound?
	public var upperBound: Bound?
	public var upperBoundClosed: Bool
	public var lowerBoundClosed: Bool
	public var reversed: Bool

	var isEmpty: Bool {
		if let lowerBound = lowerBound, let upperBound = upperBound {
			if upperBoundClosed {
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
				if upperBoundClosed {
					return element >= lowerBound && element <= upperBound
				} else {
					return element >= lowerBound && element < upperBound
				}
			} else {
				return element >= lowerBound
			}
		} else if let upperBound = upperBound {
			if upperBoundClosed {
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
		if reversed {
			if let upperBound = upperBound {
				result = "\(upperBound)"
			}
			if upperBoundClosed {
				if lowerBoundClosed {
					result += "..."
				} else {
					result += "..<"
				}
			} else {
				result += ">.."
			}
			if let lowerBound = lowerBound {
				result += "\(lowerBound)"
			}
		} else {
			if let lowerBound = lowerBound {
				result += "\(lowerBound)"
			}
			if upperBoundClosed {
				if lowerBoundClosed {
					result += "..."
				} else {
					result += ">.."
				}
			} else {
				result += "..<"
			}
			if let upperBound = upperBound {
				result += "\(upperBound)"
			}
		}
		return result
	}

	#if COCOA
	override var debugDescription: NativeString! {
		var result = ""
		if reversed {
			if let upperBound = upperBound {
				result = String(reflecting: upperBound)
			}
			if upperBoundClosed {
				result += "..."
			} else {
				result += ">.."
			}
			if let lowerBound = lowerBound {
				result += String(reflecting: lowerBound)
			}
		} else {
			if let lowerBound = lowerBound {
				result += String(reflecting: lowerBound)
			}
			if upperBoundClosed {
				result += "..."
			} else {
				result += "..<"
			}
			if let upperBound = upperBound {
				result = String(reflecting: upperBound)
			}
		}
		return result
	}
	#else
	var debugDescription: NativeString! {
		var result = ""
		if reversed {
			if let upperBound = upperBound {
				result = String(reflecting: upperBound)
			}
			if upperBoundClosed {
				result += "≤..."
			} else {
				result += "<.."
			}
			if let lowerBound = lowerBound {
				result += String(reflecting: lowerBound)
			}
		} else {
			if let lowerBound = lowerBound {
				result += String(reflecting: lowerBound)
			}
			if upperBoundClosed {
				result += "..."
			} else {
				result += "..<"
			}
			if let upperBound = upperBound {
				result = String(reflecting: upperBound)
			}
		}
		return result
	}
	#endif

	/* Equatable */

	public func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.lowerBound == rhs.lowerBound && lhs.upperBound == rhs.upperBound && lhs.upperBoundClosed == rhs.upperBoundClosed
	}

	/* IEquatable<T> */
	public func Equals(rhs: /*Self*/Range) -> Bool { // 69955: Silver: two issues wit "Self" vs concrete generic type
		return lowerBound == rhs.lowerBound && upperBound == rhs.upperBound && upperBoundClosed == rhs.upperBoundClosed
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
	}

	public func GetSequence() -> ISequence<Int64> {
		if reversed {
			if let upperBound = upperBound {
				var i = upperBound
				if !upperBoundClosed {
					i--
				}
				if var lowerBound = lowerBound {
					if !lowerBoundClosed {
						lowerBound++
					}
					while i >= lowerBound {
						__yield i--
					}
				} else {
					while i >= 0 {
						__yield i--
					}
				}
			} else {
				throw Exception("Cannot iterate over \(self) because it has no well-defined upper bound")
			}
		} else {
			if let lowerBound = lowerBound {
				var i = lowerBound
				if !lowerBoundClosed {
					i++
				}
				if let upperBound = upperBound {
					if upperBoundClosed {
						while i <= upperBound {
							__yield i++
						}
					} else {
						while i < upperBound {
							__yield i++
						}
					}
				} else {
					while true {
						__yield i++
					}
				}
			} else {
				throw Exception("Cannot iterate over \(self) because it has no well-defined lower bound")
			}
		}
	}

	//
	// Silver-specific extensions not defined in standard Swift.Range:
	//

	public var length: Bound? {
		if let lowerBound = lowerBound, let upperBound = upperBound {
			if upperBoundClosed {
				return upperBound-lowerBound+1
			} else {
				return upperBound-lowerBound
			}
		}
		return nil
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

//public extension Swift.Range : ISequence<Int64> {

	//#if JAVA
	//public func iterator() -> Iterator<Int64>! {
		//return GetSequence()
	//}
	//#elseif ECHOES
	//@Implements(typeOf(System.Collections.IEnumerable), "GetEnumerator")
	//func GetEnumeratorNG() -> System.Collections.IEnumerator! {
		//return GetSequence()
	//}

	//public func GetEnumerator() -> IEnumerator<Int64>! {
		//return GetSequence()
	//}
	//#elseif ISLAND
	//@Implements(typeOf(IEnumerable), "GetEnumerator")
	//func GetEnumeratorNG() -> IEnumerator! {
		//return GetSequence()
	//}

	//public func GetEnumerator() -> IEnumerator<Int64>! {
		//return GetSequence()
	//}
	//#elseif TOFFEE
	//public func countByEnumeratingWithState(_ aState: UnsafePointer<NSFastEnumerationState>, objects stackbuf: UnsafePointer<T!>, count len: NSUInteger) -> NSUInteger
	//{
		//return GetSequence()
	//}
	//#endif
//}
//74138: Silver: constrained type extensions
/*extension Range where Element == Int32 {
	#if COCOA
	public init(_ nativeRange: NSRange) {
		startIndex = nativeRange.location
		endIndex = nativeRange.location+nativeRange.length
	}
	#endif
}*/