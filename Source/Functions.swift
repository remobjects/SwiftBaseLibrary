// @inline(__always) public func abs(x) // provied by compiler
	
@Conditional("DEBUG") public func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, file: String = #file, line: UWord = #line) {
	if (!condition()) {
		fatalError(message, file: file, line: line)
	}
}

@Conditional("DEBUG") @noreturn public func assertionFailure(_ message: @autoclosure () -> String, file: String = #file, line: UWord = #line) {
	fatalError(message, file: file, line: line)
}

// different than Apple Swift, we use nil terminator as default instead of "\n", to mean cross-platform new-line
@inline(__always) public func debugPrint(_ object: Object?, separator: String = " ", terminator: String? = nil) {
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
public func debugPrint(_ objects: Object?..., separator: String = " ", terminator: String? = nil) {
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

@noreturn public func fatalError(_ message: @autoclosure () -> String, file: String = #file, line: UInt32 = #line) {
	if let message = message {
		__throw Exception(message()+", file "+file+", line "+line)
	} else {
		__throw Exception("Fatal Error, file "+file+", line "+line)
	}
}
@Conditional("DEBUG") public func precondition(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, file: String = #file, line: UWord = #line) {
	if (!condition()) {
		fatalError(message, file: file, line: line)
	}
}

@Conditional("DEBUG") @noreturn public func preconditionFailure(_ message: @autoclosure () -> String, file: String = #file, line: UWord = #line) {
	fatalError(message, file: file, line: line)
}

@Obsolete("Use print() instead") @inline(__always) public func println(_ objects: Any?...) { // no longer defined for Swift, but we're keeping it for backward compartibiolitry for now
	print(objects)
}

public func print(object: Object?, separator: String = " ", terminator: String? = nil) {
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
public func print(_ objects: Object?..., separator: String = " ", terminator: String? = nil) {
	var first = true
	for object in objects {
		if !first {
			write(separator)
		} else {
			first = false
		}
		write(__toString(object))
	}
	if let terminator = terminator {
		write(terminator)
	} else {
		writeLn()
	}
}

// different than Apple Swift, we use nil terminator as default instead of "\n", to mean cross-platform new-line
func print<Target : OutputStreamType>(_ objects: Object?..., separator: String = " ", terminator: String? = nil, inout toStream output: Target) {
	var first = true
	for object in objects {
		if !first {
			output.write(separator)
		} else {
			first = false
		}
		output.write(__toString(object))
	}
	if let terminator = terminator {
		output.write(terminator)
	} else {
		output.write(__newLine())
	}
}

public func readLine(# stripNewline: Bool = true) -> String {
	return readLn() + (!stripNewline ? __newLine() : "")
}

@inline(__always) public func swap<T>(inout a: T, inout b: T) {
	let temp = a
	a = b
	b = temp
}

public func stride(from start: Int, to end: Int, by stride: Int) -> ISequence<Int> {
	precondition(stride > 0, "'by' must be larger than zero")
	var i = start
	while i < end {
		__yield i;
		i += stride
	}
}

//75284: Silver: can't overload global func on parameter names?
/*public func stride(from start: Int, through end: Int, by stride: Int) -> ISequence<Int> {
	precondition(stride > 0, "'by' must be larger than zero")
	var i = start
	while i <= end {
		__yield i;
		i += stride
	}
}*/

public func stride(from start: Double, to end: Double, by stride: Double) -> ISequence<Double> {
	precondition(stride > 0, "'by' must be larger than zero")
	var i = start
	while i < end {
		__yield i;
		i += stride
	}
}

//75284: Silver: can't overload global func on parameter names?
/*public func stride(from start: Double, through end: Double, by stride: Double) -> ISequence<Double> {
	precondition(stride > 0, "'by' must be larger than zero")
	var i = start
	while i <= end {
		__yield i;
		i += stride
	}
}*/