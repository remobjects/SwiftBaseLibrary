
public extension UInt8 {
	public static let max: UInt8 = 0xff
	public static let min: UInt8 = 0
	public static let allZeros: UInt8 = 0
}

public extension UInt16 {
	public static let max: UInt16 = 0xffff
	public static let min: UInt16 = 0
	public static let allZeros: UInt8 = 0
}

public extension UInt32 {
	public static let max: UInt32 = 0xffff_ffff
	public static let min: UInt32 = 0
	public static let allZeros: UInt8 = 0
}

public extension UInt64 {
	public static let max: UInt64 = 0xffff_ffff_ffff_ffff
	public static let min: UInt64 = 0
	public static let allZeros: UInt8 = 0
}

public extension Int8 {
	public static let max: Int8 = 0x7f
	public static let min: Int8 = -0x80
	public static let allZeros: UInt8 = 0
}

public extension Int16 {
	public static let max: Int16 = 0x7fff
	public static let min: Int16 = -0x8000
	public static let allZeros: UInt8 = 0
}

public extension Int32 {
	public static let max: Int32 =  2147483647 //  0x7fff ffff
	public static let min: Int32 = -2147483648 // -0x8000_0000
	public static let allZeros: UInt8 = 0
}

public extension Int64 {
	public static let max: Int64 =  9223372036854775807 //  0x7fff_ffff_ffff_ffff
	public static let min: Int64 = -9223372036854775808 // -0x8000_0000_0000_0000
	public static let allZeros: UInt8 = 0
}

// Equatable, Comparable, Incrementable, SignedNumberType, SignedIntegerType, IntegerArithmeticType, ForwardIndexType */

public extension Int32  {

	// Range Operators

	public func ... (a: Int32, b: Int32) -> Range/*<Int32>*/ {
		return Range/*<Int32>*/(a, b, closed: true)
	}

	public func ... (a: Int64, b: Int32) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(a, b, closed: true)
	}

	public func ... (a: Int32, b: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(a, b, closed: true)
	}

	public func ..< (a: Int32, b: Int32) -> Range/*<Int32>*/ {
		return Range/*<Int64>*//*<Int32>*/(a, b, closed: false)
	}

	public func ..< (a: Int64, b: Int32) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(a, b, closed: false)
	}

	public func ..< (a: Int32, b: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(a, b, closed: false)
	}

	public func >.. (a: Int32, b: Int32) -> Range/*<Int32>*/ {
		return Range/*<Int64>*//*<Int32>*/(b, a, closed: false, reversed: true)
	}

	public func >.. (a: Int64, b: Int32) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(b, a, closed: false, reversed: true)
	}

	public func >.. (a: Int32, b: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(b, a, closed: false, reversed: true)
	}

	public prefix func ... (b: Int32) -> Range/*<Int32>*/ {
		return Range/*<Int32>*/(nil, b, closed: true)
	}

	public prefix func ..< (b: Int32) -> Range/*<Int32>*/ {
		return Range/*<Int64>*//*<Int32>*/(nil, b, closed: false)
	}

	public postfix func >.. (b: Int32) -> Range/*<Int32>*/ {
		return Range/*<Int64>*//*<Int32>*/(b, nil, closed: false, reversed: true)
	}

	public postfix func ... (a: Int32) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(a, nil, closed: true)
	}

	//public postfix func ..< (a: Int32) -> Range/*<Int32>*/ {
		//return Range/*<Int64>*//*<Int32>*/(a, nil, closed: false)
	//}
}

public extension Int32 /*: AbsoluteValuable*/ {

	static func abs(_ x: Self) -> Self {
		#if JAVA
		return Int32.abs(x)
		#elseif CLR || ISLAND
		return Math.Abs(x)
		#elseif COCOA
		return ABS(x)
		#endif
	}
}

public extension Int32 /*: Strideable*/ {

	func advancedBy(_ n: Int32) -> Int32 {
		return self + n;
	}

	func distanceTo(_ other: Int32) -> Int32 {
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
	#if COCOA
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

	// Range Operators

	public func ... (a: Int64, b: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(a, b, closed: true)
	}

	public func ..< (a: Int64, b: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(a, b, closed: false)
	}

	public func >.. (a: Int64, b: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(b, a, closed: false, reversed: true)
	}

	public prefix func ... (b: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(nil, b, closed: true)
	}

	public prefix func ..< (b: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(nil, b, closed: false)
	}

	public postfix func >.. (b: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(b, nil, closed: false, reversed: true)
	}

	public postfix func ... (a: Int64) -> Range/*<Int64>*/ {
		return Range/*<Int64>*/(a, nil, closed: true)
	}

	//public postfix func ..< (a: Int64) -> Range/*<Int64>*/ {
		//return Range/*<Int64>*/(a, nil, closed: false)
	//}

	// Strideable

	func advancedBy(_ n: Int64) -> Int64 {
		return self + n;
	}

	func distanceTo(_ other: Int64) -> Int64 {
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
	#if !JAVA
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

	func advancedBy(_ n: Float) -> Float {
		return self + n;
	}

	func distanceTo(_ other: Float) -> Float {
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
	#if COCOA
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

	func advancedBy(_ n: Double) -> Double {
		return self + n;
	}

	func distanceTo(_ other: Double) -> Double {
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
	#if !JAVA
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

	internal func toHexString(# length: Int = 8) -> NativeString {
		#if JAVA
		return NativeString.format("%0\(length)x", self)
		#elseif CLR || ISLAND
		return NativeString.Format("{0:x\(length)}", self)
		#elseif COCOA
		return NativeString(format: "%0\(length)llx", self)
		#endif
	}
}

public extension UInt32 {

	internal func toHexString(# length: Int = 4) -> NativeString {
		#if JAVA
		return NativeString.format("%0\(length)x", self)
		#elseif CLR || ISLAND
		return NativeString.Format("{0:x\(length)}", self)
		#elseif COCOA
		return NativeString(format: "%0\(length)llx", self)
		#endif
	}
}