
// public __inline func abs(x) // provied by compiler
	
@Conditional("DEBUG") public func assert(condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = default, _ file: String = __FILE__, _ line: UWord = __LINE__) {
	if (!condition()) {
		fatalError(message, file, line)
	}
}

@Conditional("DEBUG") @noreturn public func assertionFailure(_ message: @autoclosure () -> String = default, _ file: String = __FILE__, _ line: UWord = __LINE__) {
	fatalError(message, file, line)
}

public __inline func debugPrint(object: Any) {
	writeLn(String(reflecting:object))
}

// different than Apple Swift, we use nil terminator as default to mean cross-planform new-line
public func debugPrint(objects: Any...) {//, separator separator: String = " ", terminator terminator: String? = nil) { // 73994: Silver: "..." params syntax should be allowed not only for the last param
	let separator: String = " "
	let terminator: String? = nil
	
	var first = true
	for o in objects {
		if !first {
			write(separator)
		} else {
			first = false
		}
		write(String(reflecting:o))
	}
	if let terminator = terminator {
		write(terminator)
	} else {
		writeLn()
	}
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

//74036: Can't use Obsolete(, true) on Java :(
/*@Obsolete("Use print() instead")*/ public __inline func println(objects: Any...) { // no longer defined for Swift, but we're keeping it for backward compartibiolitry for now
	print(objects)
}

// different than Apple Swift, we use nil terminator as default to mean cross-planform new-line
public func print(objects: Any...) {//, separator separator: String = " ", terminator terminator: String = nil) { // 73994: Silver: "..." params syntax should be allowed not only for the last param
	let separator: String = " "
	let terminator: String? = nil
	
	var first = true
	for o in objects {
		if !first {
			write(separator)
		} else {
			first = false
		}
		write(o)
	}
	if let terminator = terminator {
		write(terminator)
	} else {
		writeLn()
	}
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