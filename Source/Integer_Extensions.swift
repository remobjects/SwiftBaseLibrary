
infix operator ... { precedence 135 associativity none } 
infix operator ..< { precedence 135 associativity none }

public extension Int32 {//: Equatable, Comparable, ForwardIndexType {

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

	public func stride(# through: Int32, by: Int32) -> ISequence<Int32> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i <= through {
			__yield i;
			i += by
		}
	}

	public func stride(# to: Int32, by: Int32) -> ISequence<Int32> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i < to {
			__yield i;
			i += by
		}
	}
}

public extension Int64 {//: Equatable, Comparable, ForwardIndexType {
	
	// Interval Operators
	
	public func ... (a: Int64, b: Int64) -> ClosedInterval/*<Int64>*/ {
		return ClosedInterval/*<Int64>*/(a, b)
	}
	
	public func ..< (a: Int64, b: Int64) -> HalfOpenInterval/*<Int64>*/ {
		return HalfOpenInterval/*<Int64>*/(a, b)
	}

	public func stride(# through: Int64, by: Int64) -> ISequence<Int64> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i <= through {
			__yield i;
			i += by
		}
	}

	public func stride(# to: Int64, by: Int64) -> ISequence<Int64> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i < to {
			__yield i;
			i += by
		}
	}
}

public extension Float {
	
	public func stride(# through: Float, by: Float) -> ISequence<Float> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i <= through {
			__yield i;
			i += by
		}
	}

	public func stride(# to: Float, by: Float) -> ISequence<Float> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i < to {
			__yield i;
			i += by
		}
	}
}

public extension Double {
	
	public func stride(# through: Double, by: Double) -> ISequence<Double> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i <= through {
			__yield i;
			i += by
		}
	}

	public func stride(# to: Double, by: Double) -> ISequence<Double> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i < to {
			__yield i;
			i += by
		}
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