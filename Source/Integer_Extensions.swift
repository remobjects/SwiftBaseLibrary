
infix operator ... { precedence 135 associativity none } 
infix operator ..< { precedence 135 associativity none }

public extension Int32 {//: Equatable, Comparable, ForwardIndexType {

	// Equatable
	
	func ==(lhs: Self, rhs: Self) -> Bool {
		return rhs == lhs
	}

	// Comparable

	func <(lhs: Self, rhs: Self) -> Bool {
		return lhs < rhs
	}
	func <=(lhs: Self, rhs: Self) -> Bool {
		return lhs <= rhs
	}
	func >=(lhs: Self, rhs: Self) -> Bool {
		return lhs >= rhs
	}
	func >(lhs: Self, rhs: Self) -> Bool {
		return lhs > rhs
	}
	
	
	// Interval Operators
	
	public func ... (a: Int32, b: Int32) -> ClosedInterval/*<Int32>*/ {
		return ClosedInterval/*<Int32>*/(a, b)
	}
	
	public func ... (a: Int64, b: Int32) -> ClosedInterval/*<Int64>*/ {
		return ClosedInterval/*<Int64>*/(a, b)
	}
	
	public func ... (a: Int32, b: Int64) -> ClosedInterval/*<Int64>*/ {
		return ClosedInterval/*<Int64>*/(a, b)
	}
	
	public func ..< (a: Int32, b: Int32) -> HalfOpenInterval/*<Int32>*/ {
		return HalfOpenInterval/*<Int64>*//*<Int32>*/(a, b)
	}
	
	public func ..< (a: Int64, b: Int32) -> HalfOpenInterval/*<Int64>*/ {
		return HalfOpenInterval/*<Int64>*/(a, b)
	}
	
	public func ..< (a: Int32, b: Int64) -> HalfOpenInterval/*<Int64>*/ {
		return HalfOpenInterval/*<Int64>*/(a, b)
	}
}

public extension Int64 {//: Equatable, Comparable, ForwardIndexType {
	
	// Equatable
	func ==(lhs: Self, rhs: Self) -> Bool {
		return rhs == lhs
	}

	// Comparable

	func <(lhs: Self, rhs: Self) -> Bool {
		return lhs < rhs
	}
	func <=(lhs: Self, rhs: Self) -> Bool {
		return lhs <= rhs
	}
	func >=(lhs: Self, rhs: Self) -> Bool {
		return lhs >= rhs
	}
	func >(lhs: Self, rhs: Self) -> Bool {
		return lhs > rhs
	}
	
	// Interval Operators
	
	public func ... (a: Int64, b: Int64) -> ClosedInterval/*<Int64>*/ {
		return ClosedInterval/*<Int64>*/(a, b)
	}
	
	public func ..< (a: Int64, b: Int64) -> HalfOpenInterval/*<Int64>*/ {
		return HalfOpenInterval/*<Int64>*/(a, b)
	}
}

public extension UInt64 {

	internal func toHexString(# length: Int = 8) -> String {
		#if COOPER
		return String.format("%0\(length)x", self)
		#elseif ECHOES
		return String.Format("{0:x\(length)}", self)
		#elseif NOUGAT
		return String(format: "%0\(length)lld}", self)
		#endif
	}
}