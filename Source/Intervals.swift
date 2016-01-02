
public typealias IntervalType<Bound> = IIntervalType<Bound>
public protocol IIntervalType {

  typealias Bound//:  Comparable

  @warn_unused_result func contains(value: Int/*Bound*/) -> Bool
  @warn_unused_result func clamp(intervalToClamp: IIntervalType<Bound>/*Self*/) -> IIntervalType<Bound>/*Self*/

  var isEmpty: Bool { get }
  var start: Int/*Bound*/ { get }
  var end: Int/*Bound*/ { get }
}

//74077: Allow GetSequence() to actually be used to implement ISequence
public class ClosedInterval/*<Bound:Comparable>*/ : IIntervalType<Int>/*, ISequence<Int>*/ {
	
	typealias Bound = Int // for now
	
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
	
	//@warn_unused_result func clamp(_ intervalToClamp: ClosedInterval<Bound>) -> ClosedInterval<Bound> {
	@warn_unused_result func clamp(_ intervalToClamp: IIntervalType<Bound>) -> IIntervalType<Bound> {
		return ClosedInterval/*<Bound>*/(
		  self.start > intervalToClamp.start ? self.start
			: self.end < intervalToClamp.start ? self.end
			: intervalToClamp.start,
		  self.end < intervalToClamp.end ? self.end
			: self.start > intervalToClamp.end ? self.start
			: intervalToClamp.end
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
			i += 1
		}
	}
}

//74077: Allow GetSequence() to actually be used to implement ISequence
public class HalfOpenInterval : IIntervalType<Int>/*, ISequence<Int>*/ {

	typealias Bound = Int // for now

	//
	// Initializers
	//
	
	init(_ x: HalfOpenInterval) {
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
	
	//@warn_unused_result func clamp(_ intervalToClamp: HalfOpenInterval<Bound>) -> HalfOpenInterval<Bound> {
	@warn_unused_result func clamp(_ intervalToClamp: IIntervalType<Bound>) -> IIntervalType<Bound> {
		return HalfOpenInterval/*<Bound>*/(
		  self.start > intervalToClamp.start ? self.start
			: self.end < intervalToClamp.start ? self.end
			: intervalToClamp.start,
		  self.end < intervalToClamp.end ? self.end
			: self.start > intervalToClamp.end ? self.start
			: intervalToClamp.end
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