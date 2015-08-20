public __inline func countElements(source: String?) -> Int {
	return length(source)
}

public __inline func countElements<T>(source: [T]?) -> Int {
	return length(source)
}

public __inline func countElements<T>(source: T[]?) -> Int {
	return length(source)
}

public __inline func countElements<T>(source: ISequence<T>?) -> Int {
	if let s = source {
		return s.Count()
	}
	return 0
}

/* count() just duplicates countElements. We know, Ugh. */

public __inline func count(source: String?) -> Int { return countElements(source) }
public __inline func count<T>(source: [T]?) -> Int { return countElements(source) }
public __inline func count<T>(source: T[]?) -> Int { return countElements(source) }
public __inline func count<T>(source: ISequence<T>) -> Int { return countElements(source) }

public __inline func contains<T>(source: ISequence<T>?, predicate: (T) -> Bool) -> Bool {
	if let s = source {
		#if COOPER
		return s.Any({ return predicate($0) })
		#elseif ECHOES
		return s.Any(predicate)
		#elseif NOUGAT
		return s.Any({ return predicate($0) })
		#endif
	}
	return false
}

public __inline public func filter<T>(source: ISequence<T>, includeElement: (T) -> Bool) -> ISequence<T> {
	#if COOPER
	return source.Where({ return includeElement($0) })
	#elseif ECHOES
	return source.Where(includeElement)
	#elseif NOUGAT
	return source.Where({ return includeElement($0) })
	#endif
}

/*public __inline func first<T>(source: ISequence<T>?) -> T? { // Type "T" cannot be used as nullable
	if let s = source {
		return !s.FirstOrDefault()
	}
	return nil
}*/

public __inline func isEmpty<T>(source: ISequence<T>?) -> Bool {
	if let s = source {
		return !s.Any()
	}
	return true
}

public __inline public func map<T, U>(source: ISequence<T>, transform: (T) -> U) -> ISequence<U> {
	#if COOPER
	return source.Select({ return transform($0) })
	#elseif ECHOES | NOUGAT
	return source.Select(transform)
	#endif
}

public __inline public func reverse<T>(source: ISequence<T>) -> ISequence<T>
{
	return source.Reverse()
}

public __inline public func sorted<T>(source: ISequence<T>, isOrderedBefore: (T,T) -> Bool) -> [T]
{
	let result = [T](sequence: source) 
	#if COOPER
	java.util.Collections.sort(result, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int { 
		if isOrderedBefore(a,b) {
			return 1
		} else {
			return -1
		}
	}})	
	return result
	//todo, clone fromabove once it works
	#elseif ECHOES
	(result as! List<T>).Sort({ (a: T, b: T) -> Boolean in
		if isOrderedBefore(a,b) {
			return -1
		} else {
			return 1
		}
	})
	return result
	#elseif NOUGAT
	(result as! NSArray).sortedArrayWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in
		#hint ToDo: check if this is the right order
		if isOrderedBefore(a,b) {
			return .NSOrderedDescending
		} else {
			return .NSOrderedAscending
		}
	})
	#endif
	return result
}

//public func split<S : Sliceable, R : BooleanType>(elements: S, isSeparator: (S.Generator.Element) -> R, maxSplit: Int = default, allowEmptySlices: Bool = default) -> [S.SubSlice]

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
	
	for var i = 0; i < elements.length(); i++ {
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

public func startsWith<T>(s: ISequence<T>, `prefix` p: ISequence<T>) -> Bool {
	#if COOPER
	let sEnum = s.iterator()
	let pEnum = p.iterator()
	while true {
		if pEnum.hasNext() {
			let pVal = pEnum.next()
			if sEnum.hasNext() {
				let sVal = sEnum.next()
				if (pVal == nil && sVal == nil) {
					// both nil is oke
				} else if pVal != nil && sVal != nil && pVal.equals(sVal) {
					// Neither nil and equals true is oke
				} else {
					return false // Different values
				}
			} else {
				return false // reached end of s
			}
			
		} else {
			return true // reached end of prefix
		}
	}

	return false;
	#elseif ECHOES
	let sEnum = s.GetEnumerator()
	let pEnum = s.GetEnumerator()
	while true {
		if pEnum.MoveNext() {
			if sEnum.MoveNext() {
				if !EqualityComparer<T>.Default.Equals(sEnum.Current, pEnum.Current) {
					return false // cound mismatch
				}
			} else {
				return false // reached end of s
			}
			
		} else {
			return true // reached end of prefix
		}
	}
	return false
	#elseif NOUGAT
	let LOOP_SIZE = 16
	let sState: NSFastEnumerationState = `default`(NSFastEnumerationState)
	let pState: NSFastEnumerationState = `default`(NSFastEnumerationState)
	var sObjects = T[](count: LOOP_SIZE)
	var pObjects = T[](count: LOOP_SIZE)
	
	while true {
		let sCount = s.countByEnumeratingWithState(&sState, objects: sObjects, count: LOOP_SIZE)
		let pCount = p.countByEnumeratingWithState(&pState, objects: pObjects, count: LOOP_SIZE)
		if pCount > sCount {
			return false // s is shorter than prefix
		}
		if pCount == 0 {
			return true // reached end of prefix
		}
		for var i = 0; i < sCount; i++ {
			if i > pCount {
				return true // reached end of prefix
			}
			if !(sState.itemsPtr[i] as! Any).isEqual(pState.itemsPtr[i]) {
				return false // found mismatch
			}
		}
	}
	return false // keep wanting at bay
	#endif
}

public __inline func startsWith(s: String, `prefix`: String) -> Bool {
	return s.hasPrefix(`prefix`)
}