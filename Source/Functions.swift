
// public __inline func abs(x) // provied by compiler
	
@Conditional("DEBUG") public func assert(condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = default, _ file: String = __FILE__, _ line: UWord = __LINE__) {
	if (!condition()) {
		fatalError(message, file, line)
	}
}

@Conditional("DEBUG") @noreturn public func assertionFailure(_ message: @autoclosure () -> String = default, _ file: String = __FILE__, _ line: UWord = __LINE__) {
	fatalError(message, file, line)
}

public __inline func debugPrint(objects: Any...) {//, separator separator: String = " ", terminator terminator: String = "\n") { // 73994: Silver: "..." params syntax should be allowed not only for the last param
	let separator: String = " "
	let terminator: String = "\n"
	
	var first = true
	for o in objects {
		if !first {
			write(separator)
		} else {
			first = false
		}
		write(__toDebugString(o))
	}
	write(terminator)
}

@noreturn public func fatalError(_ message: @autoclosure () -> String = default, _ file: String = __FILE__, _ line: UInt32 = __LINE__) {
	if let message = message {
		__throw Exception(message()+", file "+file+", line "+line)
	} else {
		__throw Exception("Fatal Error, file "+file+", line "+line)
	}
}

@Conditional("DEBUG") public func precondition(condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = default, _ file: String = __FILE__, _ line: UWord = __LINE__) {
	if (!condition()) {
		fatalError(message, file, line)
	}
}

@Conditional("DEBUG") @noreturn public func preconditionFailure(_ message: @autoclosure () -> String = default, _ file: String = __FILE__, _ line: UWord = __LINE__) {
	fatalError(message, file, line)
}

public __inline func println(objects: Any...) { // no longer defined for Swift, but we're keeping it for backward compartibiolitry for now
	print(objects)
}

public func print(objects: Any...) {//, separator separator: String = " ", terminator terminator: String = "\n") { // 73994: Silver: "..." params syntax should be allowed not only for the last param
	let separator: String = " "
	let terminator: String = "\n"
	
	var first = true
	for o in objects {
		if !first {
			write(separator)
		} else {
			first = false
		}
		write(o)
	}
	write(terminator)
}

#if NOUGAT
//@available(*, unavailable, message="Not implemented yet")
#endif
/*@warn_unused_result*/ func readLine(stripNewline stripNewline: Bool = default) -> String? {
	#if COOPER
	//return System.`in`.readLine() + (!stripNewline ? System.lineSeparator() : "")
	fatalError("readLine is currently not implemented for Java.")
	#elseif ECHOES
	return Console.ReadLine() + (!stripNewline ? Environment.NewLine : "")
	#elseif NOUGAT
	fatalError("readLine is currently not implemented for Cocoa.")
	#endif
}

public func swap<T>(inout a: T, inout b: T) {
	let temp = a
	a = b
	b = temp
}

internal __inline func __toDebugString<T>(x: T) -> String {
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

internal __inline func __toString<T>(x: T) -> String {
	#if COOPER
	return x.toString()
	#elseif ECHOES
	return x.ToString()
	#elseif NOUGAT
	return x.description
	#endif
}
