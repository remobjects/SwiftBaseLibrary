
public typealias ILazySequence<T> = ISequence<T>
public typealias LazySequenceType<T> = ISequence<T>
public typealias SequenceType<T> = ISequence<T> // for now, later should become INonLazySequence<T>

public extension ISequence {
	
	/*init(nativeArray: T[]) {
		// 74043: Silver: wrong/confusing error when implementing iterator in nested function
		/*func nativeArrayToSequence() -> ISequence<T> {
			for e in nativeArray {
				__yield e
			}
		}
		return nativeArrayToSequence()*/

		//74042: Silver: wrong "no such overload" error when implementing iterator in extension
		/*return nativeArrayToSequence(nativeArray)*/
	}*/
	
	//74042: Silver: wrong "no such overload" error when implementing iterator in extension
	private func nativeArrayToSequence(nativeArray: T[]) -> ISequence<T> {
		for e in nativeArray {
			__yield e
		}
	}
	
	init(array: [T]) {
		return array as! ISequence<T> // 74041: Silver: warning for "as" cast that should be known safe
	}

	@warn_unused_result public func count() -> Int {
		return self.Count()
	}
	
	@warn_unused_result public func countElements() -> Int {
		return self.Count()
	}

	@warn_unused_result public func dropFirst() -> ISequence<T> {
		return self.Skip(1)
	}

	@warn_unused_result public func dropFirst(n: Int) -> ISequence<T> {
		return self.Skip(n)
	}

	@warn_unused_result public func dropLast() -> ISequence<T> {
		fatalError("dropLast() is not implemented yet.")
	}

	@warn_unused_result public func dropLast(n: Int) -> ISequence<T> {
		fatalError("dropLast() is not implemented yet.")
	}

	@warn_unused_result public func enumerate() -> ISequence<T> { // no-op in Silver
		return self
	}
	
	//74037: Silver: cant use "throws/try!" on Nougat and Cooper; no error when omitting "try!" on Echoes
	@warn_unused_result public func filter(includeElement: (T) /*throws*/ -> Bool) /*rethrows*/ -> ISequence<T> { 
		return self.Where() { return try! includeElement($0) }
	}

	@warn_unused_result public func first() -> T? {
		return self.FirstOrDefault()
	}
	
	//74037: Silver: cant use "throws/try!" on Nougat and Cooper; no error when omitting "try!" on Echoes
	@warn_unused_result func flatMap(@noescape transform: (T) /*throws*/ -> T?) /*rethrows*/ -> ISequence<T> {
		for e in self {
			if let e = /*try!*/ transform(e) {
				__yield e
			}
		}
	}
	
	@warn_unused_result public func flatten() -> ISequence<T> { // no-op in Silver? i dont get what this does.
		return self
	}
	
	public func forEach(@noescape body: (T) throws -> ()) /*rethrows*/ { // 74028: Silver: compiler cant handle "rethrows"
		for e in self {
			try! body(e)
		}
	}
	
	//74036: Can't use Obsolete(, true) on Java :(
	/*@Obsolete("generate() is not supported in Silver.", true)*/ public func generate() -> ISequence<T> { // no-op in Silver? i dont get what this does.
		fatalError("generate() is not supported in Silver.")
	}
	
	@warn_unused_result public func isEmpty<T>() -> Bool {
		return !self.Any()
	}

	//74036: Can't use Obsolete(, true) on Java :(
	/*@Obsolete("Use joinWithSeparator() instead")*/ @warn_unused_result public func join(elements: ISequence<T>) -> ISequence<T> {
		var first = true
		for e in elements {
			if !first {
				for i in self {
					__yield i
				}
			} else {
				first = false
			}
			__yield e
		}
	}
	
	//74036: Can't use Obsolete(, true) on Java :(
	/*@Obsolete("Use joinWithSeparator() instead")*/ @warn_unused_result public func join(elements: T[]) -> ISequence<T> { 
		var first = true
		for e in elements {
			if !first {
				for i in self {
					__yield i
				}
			} else {
				first = false
			}
			__yield e
		}
	}

	@warn_unused_result public func joinWithSeparator(separator: String) -> String {
		var first = true
		var result = ""
		for e in self {
			if !first {
				result += separator
			} else {
				first = false
			}
			result += e.description
		}
		return result
	}
	
	@warn_unused_result public func joinWithSeparator(separator: ISequence<T>) -> ISequence<T> {
		var first = true
		for e in self {
			if !first {
				for i in separator {
					__yield i
				}
			} else {
				first = false
			}
			__yield e
		}
	}
	
	@warn_unused_result public func joinWithSeparator(separator: T[]) -> ISequence<T> { 
		var first = true
		for e in self {
			if !first {
				for i in separator {
					__yield i
				}
			} else {
				first = false
			}
			__yield e
		}
	}

	public var lazy: ISequence<T> { // sequences are always lazy in Silver
		return self
	}
	
	@warn_unused_result public func map<U>(transform: (T) -> U) -> ISequence<U> {
		return self.Select() { return transform($0) }
	}

	@warn_unused_result public func maxElement(isOrderedBefore: (T, T) /*throws*/ -> Bool) -> T? { // 74027: Silver: compiler gets confused with "try!"
		var m: T? = nil
		for e in self {
			if m == nil || /*try!*/ !isOrderedBefore(m!, e) { // ToDo: check if this is the right order
				m = e
			}
		}
		return m
	}

	@warn_unused_result public func minElement(isOrderedBefore: (T, T) /*throws*/ -> Bool) -> T? {
		var m: T? = nil
		for e in self {
			if m == nil || /*try!*/ isOrderedBefore(m!, e) { // ToDo: check if this is the right order
				m = e
			}
		}
		return m
	}
	
	@warn_unused_result public func `prefix`(maxLength: Int) -> ISequence<T> {
		return self.Take(maxLength)
	}

	@warn_unused_result public func reduce<U>(initial: U, combine: (U, T) -> U) -> U {
		var value = initial
		for i in self {
			value = combine(value, i)
		}
		return value
	}

	/*public func reverse() -> ISequence<T> { // 74025: Silver: odd errors in base lib when i define Sequence.Reverse()
		return self.Reverse()
	}*/

	@warn_unused_result public func sort(isOrderedBefore: (T, T) -> Bool) -> ISequence<T> {
		//todo: make more lazy?
		#if COOPER
		let result: ArrayList<T> = [T](items: self) 
		java.util.Collections.sort(result, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int { // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		}})	
		return result
		#elseif ECHOES
		let result: List<T> = [T](items: self) 
		result.Sort() { (a: T, b: T) -> Boolean in // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return -1
			} else {
				return 1
			}
		}
		return result
		#elseif NOUGAT
		return self.array().sortedArrayWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in // ToDo: check if this is the right order
			if isOrderedBefore(a == NSNull.null ? nil : a, b == NSNull.null ? nil : b) {
				return .NSOrderedDescending
			} else {
				return .NSOrderedAscending
			}
		})! as! [T]
		#endif
	}

	/*@warn_unused_result public func split(isSeparator: (T) -> Bool, maxSplit: Int = default, allowEmptySlices: Bool = default) -> ISequence<ISequence<T>> {
	
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
	}*/
	
	@warn_unused_result public func startsWith(`prefix` p: ISequence<T>) -> Bool {
		#if COOPER
		let sEnum = self.iterator()
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
		let sEnum = self.GetEnumerator()
		let pEnum = p.GetEnumerator()
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
			let sCount = self.countByEnumeratingWithState(&sState, objects: sObjects, count: LOOP_SIZE)
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

	@warn_unused_result public func suffix(maxLength: Int) -> ISequence<T> {
		fatalError("suffix() is not implemented yet.")
	}

	public func underestimateCount() -> Int { // we just return the accurate count here
		return self.Count()
	}
	
	//
	// Silver-specific extensions not defined in standard Swift.Array:
	//
	
	/*@warn_unused_result public func nativeArray() -> T[] {
		#if COOPER
		//return self.toArray()//T[]())
		#elseif ECHOES
		return self.ToArray()
		#elseif NOUGAT
		//return self.array()
		#endif
	}

	@warn_unused_result public func array() -> [T] {
		#if COOPER
		//return self.toList()
		#elseif ECHOES
		return self.ToList()
		#elseif NOUGAT
		return self.array()
		#endif
	}*/

	@warn_unused_result public func contains(item: T) -> Bool {
		#if COOPER
		return self.contains(item)
		#elseif ECHOES
		return self.Contains(item)
		#elseif NOUGAT
		return self.contains(item)
		#endif
	}
}

