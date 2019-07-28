#if COCOA || DARWIN

public public enum DispatchPredicate {
	case onQueue(DispatchQueue)
	case onQueueAsBarrier(DispatchQueue)
	case notOnQueue(DispatchQueue)
}

public class DispatchObject {

	internal init(rawValue: dispatch_object_t) {
		self.object = rawValue
	}

	let object: dispatch_object_t

	func suspend() {
		dispatch_suspend(object)
	}
	func resume() {
		dispatch_resume(object)
	}
	func setTargetQueue(queue: DispatchQueue?) {
		if let queue = queue {
			dispatch_set_target_queue(object, queue.queue)
		} else {
			 // what?
		}
	}
}

public class DispatchGroup : DispatchObject {
	public init() {
		#if OLD_DEPLOYMENT_TARGET
		var temp: dispatch_object_t
		temp._dg = dispatch_group_create()
		super.init(rawValue: temp)
		#else
		super.init(rawValue: dispatch_group_create())
		#endif
	}

	var group: dispatch_group_t {
		#if OLD_DEPLOYMENT_TARGET
		return object._dg
		#else
		return object as! dispatch_group_t
		#endif
	}


	/*
	func wait(timeout: DispatchTime /*= default*/) -> Int {
		return dispatch_wait(group, timeout.rawValue)
	}

	func wait(walltime timeout: DispatchWallTime) -> Int {
		return dispatch_wait(group, timeout.rawValue)
	}

	func notify(queue: DispatchQueue, execute block: () -> ()) {
		dispatch_notify(group, queue.object, block)
	}
	*/

	func enter() {
		dispatch_group_enter(group)
	}

	func leave() {
		dispatch_group_leave(group)
	}
}

public class DispatchQueue : DispatchObject {
	public struct Attributes {
		public let rawValue: dispatch_queue_attr_t
		public init(rawValue: dispatch_queue_attr_t) {
			self.rawValue = rawValue
		}
		public static let serial: Attributes = Attributes(rawValue: DISPATCH_QUEUE_SERIAL)
		public static let concurrent: Attributes = Attributes(rawValue: DISPATCH_QUEUE_CONCURRENT)
	}

	public enum AutoreleaseFrequency {
		case inherit
		// case never
		// case workItem
	}

	internal init(queue: dispatch_queue_t) {
		#if OLD_DEPLOYMENT_TARGET
		var temp: dispatch_object_t
		temp._dq = queue
		super.init(rawValue: temp)
		#else
		super.init(rawValue: queue)
		#endif
	}

	public static func __implicit(_ queue: DispatchQueue?) -> dispatch_queue_t? {
		if let queue = queue {
			return queue.queue
		} else {
			return nil
		}
	}

	public static func __implicit(_ queue: dispatch_queue_t?) -> DispatchQueue? {
		if let queue = queue {
			return DispatchQueue(queue: queue)
		} else {
			return nil
		}
	}

	internal convenience init(__label: String, attr: dispatch_queue_attr_t?, queue: DispatchQueue?) {
		var raw: dispatch_queue_t
		if #defined(COCOA) {
			raw = dispatch_queue_create_with_target(__label.UTF8String, attr, queue?.queue)
		} else if #defined(DARWIN) {
			let array = Encoding.UTF8.GetBytes(__label+"\0")
			raw = dispatch_queue_create_with_target((&array[0]) as! UnsafePointer<AnsiChar>, attr, queue?.queue)
		}
		self.init(queue: raw)
	}

	public convenience init(label: String, target: DispatchQueue? = nil) {
		self.init(__label: label, attr: nil, queue: target)
	}

	public var queue: dispatch_queue_t {
		#if OLD_DEPLOYMENT_TARGET
		return object._dq
		#else
		return object as! dispatch_queue_t
		#endif
	}

	public var label: String {
		if #defined(COCOA) {
			return NSString.stringWithUTF8String(dispatch_queue_get_label(queue))
		} else if #defined(DARWIN) {
			let label = dispatch_queue_get_label(queue)
			let len = strlen(label)
			let array = Byte[](len)
			memcpy(array, label, len)
			return Encoding.UTF8.GetString(array)
		}
	}

	public lazy class var main: DispatchQueue = DispatchQueue(queue: dispatch_get_main_queue())

	public class func global(qos: DispatchQoS.QoSClass = .default) -> DispatchQueue {
		let raw = dispatch_get_global_queue(Int(qos.rawValue), 0)
		return DispatchQueue(queue: raw)
	}

	public func asyncAfter(deadline: DispatchTime, execute work: () -> ()) {
		dispatch_after(deadline.rawValue, self.queue, work)
	}

	public func asyncAfter(wallDeadline: DispatchWallTime, execute work: () -> ()) {
		dispatch_after(wallDeadline.rawValue, self.queue, work)
	}

	public func concurrentPerform(iterations: Int, execute work: (UInt) -> ()) {
		dispatch_apply(iterations, self.queue, work)
	}

	public func async(execute work: () -> ()) {
		dispatch_async(self.queue, work)
	}

	public func async(group: DispatchGroup?, execute work: () -> ()) {
		if group != nil {
			dispatch_group_async(group!.group, self.queue, work)
		} else {
			dispatch_async(self.queue, work)
		}
	}

	public func sync(execute work: () -> ()) {
		dispatch_sync(self.queue, work)
	}

	#if !ISLAND
	public func sync<T>(execute work: () throws -> T) rethrows -> T {
		var result: T
		var e: AnyObject?
		dispatch_sync(queue) {
			do {
				result = try! work()
			} catch {
				e = error
			}
		}
		if let error = e {
			throw error
		}
		return result
	}
	#endif

	/*var qos: DispatchQoS {
		var priority: Int
		//let qos = dispatch_queue_get_qos_class(rawValue, &priority) // E486 Parameter 2 is "Int", should be "UnsafePointer<Int32>", in call to rtl.dispatch_queue_get_qos_class(_ queue: dispatch_queue_t!, _ relative_priority_ptr: UnsafePointer<Int32>) -> qos_class_t
		//return DispatchQoS(qosClass: qos, relativePriority: priority)
	}*/
	/*class func getSpecific<T>(key: DispatchSpecificKey<T>) -> T? {
	}*/

	/*func getSpecific<T>(key: DispatchSpecificKey<T>) -> T? {
		//return dispatch_queue_get_specific(rawValue, key)
	}
	func setSpecific<T>(key: DispatchSpecificKey<T>, value: T) {
		//return dispatch_queue_set_specific(rawValue, key, value)
	}*/
}

func dispatchMain() -> Never {
	dispatch_main()
}

//
//
//

public class DispatchWorkItem {
	public init(group: DispatchGroup/*?*/ /*= default*/, qos: DispatchQoS /*= default*/, flags: DispatchWorkItemFlags /*= default*/, execute block: () -> ()) {
		self.block = block
		self.group = group
	}

	private let block: () -> ()
	private let group: DispatchGroup/*?*/

	public func perform() {
		block()
	}

	/*func wait(timeout: DispatchTime /*= default*/) -> Int {
		//return dispatch_wait(group.group, timeout.rawValue)
	}

	func wait(timeout: DispatchWallTime) -> Int {
		//return dispatch_wait(group.group, timeout.rawValue)
	}

	func notify(queue: DispatchQueue, execute notifyBlock: /*@convention(block)*/ () -> Void) {
		//dispatch_notify(group.group, queue.object, notifyBlock)
	}*/

	public func cancel() {
	}

	/*var isCancelled: Bool { get }*/
}

public struct DispatchWorkItemFlags /*: OptionSet, RawRepresentable*/ {
	let rawValue: UInt
	public init(rawValue: UInt) {
		self.rawValue = rawValue
	}
	//static let barrier: DispatchWorkItemFlags
	//static let detached: DispatchWorkItemFlags
	//static let assignCurrentContext: DispatchWorkItemFlags
	//static let noQoS: DispatchWorkItemFlags
	//static let inheritQoS: DispatchWorkItemFlags
	//static let enforceQoS: DispatchWorkItemFlags
	typealias Element = DispatchWorkItemFlags
	typealias RawValue = UInt
}

/*class DispatchSemaphore : DispatchObject {
	public init(value: Int) {
	}
	func wait(timeout: DispatchTime /*= default*/) -> Int {
	}
	func wait(walltime timeout: DispatchWallTime) -> Int {
	}
	func signal() -> Int {
	}
}*/

class DispatchSource : DispatchObject {
	public struct MachSendEvent /*: OptionSet, RawRepresentable*/ {
		let rawValue: UInt
		public init(rawValue: UInt) {
			self.rawValue = rawValue
		}
		//static let dead: DispatchSource.MachSendEvent// = MachSendEvent(rawValue: DISPATCH_SOURCE_TYPE_MACH_SEND())
		typealias Element = DispatchSource.MachSendEvent
		typealias RawValue = UInt
	}
	public struct MemoryPressureEvent /*: OptionSet, RawRepresentable*/ {
		let rawValue: UInt
		public init(rawValue: UInt) {
			self.rawValue = rawValue
		}
		//static let normal: DispatchSource.MemoryPressureEvent
		//static let warning: DispatchSource.MemoryPressureEvent
		//static let critical: DispatchSource.MemoryPressureEvent
		//static let all: DispatchSource.MemoryPressureEvent
		typealias Element = DispatchSource.MemoryPressureEvent
		typealias RawValue = UInt
	}
	public struct ProcessEvent /*: OptionSet, RawRepresentable*/ {
		let rawValue: UInt
		public init(rawValue: UInt) {
			self.rawValue = rawValue
		}
		//static let exit: DispatchSource.ProcessEvent
		//static let fork: DispatchSource.ProcessEvent
		//static let exec: DispatchSource.ProcessEvent
		//static let signal: DispatchSource.ProcessEvent
		//static let all: DispatchSource.ProcessEvent
		typealias Element = DispatchSource.ProcessEvent
		typealias RawValue = UInt
	}
	public struct TimerFlags /*: OptionSet, RawRepresentable*/ {
		let rawValue: UInt
		public init(rawValue: UInt) {
			self.rawValue = rawValue
		}
		//static let strict: DispatchSource.TimerFlags
		typealias Element = DispatchSource.TimerFlags
		typealias RawValue = UInt
	}
	public struct FileSystemEvent /*: OptionSet, RawRepresentable*/ {
		let rawValue: UInt
		public init(rawValue: UInt) {
			self.rawValue = rawValue
		}
		//static let delete: DispatchSource.FileSystemEvent
		//static let write: DispatchSource.FileSystemEvent
		//static let extend: DispatchSource.FileSystemEvent
		//static let attrib: DispatchSource.FileSystemEvent
		//static let link: DispatchSource.FileSystemEvent
		//static let rename: DispatchSource.FileSystemEvent
		//static let revoke: DispatchSource.FileSystemEvent
		//static let all: DispatchSource.FileSystemEvent
		typealias Element = DispatchSource.FileSystemEvent
		typealias RawValue = UInt
	}
/*    class func machSend(port: mach_port_t, eventMask: DispatchSource.MachSendEvent, queue: DispatchQueue? /*= default*/) -> DispatchSourceMachSend {
	}
	class func machReceive(port: mach_port_t, queue: DispatchQueue? /*= default*/) -> DispatchSourceMachReceive {
	}
	class func memoryPressure(eventMask: DispatchSource.MemoryPressureEvent, queue: DispatchQueue? /*= default*/) -> DispatchSourceMemoryPressure {
	}
	class func process(identifier: pid_t, eventMask: DispatchSource.ProcessEvent, queue: DispatchQueue? /*= default*/) -> DispatchSourceProcess {
	}
	class func read(fileDescriptor: Int32, queue: DispatchQueue? /*= default*/) -> DispatchSourceRead {
	}
	class func signal(signal: Int32, queue: DispatchQueue? /*= default*/) -> DispatchSourceSignal {
	}
	class func timer(flags: DispatchSource.TimerFlags /*= default*/, queue: DispatchQueue? /*= default*/) -> DispatchSourceTimer {
	}
	class func userDataAdd(queue: DispatchQueue? /*= default*/) -> DispatchSourceUserDataAdd {
	}
	class func userDataOr(queue: DispatchQueue? /*= default*/) -> DispatchSourceUserDataOr {
	}
	class func fileSystemObject(fileDescriptor: Int32, eventMask: DispatchSource.FileSystemEvent, queue: DispatchQueue? /*= default*/) -> DispatchSourceFileSystemObject {
	}
	class func write(fileDescriptor: Int32, queue: DispatchQueue? /*= default*/) -> DispatchSourceWrite {
	}
*/
}


protocol DispatchSourceType /*: NSObjectProtocol*/ {
	// 75299: Swift: compiler confused about `typealias` in protocol
	typealias DispatchSourceHandler = /*@convention(block)*/ () -> Void
	func setEventHandler(handler: DispatchSourceHandler?)
	func setCancelHandler(handler: DispatchSourceHandler?)
	func setRegistrationHandler(handler: DispatchSourceHandler?)
	func cancel()
	func resume()
	func suspend()
	var handle: UInt { get }
	var mask: UInt { get }
	var data: UInt { get }
	var isCancelled: Bool { get }
}
/*extension DispatchSource : DispatchSourceType {
}*/
protocol DispatchSourceUserDataAdd : DispatchSourceType {
	func mergeData(value: UInt)
}
/*extension DispatchSource : DispatchSourceUserDataAdd {
}*/
protocol DispatchSourceUserDataOr : DispatchSourceType {
	func mergeData(value: UInt)
}
/*extension DispatchSource : DispatchSourceUserDataOr {
}*/
protocol DispatchSourceMachSend : DispatchSourceType {
  var handle: mach_port_t { get }
  var data: DispatchSource.MachSendEvent { get }
  var mask: DispatchSource.MachSendEvent { get }
}
/*extension DispatchSource : DispatchSourceMachSend {
}*/
protocol DispatchSourceMachReceive : DispatchSourceType {
  var handle: mach_port_t { get }
}
/*extension DispatchSource : DispatchSourceMachReceive {
}*/
protocol DispatchSourceMemoryPressure : DispatchSourceType {
  var data: DispatchSource.MemoryPressureEvent { get }
  var mask: DispatchSource.MemoryPressureEvent { get }
}
/*extension DispatchSource : DispatchSourceMemoryPressure {
}*/
protocol DispatchSourceProcess : DispatchSourceType {
  var handle: pid_t { get }
  var data: DispatchSource.ProcessEvent { get }
  var mask: DispatchSource.ProcessEvent { get }
}
/*extension DispatchSource : DispatchSourceProcess {
}*/
protocol DispatchSourceRead : DispatchSourceType {
}
/*extension DispatchSource : DispatchSourceRead {
}*/
protocol DispatchSourceSignal : DispatchSourceType {
}
/*extension DispatchSource : DispatchSourceSignal {
}*/
protocol DispatchSourceTimer : DispatchSourceType {
  func setTimer(start: DispatchTime, leeway: DispatchTimeInterval /*= default*/)
  func setTimer(walltime start: DispatchWallTime, leeway: DispatchTimeInterval /*= default*/)
  func setTimer(start: DispatchTime, interval: DispatchTimeInterval, leeway: DispatchTimeInterval /*= default*/)
  func setTimer(start: DispatchTime, interval: Double, leeway: DispatchTimeInterval /*= default*/)
  func setTimer(walltime start: DispatchWallTime, interval: DispatchTimeInterval, leeway: DispatchTimeInterval /*= default*/)
  func setTimer(walltime start: DispatchWallTime, interval: Double, leeway: DispatchTimeInterval /*= default*/)
}
/*extension DispatchSource : DispatchSourceTimer {
}*/
protocol DispatchSourceFileSystemObject : DispatchSourceType {
  var handle: Int32 { get }
  var data: DispatchSource.FileSystemEvent { get }
  var mask: DispatchSource.FileSystemEvent { get }
}
/*extension DispatchSource : DispatchSourceFileSystemObject {
}*/
protocol DispatchSourceWrite : DispatchSourceType {
}
/*extension DispatchSource : DispatchSourceWrite {
}*/
extension DispatchSourceMemoryPressure {
  //var data: DispatchSource.MemoryPressureEvent { get }
  //var mask: DispatchSource.MemoryPressureEvent { get }
}
/*extension DispatchSourceMachReceive {
  var handle: mach_port_t { get }
}*/
extension DispatchSourceFileSystemObject {
  //var handle: Int32 { get }
  //var data: DispatchSource.FileSystemEvent { get }
  //var mask: DispatchSource.FileSystemEvent { get }
}
extension DispatchSourceUserDataOr {
	func mergeData(value: UInt) {
	}
}
public struct DispatchData /*: RandomAccessCollection, _ObjectiveCBridgeable*/ {
	/*typealias Iterator = DispatchDataIterator
	typealias Index = Int
	typealias Indices = DefaultRandomAccessIndices<DispatchData>
	/*static*/ let empty: DispatchData // E492 Flag "static" not allowed on this member
	public enum Deallocator {
		case free
		case unmap
		case custom(DispatchQueue?, /*@convention(block)*/ () -> Void)
	}
	public init(bytes buffer: UnsafeBufferPointer<UInt8>) {
	}
	public init(bytesNoCopy bytes: UnsafeBufferPointer<UInt8>, deallocator: DispatchData.Deallocator /*= default*/) {
	}
	var count: Int { get }
	func withUnsafeBytes<Result, ContentType>(body: @noescape (UnsafePointer<ContentType>) throws -> Result) rethrows -> Result {
	}
	//func enumerateBytes(block: @noescape (buffer: UnsafeBufferPointer<UInt8>, byteIndex: Int, stop: inout Bool) -> Void) { // E1 closing parenthesis expected, got identifier
	func enumerateBytes(block: @noescape (buffer: UnsafeBufferPointer<UInt8>, byteIndex: Int, inout stop: Bool) -> Void) {
	}
	mutating func append(_ bytes: UnsafePointer<UInt8>, count: Int) {
	}
	mutating func append(_ other: DispatchData) {
	}
	mutating func append<SourceType>(_ buffer: UnsafeBufferPointer<SourceType>) {
	}
	func copyBytes(to pointer: UnsafeMutablePointer<UInt8>, count: Int) {
	}
	func copyBytes(to pointer: UnsafeMutablePointer<UInt8>, from range: CountableRange<Index>) {
	}
	func copyBytes<DestinationType>(to buffer: UnsafeMutableBufferPointer<DestinationType>, from range: CountableRange<Index>? /*= default*/) -> Int {
	}
	subscript(index: Index) -> UInt8 { get }
	subscript(bounds: Range<Int>) -> RandomAccessSlice<DispatchData> { get }
	func subdata(in range: CountableRange<Index>) -> DispatchData {
	}
	func region(location: Int) -> (data: DispatchData, offset: Int) {
	}
	var startIndex: Index { get }
	var endIndex: Index { get }
	func index(before i: Index) -> Index {
	}
	func index(after i: Index) -> Index {
	}
	func makeIterator() -> Iterator {
	}
	typealias IndexDistance = Int
	typealias _Element = UInt8
	typealias SubSequence = RandomAccessSlice<DispatchData>
	typealias _ObjectiveCType = __DispatchData*/
}
public struct DispatchDataIterator /*: IteratorProtocol, Sequence*/ {
	/*mutating func next() -> _Element? {
	}
	typealias Element = _Element
	typealias Iterator = DispatchDataIterator
	typealias SubSequence = AnySequence<_Element>*/
}

public struct DispatchQoS /*: Equatable*/ {
	public let qosClass: DispatchQoS.QoSClass
	public let relativePriority: Int
	public static let background: DispatchQoS      = DispatchQoS(qosClass: QoSClass.background)
	public static let utility: DispatchQoS         = DispatchQoS(qosClass: QoSClass.utility)
	public static let `default`: DispatchQoS       = DispatchQoS(qosClass: QoSClass.default)
	public static let userInitiated: DispatchQoS   = DispatchQoS(qosClass: QoSClass.userInitiated)
	public static let userInteractive: DispatchQoS = DispatchQoS(qosClass: QoSClass.userInteractive)
	public static let unspecified: DispatchQoS     = DispatchQoS(qosClass: QoSClass.unspecified)

	public enum QoSClass {
		case background = qos_class_t.QOS_CLASS_BACKGROUND
		case utility = qos_class_t.QOS_CLASS_UTILITY
		case `default` = qos_class_t.QOS_CLASS_DEFAULT
		case userInitiated = qos_class_t.QOS_CLASS_USER_INITIATED
		case userInteractive = qos_class_t.QOS_CLASS_USER_INTERACTIVE
		case unspecified = qos_class_t.QOS_CLASS_UNSPECIFIED
	}

	public init(qosClass: DispatchQoS.QoSClass, relativePriority: Int) {
		self.qosClass = qosClass
		self.relativePriority = relativePriority
	}

	private /*convenience*/ public init(qosClass: DispatchQoS.QoSClass) {
		// 75300: Swift: odd error about inaccessible ctor
		//self.public init(qosClass: qosClass, relativePriority: 0) // E152 No accessible constructors for type DispatchQoS
		self.qosClass = qosClass
		self.relativePriority = 0
	}
}

public infix func ==(a: DispatchQoS.QoSClass, b: DispatchQoS.QoSClass) -> Bool {  // why is this needed, don't enums == automatically?
	return a == b
}

public func ==(a: DispatchQoS, b: DispatchQoS) -> Bool {
	return a.qosClass == b.qosClass && a.relativePriority == b.relativePriority
}

public struct DispatchQueueAttributes /*: OptionSet*/ {
	public let rawValue: dispatch_queue_attr_t
	public init(rawValue: dispatch_queue_attr_t) {
		self.rawValue = rawValue
	}
	public static let serial: DispatchQueueAttributes = DispatchQueueAttributes(rawValue: DISPATCH_QUEUE_SERIAL)
	public static let concurrent: DispatchQueueAttributes = DispatchQueueAttributes(rawValue: DISPATCH_QUEUE_CONCURRENT)

	//static let qosUserInteractive: DispatchQueueAttributes
	//static let qosUserpublic initiated: DispatchQueueAttributes
	//static let qosDefault: DispatchQueueAttributes
	//static let qosUtility: DispatchQueueAttributes
	//static let qosBackground: DispatchQueueAttributes
	//static let noQoS: DispatchQueueAttributes
}

final class DispatchSpecificKey<T> {
	public init() {
	}
}

//
// Time
//

public struct DispatchTime {

	private public init(rawValue: dispatch_time_t) {
		self.rawValue = rawValue
	}

	public let rawValue: dispatch_time_t

	public static func now() -> DispatchTime {
		return DispatchTime(rawValue: dispatch_time(DISPATCH_TIME_NOW, 0))
	}
	public static lazy let distantFuture: DispatchTime = DispatchTime(rawValue: DISPATCH_TIME_FOREVER)

}
public struct DispatchWallTime {

	public init(rawValue: dispatch_time_t) {
		self.rawValue = rawValue
	}

	public let rawValue: dispatch_time_t

	public static func now() -> DispatchWallTime {
		return DispatchWallTime(rawValue: dispatch_walltime(nil, 0))
	}
	public static lazy let distantFuture: DispatchWallTime = DispatchWallTime(rawValue: DISPATCH_TIME_FOREVER)
}

public enum DispatchTimeInterval {
	case seconds(Int)
	case milliseconds(Int)
	case microseconds(Int)
	case nanoseconds(Int)
}

public prefix func -(interval: DispatchTimeInterval) -> DispatchTimeInterval {
	switch interval {
		case .seconds(let seconds):           return DispatchTimeInterval.seconds(-seconds)
		case .milliseconds(let milliseconds): return DispatchTimeInterval.seconds(-milliseconds)
		case .microseconds(let microseconds): return DispatchTimeInterval.seconds(-microseconds)
		case .nanoseconds(let nanoseconds):   return DispatchTimeInterval.seconds(-nanoseconds)
	}
}

public func +(time: DispatchTime, interval: DispatchTimeInterval) -> DispatchTime {
	switch interval {
		case .seconds(let seconds):           return DispatchTime(rawValue: dispatch_time(time.rawValue, seconds      * NSEC_PER_SEC))
		case .milliseconds(let milliseconds): return DispatchTime(rawValue: dispatch_time(time.rawValue, milliseconds * NSEC_PER_MSEC))
		case .microseconds(let microseconds): return DispatchTime(rawValue: dispatch_time(time.rawValue, microseconds * NSEC_PER_USEC))
		case .nanoseconds(let nanoseconds):   return DispatchTime(rawValue: dispatch_time(time.rawValue, nanoseconds))
	}
}
public func +(time: DispatchTime, seconds: Double) -> DispatchTime {
	return DispatchTime(rawValue: dispatch_time(time.rawValue, Int64(seconds*1_000_000_000.0)))
}

public func +(time: DispatchWallTime, interval: DispatchTimeInterval) -> DispatchWallTime {
	switch interval {
		case .seconds(let seconds):           return DispatchWallTime(rawValue: dispatch_time(time.rawValue, seconds      * NSEC_PER_SEC))
		case .milliseconds(let milliseconds): return DispatchWallTime(rawValue: dispatch_time(time.rawValue, milliseconds * NSEC_PER_MSEC))
		case .microseconds(let microseconds): return DispatchWallTime(rawValue: dispatch_time(time.rawValue, microseconds * NSEC_PER_USEC))
		case .nanoseconds(let nanoseconds):   return DispatchWallTime(rawValue: dispatch_time(time.rawValue, nanoseconds))
	}
}

public func +(time: DispatchWallTime, seconds: Double) -> DispatchWallTime {
	return DispatchWallTime(rawValue: dispatch_time(time.rawValue, Int64(seconds*NSEC_PER_SEC)))
}

public func -(time: DispatchTime, interval: DispatchTimeInterval) -> DispatchTime {
	return time + -interval
}

public func -(time: DispatchTime, seconds: Double) -> DispatchTime {
	return time + -seconds
}

public func -(time: DispatchWallTime, interval: DispatchTimeInterval) -> DispatchWallTime {
	return time + -interval
}

public func -(time: DispatchWallTime, seconds: Double) -> DispatchWallTime {
	return time + -seconds
}

#endif