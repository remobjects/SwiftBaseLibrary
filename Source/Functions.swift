

func assert(condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = default, file: String = default, line: UWord = default) {
	#hint TODO: should be conditional if sserts are enabled only
	if (!condition()) {
		fatalError(message, file, line)
	}
}

/*@noreturn*/ func assertionFailure(_ message: @autoclosure () -> String = default, file: String = default, line: UWord = default) {
	#hint TODO: should be conditional if sserts are enabled only
	fatalError(message, file, line)
}

__inline func debugPrint<T>(x: T) {
	print(toDebugString(x))
}

__inline func debugPrintln<T>(x: T) {
	println(toDebugString(x))
}

//func fatalError(_ message: @autoclosure () -> String = default, file: String = __FILE__, line: UInt32 = __LINE__) { 70964: Silver: support __LINE__ and __FILE__ as default parameter value
/*@noreturn*/ func fatalError(_ message: @autoclosure () -> String = default, file: String = default, line: UInt32 = default) {
	if let message = message {
		__throw Exception(message()+", file "+file+", line "+line)
	} else {
		__throw Exception("Fatal Error, file "+file+", line "+line)
	}
}

func precondition(condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = default, file: String = default, line: UWord = default) {
	#hint TODO: should be conditional if sserts are enabled only
	if (!condition()) {
		fatalError(message, file, line)
	}
}

/*@noreturn*/ func preconditionFailure(_ message: @autoclosure () -> String = default, file: String = default, line: UWord = default) {
	#hint TODO: should be conditional if sserts are enabled only
	fatalError(message, file, line)
}

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

func swap<T>(inout a: T, inout b: T) {
	let temp = a
	a = b
	b = temp
}

__inline func toDebugString<T>(x: T) -> String {
	#if COOPER
	return x.toString()
	#elseif ECHOES
	return x.ToString()
	#elseif NOUGAT
	if (debugDescription.respondsToSelector("debugDescription")) {
		return x.debugDescription
	}
	return x.description
	#endif
}

//@inline(never) func toString<T>(x: T) -> String
__inline func toString<T>(x: T) -> String {
	#if COOPER
	return x.toString()
	#elseif ECHOES
	return x.ToString()
	#elseif NOUGAT
	return x.description
	#endif
}
