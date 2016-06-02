
infix operator ... { precedence 135 associativity none } 
infix operator ..< { precedence 135 associativity none }

public typealias IIntervalType = IntervalType
public protocol IntervalType {

	associatedtype Bound : Comparable /*= Int*/

	@warn_unused_result func contains(_ value: Self.Bound) -> Bool
	@warn_unused_result func clamp(_ intervalToClamp: Self) -> Self
	//@warn_unused_result func overlaps<I : IntervalType where I.Bound == Bound>(_ other: I) -> Bool // E550 "Equals" constraints in "where" are not supported in Silver
																									 // E549 Open generic type aliases in protocols are not supported in Silver

	var isEmpty: Bool { get }
	var start: Self.Bound { get }
	var end: Self.Bound { get }
}

//74077: Allow GetSequence() to actually be used to implement ISequence
public class ClosedInterval/*<Bound: Comparable, Incrementable>*/ /*: IIntervalType*//*, ISequence<Bound>*/ {
	
	typealias Bound = Int64
	//
	// Initializers
	//
	
	init(_ x: ClosedInterval/*<Bound>*/) {
		start = x.start
		end = x.end
	}
	
	init(_ start: Bound, _ end: Bound) {
		self.start = start
		self.end = end
	}
	
	//
	// Properties
	//
	
	#if NOUGAT
	override var description: String! {
	#else
	public var description: String {
	#endif
		return "\(start)...\(end)"
	}

	#if NOUGAT
	override var debugDescription: String! {
	#else
	public var debugDescription: String {
		#endif
		return "ClosedInterval(\(String(reflecting: start))...\(String(reflecting: end)))"
	}
	
	public let end: Bound
	public let start: Bound

	public var isEmpty: Bool {
		return false
	}
	
	//
	// Methods
	//
	
	@warn_unused_result func clamp(_ intervalToClamp: ClosedInterval/*<Bound>*/) -> ClosedInterval/*<Bound>*/ {
	// @warn_unused_result func clamp(_ intervalToClamp: IIntervalType<Bound>) -> IIntervalType<Bound> {
		return ClosedInterval/*<Bound>*/(
		  self.start > intervalToClamp.start ? self.start : self.end < intervalToClamp.start ? self.end : intervalToClamp.start,
		  self.end < intervalToClamp.end ? self.end : self.start > intervalToClamp.end ? self.start : intervalToClamp.end
		)
	}
	
	@warn_unused_result func contains(_ x: Bound) -> Bool {
		return x >= start && x <= end
	}
	
	//
	// Subscripts & Iterators
	//
	
	public func GetSequence() -> ISequence<Bound> {
		var i = start
		while i <= end {
			__yield i
			i = i+1//.successor()
		}
	}
}

//74077: Allow GetSequence() to actually be used to implement ISequence
public class HalfOpenInterval/*<Bound: Comparable>*/ /*: IIntervalType*//*, ISequence<Bound>*/ {

	typealias Bound = Int64 // for now

	//
	// Initializers
	//
	
	init(_ x: HalfOpenInterval/*<Bound>*/) {
		self.start = x.start
		self.end = x.end
	}
	
	init(_ start: Bound, _ end: Bound) {
		self.start = start
		self.end = end
	}
	
	//
	// Properties
	//
	
	#if NOUGAT
	override var description: String! {
	#else
	public var description: String {
	#endif
		return "\(start)..<\(end)"
	}

	#if NOUGAT
	override var debugDescription: String! {
	#else
	public var debugDescription: String {
		#endif
		return "HalfOpenInterval(\(String(reflecting: start))..<\(String(reflecting: end)))"
	}
	
	public let end: Bound
	public let start: Bound

	public var isEmpty: Bool {
		return end <= start
	}
	
	//
	// Methods
	//
	
	@warn_unused_result func clamp(_ intervalToClamp: HalfOpenInterval/*<Bound>*/) -> HalfOpenInterval/*<Bound>*/ {
	//@warn_unused_result func clamp(_ intervalToClamp: IIntervalType<Bound>) -> IIntervalType<Bound> {
		return HalfOpenInterval/*<Bound>*/(
		  self.start > intervalToClamp.start ? self.start : self.end < intervalToClamp.start ? self.end : intervalToClamp.start,
		  self.end < intervalToClamp.end ? self.end : self.start > intervalToClamp.end ? self.start : intervalToClamp.end
		)
	}
	
	@warn_unused_result func contains(_ x: Bound) -> Bool {
		return x >= start && x < end
	}
	
	//
	// Subscripts & Iterators
	//
	
	public func GetSequence() -> ISequence<Bound> {
		var i = start
		while i < end {
			__yield i
			i += 1
		}
	}
}