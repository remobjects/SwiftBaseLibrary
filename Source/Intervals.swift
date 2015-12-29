
public typealias IntervalType<Bound> = IIntervalType<Bound>
public protocol IIntervalType {

  typealias Bound//:  Comparable

  @warn_unused_result func contains(value: IntMax/*Bound*/) -> Bool
  @warn_unused_result func clamp(intervalToClamp: IIntervalType<Bound>/*Self*/) -> IIntervalType<Bound>/*Self*/

  var isEmpty: Bool { get }
  var start: IntMax/*Bound*/ { get }
  var end: IntMax/*Bound*/ { get }
}

public class ClosedInterval/*<Bound:Comparable>*/ : IIntervalType<IntMax> {
	
	typealias Bound = IntMax // for now
	
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
	
	public /*let*/var end: Bound // 74076: Silver: cannot init "let" field from init()
	public /*let*/var start: Bound // 74076: Silver: cannot init "let" field from init()

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

public class HalfOpenInterval : IIntervalType<IntMax> {

	typealias Bound = IntMax // for now

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
	
	public /*let*/var end: Bound // 74076: Silver: cannot init "let" field from init()
	public /*let*/var start: Bound // 74076: Silver: cannot init "let" field from init()

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