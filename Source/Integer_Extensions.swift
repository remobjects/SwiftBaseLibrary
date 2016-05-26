
// Equatable, Comparable, Incrementable, SignedNumberType, SignedIntegerType, IntegerArithmeticType, ForwardIndexType */

public extension Int32  {

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

public extension Int32 /*: AbsoluteValuable*/ {

	@warn_unused_result static func abs(_ x: Self) -> Self {
		#if COOPER
		return Int32.abs(x)
		#elseif ECHOES || ISLAND
		return Math.Abs(x)
		#elseif NOUGAT
		return ABS(x)
		#endif
	}
}

public extension Int32 /*: Strideable*/ {
	// Strideable

	func advancedBy(n: Int32) -> Int32 {
		return self + n;
	}
	
	func distanceTo(other: Int32) -> Int32 {
		return other - self;
	}
	
	public func stride(# through: Int32, by: Int32) -> ISequence<Int32> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i <= through {
			__yield i;
			i += by
		}
	}

	// workaround for 74743: Android app fails to run with SBL methods ovewrloaded by name only
	#if NOUGAT
	public func stride(# to: Int32, by: Int32) -> ISequence<Int32> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i < to {
			__yield i;
			i += by
		}
	}
	#endif
}

public extension Int64 {//: Equatable, Comparable, ForwardIndexType {
	
	// Interval Operators
	
	public func ... (a: Int64, b: Int64) -> ClosedInterval/*<Int64>*/ {
		return ClosedInterval/*<Int64>*/(a, b)
	}
	
	public func ..< (a: Int64, b: Int64) -> HalfOpenInterval/*<Int64>*/ {
		return HalfOpenInterval/*<Int64>*/(a, b)
	}

	// Strideable

	func advancedBy(n: Int64) -> Int64 {
		return self + n;
	}
	
	func distanceTo(other: Int64) -> Int64 {
		return other - self;
	}
	
	public func stride(# through: Int64, by: Int64) -> ISequence<Int64> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i <= through {
			__yield i;
			i += by
		}
	}

	// workaround for 74743: Android app fails to run with SBL methods ovewrloaded by name only
	#if !COOPER
	public func stride(# to: Int64, by: Int64) -> ISequence<Int64> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i < to {
			__yield i;
			i += by
		}
	}
	#endif
}

public extension Float {
	
	// Strideable

	func advancedBy(n: Float) -> Float {
		return self + n;
	}
	
	func distanceTo(other: Float) -> Float {
		return other - self;
	}
	
	public func stride(# through: Float, by: Float) -> ISequence<Float> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i <= through {
			__yield i;
			i += by
		}
	}

	// workaround for 74743: Android app fails to run with SBL methods ovewrloaded by name only
	#if NOUGAT
	public func stride(# to: Float, by: Float) -> ISequence<Float> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i < to {
			__yield i;
			i += by
		}
	}
	#endif
}

public extension Double {
	
	// Strideable

	func advancedBy(n: Double) -> Double {
		return self + n;
	}
	
	func distanceTo(other: Double) -> Double {
		return other - self;
	}
	
	public func stride(# through: Double, by: Double) -> ISequence<Double> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i <= through {
			__yield i;
			i += by
		}
	}

	// workaround for 74743: Android app fails to run with SBL methods ovewrloaded by name only
	#if !COOPER
	public func stride(# to: Double, by: Double) -> ISequence<Double> {
		precondition(by > 0, "'by' must be larger than zero")
		var i = self
		while i < to {
			__yield i;
			i += by
		}
	}
	#endif
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