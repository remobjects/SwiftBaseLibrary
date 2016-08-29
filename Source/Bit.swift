/// A `RandomAccessIndexType` that has two possible values.  Used as
/// the `Index` type for `CollectionOfOne<T>`.
public enum Bit { //: Int32, ForwardIndexType<Distance> { //, Comparable, RandomAccessIndexType, _Reflectable { // 74094: Silver: interfaces on enums

	//associatedtype typealias /*Distance*/ = Int // 74095: Silver: cant use type alias in an enum

	case Zero = 0, One = 1

	/// Returns the next consecutive value after `self`.
	///
	/// - Requires: `self == .Zero`.
	public func successor() -> Bit {
		precondition(self == .Zero, "Can't increment past one")
		return .One
	}

	/// Returns the previous consecutive value before `self`.
	///
	/// - Requires: `self != .Zero`.
	public func predecessor() -> Bit {
		precondition(self == .One, "Can't decrement past zero")
		return .Zero
	}

	//74097: Silver: cant access "rawValue" in enum
	/*public func distanceTo(other: Bit) -> Int {
		return rawValue.distanceTo(other.rawValue)
	}

	public func advancedBy(n: Int/*Distance*/) -> Bit {
		return rawValue.advancedBy(n) > 0 ? One : Zero
	}*/

	//#if COCOA
	//override var debugDescription: String! {
	//#else
	public var debugDescription: String {
	//#endif
		var result = "Bit("
		switch self {
			case .Zero: result += ".Zero"
			case .One:  result += ".One"
		}
		result += ")"
		return result
	}
}

@warn_unused_result
public func == (lhs: Bit, rhs: Bit) -> Bool {
	return lhs.rawValue == rhs.rawValue
}

@warn_unused_result
public func < (lhs: Bit, rhs: Bit) -> Bool {
	return lhs.rawValue < rhs.rawValue
}

/*
extension Bit : IntegerArithmeticType {
	static func _withOverflow(
	intResult: Int, overflow: Bool
	) -> (Bit, overflow: Bool) {
		if let bit = Bit(rawValue: intResult) {
			return (bit, overflow: overflow)
		} else {
			let bitRaw = intResult % 2 + (intResult < 0 ? 2 : 0)
			let bit = Bit(rawValue: bitRaw)!
			return (bit, overflow: true)
		}
	}

	/// Add `lhs` and `rhs`, returning a result and a `Bool` that is
	/// true iff the operation caused an arithmetic overflow.
	public static func addWithOverflow(
	lhs: Bit, _ rhs: Bit
	) -> (Bit, overflow: Bool) {
		return _withOverflow(Int.addWithOverflow(lhs.rawValue, rhs.rawValue))
	}

	/// Subtract `lhs` and `rhs`, returning a result and a `Bool` that is
	/// true iff the operation caused an arithmetic overflow.
	public static func subtractWithOverflow(
	lhs: Bit, _ rhs: Bit
	) -> (Bit, overflow: Bool) {
		return _withOverflow(Int.subtractWithOverflow(lhs.rawValue, rhs.rawValue))
	}

	/// Multiply `lhs` and `rhs`, returning a result and a `Bool` that is
	/// true iff the operation caused an arithmetic overflow.
	public static func multiplyWithOverflow(
	lhs: Bit, _ rhs: Bit
	) -> (Bit, overflow: Bool) {
		return _withOverflow(Int.multiplyWithOverflow(lhs.rawValue, rhs.rawValue))
	}

	/// Divide `lhs` and `rhs`, returning a result and a `Bool` that is
	/// true iff the operation caused an arithmetic overflow.
	public static func divideWithOverflow(
	lhs: Bit, _ rhs: Bit
	) -> (Bit, overflow: Bool) {
		return _withOverflow(Int.divideWithOverflow(lhs.rawValue, rhs.rawValue))
	}

	/// Divide `lhs` and `rhs`, returning the remainder and a `Bool` that is
	/// true iff the operation caused an arithmetic overflow.
	public static func remainderWithOverflow(
	lhs: Bit, _ rhs: Bit
	) -> (Bit, overflow: Bool) {
		return _withOverflow(Int.remainderWithOverflow(lhs.rawValue, rhs.rawValue))
	}

	/// Represent this number using Swift's widest native signed integer
	/// type.
	public func toIntMax() -> IntMax {
		return IntMax(rawValue)
	}
}
*/