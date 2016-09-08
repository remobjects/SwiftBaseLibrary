@inline(__always) public func count(_ source: String?) -> Int {
	return length(source)
}

#if !ISLAND
//76072: Island: SBL fails on public generic methods
@inline(__always) public func count<T>(_ source: [T]?) -> Int {
	return length(source)
}

@inline(__always) public func count<T>(_ source: T[]?) -> Int {
	return length(source)
}

@inline(__always) public func count<T>(_ source: ISequence<T>?) -> Int {
	if let s = source {
		return s.Count()
	}
	return 0
}
#endif

public func split(_ elements: String, isSeparator: (Char) -> Bool, maxSplit: Int = 0, allowEmptySlices: Bool = false) -> [String] {
	
	let result = [String]()
	var currentString = ""
	
	func appendCurrent() -> Bool {
		if maxSplit > 0 && result.count >= maxSplit {
			return false
		}
		if allowEmptySlices || currentString.length() > 0 {
			result.append(currentString)
		}
		return true
	}
	
	for i in 0 ..< elements.length() {
		let ch = elements[i]
		if isSeparator(ch) {
			if !appendCurrent() {
				break
			}
			currentString = ""
		} else {
			currentString += ch
		}
	}
	
	if currentString.length() > 0 {
		appendCurrent()
	}
	
	return result
}

public func split(_ elements: String, separatorString separator: String) -> [String] {
	#if JAVA
	return [String](arrayLiteral: (elements as! NativeString).split(java.util.regex.Pattern.quote(separator)))
	#elseif CLR
	return [String](arrayLiteral: (elements as! NativeString).Split([separator], .None))
	#elseif ISLAND
	return [String](arrayLiteral: (elements as! NativeString).Split(separator))
	#elseif COCOA
	return (elements as! NativeString).componentsSeparatedByString(separator) as! [String]
	#endif
}

public func split(_ elements: String, separatorChar separator: Char) -> [String] {
	#if JAVA
	return [String](arrayLiteral: (elements as! NativeString).split(java.util.regex.Pattern.quote(java.lang.String.valueOf(separator))))
	#elseif CLR
	return [String](arrayLiteral: (elements as! NativeString).Split([separator], .None))
	#elseif ISLAND
	return [String](arrayLiteral: (elements as! NativeString).Split(separator))
	#elseif COCOA
	return (elements as! NativeString).componentsSeparatedByString(NSString.stringWithFormat("%c", separator)) as! [String]
	#endif
}

@inline(__always) public func startsWith(_ s: String, `prefix`: String) -> Bool {
	return s.hasPrefix(`prefix`)
}

#if !ISLAND
public func sequence<T>(first: T, next: (T) -> T?) -> ISequence<T> {
	var nextResult: T? = first
	while nextResult != nil {
		__yield nextResult
		nextResult = next(nextResult!)
	}
}
#endif

//75374: Swift Compatibility: Cannot use `inout` in closure
/*public func sequence<T, State>(state: State, next: (inout State) -> T?) -> ISequence<T> {
	var nextResult: T?
	repeat {
		nextResult = next(&state)
		if let nextResult = nextResult {
			__yield nextResult
		}
	} while nextResult != nil
}*/