@inline(__always) public func count(source: String?) -> Int {
	return length(source)
}

@inline(__always) public func count<T>(source: [T]?) -> Int {
	return length(source)
}

@inline(__always) public func count<T>(source: T[]?) -> Int {
	return length(source)
}

@inline(__always) public func count<T>(source: ISequence<T>?) -> Int {
	if let s = source {
		return s.Count()
	}
	return 0
}

public func split(elements: String, isSeparator: (Char) -> Bool, maxSplit: Int = default, allowEmptySlices: Bool = default) -> [String] {
	
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

public func split(elements: String, separatorString separator: String) -> [String] {
	#if COOPER
	return [String](arrayLiteral: (elements as! java.lang.String).split(java.util.regex.Pattern.quote(separator)))
	#elseif ECHOES
	return [String](arrayLiteral: (elements as! System.String).Split([separator], .None))
	#elseif NOUGAT
	return (elements as! Foundation.NSString).componentsSeparatedByString(separator) as! [String]
	#endif
}

public func split(elements: String, separatorChar separator: Char) -> [String] {
	#if COOPER
	return [String](arrayLiteral: (elements as! java.lang.String).split(java.util.regex.Pattern.quote(java.lang.String.valueOf(separator))))
	#elseif ECHOES
	return [String](arrayLiteral: (elements as! System.String).Split([separator], .None))
	#elseif NOUGAT
	return (elements as! Foundation.NSString).componentsSeparatedByString(NSString.stringWithFormat("%c", separator)) as! [String]
	#endif
}

@inline(__always) public func startsWith(s: String, `prefix`: String) -> Bool {
	return s.hasPrefix(`prefix`)
}