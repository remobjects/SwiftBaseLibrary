// @inline(__always) public func abs(x) // provied by compiler
	
@Conditional("DEBUG") public func assert(condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = default, file: String = __FILE__, line: UWord = __LINE__) {
	if (!condition()) {
		fatalError(message, file: file, line: line)
	}
}

@Conditional("DEBUG") @noreturn public func assertionFailure(_ message: @autoclosure () -> String = default, file: String = __FILE__, line: UWord = __LINE__) {
	fatalError(message, file: file, line: line)
}

// different than Apple Swift, we use nil terminator as default instead of "\n", to mean cross-platform new-line
@inline(__always) public func debugPrint(object: Object?, separator separator: String = " ", terminator terminator: String? = nil) {
	if let object = object {
		write(String(reflecting:object))
	} else {
		write("(null)")
	}
	if let terminator = terminator {
		write(terminator)
	} else {
		writeLn()
	}
}

// different than Apple Swift, we use nil terminator as default instead of "\n", to mean cross-platform new-line
public func debugPrint(objects: Object?...) {//, separator separator: String = " ", terminator terminator: String? = nil) { // 73994: Silver: "..." params syntax should be allowed not only for the last param
	let separator: String = " "
	let terminator: String? = nil
	
	var first = true
	for object in objects {
		if !first {
			write(separator)
		} else {
			first = false
		}
		if let object = object {
			write(String(reflecting:object))
		} else {
			write("(null)")
		}
	}
	if let terminator = terminator {
		write(terminator)
	} else {
		writeLn()
	}
}

@noreturn public func fatalError(_ message: @autoclosure () -> String = default, file: String = __FILE__, line: UInt32 = __LINE__) {
	if let message = message {
		__throw Exception(message()+", file "+file+", line "+line)
	} else {
		__throw Exception("Fatal Error, file "+file+", line "+line)
	}
}
@Conditional("DEBUG") public func precondition(condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = default, file: String = __FILE__, line: UWord = __LINE__) {
	if (!condition()) {
		fatalError(message, file: file, line: line)
	}
}

@Conditional("DEBUG") @noreturn public func preconditionFailure(_ message: @autoclosure () -> String = default, file: String = __FILE__, line: UWord = __LINE__) {
	fatalError(message, file: file, line: line)
}

@Obsolete("Use print() instead") @inline(__always) public func println(objects: Any?...) { // no longer defined for Swift, but we're keeping it for backward compartibiolitry for now
	print(objects)
}

public func print(object: Object?, separator separator: String = " ", terminator terminator: String? = nil) {
	if let object = object {
		write(object)
	} else {
		write("(null)")
	}
	if let terminator = terminator {
		write(terminator)
	} else {
		writeLn()
	}
}

// different than Apple Swift, we use nil terminator as default instead of "\n", to mean cross-platform new-line
public func print(objects: Object?...) {//, separator separator: String = " ", terminator terminator: String? = nil) { // 73994: Silver: "..." params syntax should be allowed not only for the last param
	let separator: String = " "
	let terminator: String? = nil
	
	var first = true
	for object in objects {
		if !first {
			write(separator)
		} else {
			first = false
		}
		if let object = object {
			write(object)
		} else {
			write("(null)")
	 }
	}
	if let terminator = terminator {
		write(terminator)
	} else {
		writeLn()
	}
}

//todo: delegate to readLn() function once we have that in core compiler
@warn_unused_result public func readLine(# stripNewline: Bool = true) -> String {
	#if COOPER
	return System.console().readLine() + (!stripNewline ? System.lineSeparator() : "")
	#elseif ECHOES
	return Console.ReadLine() + (!stripNewline ? Environment.NewLine : "")
	#elseif NOUGAT
	var result = ""
	repeat {
		let c = getchar()
		if c == 10 || c == 13 {
			return result + (!stripNewline ? "\n" : "")
		}
		result += Char(c)
	} while true
	return (!stripNewline ? "\n" : "") // only to keep warning away, never reached // 74112: Silver: erroneous "method does not return value" 
	#endif
}

public func swap<T>(inout a: T, inout b: T) {
	let temp = a
	a = b
	b = temp
}