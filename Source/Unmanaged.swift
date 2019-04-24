#if DARWIN
public struct Unmanaged<Instance> where Instance : AnyObject {

	#if ISLAND
	func autorelease() -> Unmanaged<Instance> {
		CFAutorelease(opaque)
		return self
	}
	func release() {
		CFRelease(opaque)
	}
	func retain() -> Unmanaged<Instance> {
		CFRetain(opaque)
		return self
	}
	#endif

	func takeRetainedValue() -> Instance {
		return bridge<Instance>(opaque, BridgeMode.Bridge)
	}

	func takeUnretainedValue() -> Instance {
		return bridge<Instance>(opaque, BridgeMode.Transfer)
	}

	func toOpaque() -> OpaquePointer {
		return opaque
	}

	static func fromOpaque(_ value: OpaquePointer) -> Unmanaged<Instance> {
		Unmanaged<Instance>(with: value)
	}
	static func passRetained(_ value: Instance) -> Unmanaged<Instance> {
		Unmanaged<Instance>(retained: value)
	}
	static func passUnretained(_ value: Instance) -> Unmanaged<Instance> {
		Unmanaged<Instance>(unretained: value)
	}

	private let opaque: OpaquePointer

	private init(with value: OpaquePointer) {
		opaque = value
	}

	private init(withRetained value: Instance) {
		opaque = bridge<OpaquePointer>(value, BridgeMode.Retained)
	}

	private init(withUnretained value: Instance) {
		opaque = bridge<OpaquePointer>(value, BridgeMode.Bridge)
	}
}
#endif