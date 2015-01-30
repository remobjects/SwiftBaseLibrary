
public func println(object: Any? = nil) {
	if let unwrappedObject = object {
		writeLn(unwrappedObject)
	} else {
		writeLn()
	}
}

public func print(object: Any? = nil) {
	if let unwrappedObject = object {
		write(unwrappedObject)
	} 
}

//func fatalError(_ message: @autoclosure () -> String = default, file: String = __FILE__, line: UInt32 = __LINE__) { 70964: Silver: support __LINE__ and __FILE__ as default parameter value
func fatalError(_ message: @autoclosure () -> String = default, file: String = default, line: UInt32 = default) {
	if let message = message {
		__throw Exception(message()+", file "+file+", line "+line)
	} else {
		__throw Exception("Fatal Error, file "+file+", line "+line)
	}
}
