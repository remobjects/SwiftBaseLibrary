
public extension ISequence /*: ICustomDebugStringConvertible*/ { // 74092: Silver: interface on class extension fails on not finding the matching method
	
	init(nativeArray: T[]) {
		// 74043: Silver: wrong/confusing error when implementing iterator in nested function
		/*func nativeArrayToSequence() -> ISequence<T> {
			for e in nativeArray {
				__yield e
			}
		}
		return nativeArrayToSequence()*/

		//74042: Silver: wrong "no such overload" error when implementing iterator in extension
		return nativeArrayToSequence(nativeArray)
	}
	
	private static func nativeArrayToSequence(nativeArray: T[]) -> ISequence<T> { // make private once ctor workd
		for e in nativeArray {
			__yield e
		}
	}
	
	init(array: [T]) {
		return array as! ISequence<T> // 74041: Silver: warning for "as" cast that should be known safe
	}

	public var count: Int {
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

	@warn_unused_result public func enumerate() -> ISequence<(Int, T)> {
		var index = 0
		for element in self {
			__yield (index, element)
			index += 1
		}
	}
	
	@warn_unused_result public func filter(includeElement: (T) throws -> Bool) rethrows -> ISequence<T> { 
		return self.Where() { return try! includeElement($0) }
	}

	public var first: T? {
		return self.FirstOrDefault()
	}
	
	@warn_unused_result func flatMap(@noescape transform: (T) throws -> T?) rethrows -> ISequence<T> {
		for e in self {
			if let e = try! transform(e) {
				__yield e
			}
		}
	}
	
	@warn_unused_result public func flatten() -> ISequence<T> { // no-op in Silver? i dont get what this does.
		return self
	}
	
	public func forEach(@noescape body: (T) throws -> ()) rethrows {
		for e in self {
			try! body(e)
		}
	}
	
	@Obsolete("generate() is not supported in Silver.", true) public func generate() -> ISequence<T> { // no-op in Silver? i dont get what this does.
		fatalError("generate() is not supported in Silver.")
	}
	
	public var isEmpty: Bool {
		return !self.Any()
	}

	@Obsolete("Use joinWithSeparator() instead") @warn_unused_result public func join(elements: ISequence<T>) -> ISequence<T> {
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
	
	@Obsolete("Use joinWithSeparator() instead") @warn_unused_result public func join(elements: T[]) -> ISequence<T> { 
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

	//74101: Silver: still two issues with try!
	@warn_unused_result public func maxElement(isOrderedBefore: (T, T) /*throws*/ -> Bool) -> T? {
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

	public func reverse() -> ISequence<T> {
		return self.Reverse()
	}

	@warn_unused_result public func sort(isOrderedBefore: (T, T) -> Bool) -> ISequence<T> {
		//todo: make more lazy?
		#if COOPER
		let result: ArrayList<T> = [T](sequence: self) 
		java.util.Collections.sort(result, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int32 { // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		}})	
		return result
		#elseif ECHOES
		let result: List<T> = [T](sequence: self) 
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

	/*@warn_unused_result public func split(isSeparator: (T) -> Bool, maxSplit: Int = 0, allowEmptySlices: Bool = false) -> ISequence<ISequence<T>> {
	
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
			for i in 0 ..< sCount {
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
	}*/

	@warn_unused_result public func toSwiftArray() -> [T] {
		#if COOPER
		let result = ArrayList<T>()
		for e in self {
			result.add(e);
		}
		return result
		#elseif ECHOES
		return self.ToList()
		#elseif NOUGAT
		return self.array().mutableCopy
		#endif
	}

	@warn_unused_result public func contains(item: T) -> Bool {
		#if COOPER
		return self.contains(item)
		#elseif ECHOES
		return self.Contains(item)
		#elseif NOUGAT
		return self.contains(item)
		#endif
	}

	#if NOUGAT
	override var debugDescription: String! {
	#else
	public var debugDescription: String {
	#endif
		var result = "Sequence("
		var first = true
		for e in self {
			if !first {
				result += ", "
			} else {
				first = false
			}
			result += String(reflecting: e)
		}
		result += ")"
		return result
	}
}

#if COOPER
public extension java.util.Map.Entry {

	public func GetTuple() -> (K,V) {
		return (Key,Value)
	}
}
#elseif ECHOES
public extension System.Collections.Generic.KeyValuePair {

	public func GetTuple() -> (TKey,TValue) {
		return (Key,Value)
	}
}
#elseif NOUGAT
public extension Foundation.NSDictionary {

	public func GetSequence() -> ISequence<(AnyObject,AnyObject)> {
		for entry in self { 
		  __yield (entry, self[entry]?)
		}
	}
}

public extension RemObjects.Elements.System.NSDictionary {

	public func GetSequence() -> ISequence<(TKey,TValue)> {
		for entry in self { 
		  __yield (entry, self[entry]?)
		}
	}
}
#endif