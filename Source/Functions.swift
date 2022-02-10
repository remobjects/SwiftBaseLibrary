// @inline(__always) public func abs(x) // provied by compiler

@Conditional("DEBUG") public func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, file: String = #file, line: UWord = #line) {
	if (!condition()) {
		fatalError(message, file: file, line: line)
	}
}

@Conditional("DEBUG") public func assertionFailure(_ message: @autoclosure () -> String, file: String = #file, line: UWord = #line) -> Never {
	fatalError(message, file: file, line: line)
}

// we have overloads, instead of default parameters, because otherwise CC will always insert the full signature,
// although the most common use case is to use print() without the extra parameters:

@inline(__always) public func debugPrint(_ object: Object?) {
	print(object, separator: " ", terminator: nil)
}

@inline(__always) public func debugPrint(_ object: Object?, separator: String) {
	print(object, separator: separator, terminator: nil)
}

@inline(__always) public func debugPrint(_ object: Object?, terminator: String?) {
	print(object, separator: " ", terminator: terminator)
}

// different than Apple Swift, we use nil terminator as default instead of "\n", to mean cross-platform new-line
@inline(__always) public func debugPrint(_ object: Object?, separator: String, terminator: String?) {
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

@discardableResult func dump<T>(_ value: T, name: String? = nil, indent: Int = 2, maxDepth: Int = -1, maxItems: Int = -1) -> T
{
	#if ISLAND
	switch modelOf(T) {
		case "Island": debugPrint((value as? IslandObject)?.ToString())
		case "Cocoa": debugPrint((value as? CocoaObject)?.description)
		case "Swift": debugPrint((value as? SwiftObject)?.description)
		case "Delphi": throw Exception("This feature is not supported for Delphi Objects (yet)");
		case "COM": throw Exception("This feature is not supported for COM Objects");
		case "JNI": throw Exception("This feature is not supported for JNI Objects");
		default: throw Exception("Unexpected object model \(modelOf(T))")
	}
	#else
	debugPrint(value as? Object)
	#endif
	return value
}

@noreturn public func fatalError(file: String = #file, line: UInt32 = #line) -> Never {
	__throw Exception("Fatal Error, file "+file+", line "+line)
}

@noreturn public func fatalError(_ message: @autoclosure () -> String, file: String = #file, line: UInt32 = #line) -> Never {
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

@Conditional("DEBUG") public func preconditionFailure(_ message: @autoclosure () -> String, file: String = #file, line: UWord = #line) -> Never {
	fatalError(message, file: file, line: line)
}

@Obsolete("Use print() instead") @inline(__always) public func println(_ objects: Any?...) { // no longer defined for Swift, but we're keeping it for backward compartibiolitry for now
	print(objects)
}

public func print(string: String) {
	write(string)
}

public func print(object: Object?, separator: String, terminator: String?) {
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

@inline(__always) public func print(_ objects: Object?...) {
	print(objects, separator: " ", terminator: nil)
}

@inline(__always) public func print(_ objects: Object?..., separator: String) {
	print(objects, separator: separator, terminator: nil)
}

@inline(__always) public func print(_ objects: Object?..., terminator: String?) {
	print(objects, separator: " ", terminator: terminator)
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
func print<Target : OutputStreamType>(_ objects: Object?..., separator: String = " ", terminator: String? = nil, to output: inout Target) {
	//var first = true
	//for object in objects {
		//if !first {
			//output.write(separator)
		//} else {
			//first = false
		//}
		//output.write(__toString(object))
	//}
	//if let terminator = terminator {
		//output.write(terminator)
	//} else {
		//output.write(__newLine())
	//}
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
	var i = start
	if stride > 0 {
		while i < end {
			__yield i;
			i += stride
		}
	} else if stride < 0 {
		while i > end {
			__yield i;
			i += stride
		}
	}
}

public func stride(from start: Int, through end: Int, by stride: Int) -> ISequence<Int> {
	var i = start
	if stride > 0 {
		while i <= end {
			__yield i;
			i += stride
		}
	} else if stride < 0 {
		while i >= end {
			__yield i;
			i += stride
		}
	}
}

public func stride(from start: Double, to end: Double, by stride: Double) -> ISequence<Double> {
	var i = start
	if stride > 0 {
		while i < end {
			__yield i;
			i += stride
		}
	} else if stride < 0 {
		while i > end {
			__yield i;
			i += stride
		}
	}
}

#if !TOFFEE
public func stride(from start: Double, through end: Double, by stride: Double) -> ISequence<Double> {
	var i = start
	if stride > 0 {
		while i <= end {
			__yield i;
			i += stride
		}
	} else if stride < 0 {
		while i >= end {
			__yield i;
			i += stride
		}
	}
}
#endif

#if COOPER || TOFFEE
@inline(always) public func type(of value: Any) -> Class {
	return typeOf(value)
}
#elseif ECHOES || ISLAND
@inline(always) public func type(of value: Any) -> Type {
	return typeOf(value)
}
#endif


#if TOFFEE

public func autoreleasepool<T>(_ act: () throws -> (T)) -> T throws {
  var res: T;
  autoreleasepool {
	res = try act();
  }
  return res;
}

public func autoreleasepool<T>(_ act: () -> (T)) -> T {
  var res: T;
  autoreleasepool {
	res = try act();
  }
  return res;
}

#endif