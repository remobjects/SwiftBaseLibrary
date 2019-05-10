#if !JAVA
public extension OpaquePointer {

	//init<T>(_ pointer: UnsafePointer<T>) {

	//}
	//init<T>(_ pointer: UnsafeMutablePointer<T>) {

	//}
	//init?<T>(_ pointer: UnsafePointer<T>?) {

	//}
	//init?<T>(_ pointer: UnsafeMutablePointer<T>?) {

	//}
	init(_ pointer: UnsafeRawPointer?) {
		return pointer
	}
	init?(bitPattern: Int) {
		return bitPattern as! OpaquePointer
	}
	init?(bitPattern: UInt) {
		return bitPattern as! OpaquePointer
	}

	//@ToString // E201 Attributes of type "ToStringAspect!" are not allowed on this member
	var description: String {
		return "0x"+(self as! UInt).toHexString()
	}

	var debugDescription: String {
		return "0x"+(self as! UInt).toHexString()
	}

	//func hash(into: inout Hasher) {

	//}
	//static func != (_ rhs: OpaquePointer, _lhs: OpaquePointer) -> Bool {
		// handled by compiler
	//}
	//static func == (OpaquePointer, OpaquePointer) -> Bool {
		// handled by compiler
	//}
}

#endif