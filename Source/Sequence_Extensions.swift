
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

	private static func nativeArrayToSequence(_ nativeArray: T[]) -> ISequence<T> { // make private once ctor workd
		for e in nativeArray {
			__yield e
		}
	}

	init(array: [T]) {
		return array as! ISequence<T> // 74041: Silver: warning for "as" cast that should be known safe
	}

	public func ToSwiftArray() -> [T] {
		if let array = self as? [T] {
			return array.platformList
		}
		var result = [T]()
		for i in self {
			result.append(i)
		}
		return result
	}

	#if !COOPER
	public func ToSwiftArray<U>() -> [U] {
		var result = [U]()
		for i in self {
			result.append(i as! U)
		}
		return result
	}
	#endif

	public var count: Int {
		return self.Count()
	}

	public func dropFirst() -> ISequence<T> {
		return self.Skip(1)
	}

	public func dropFirst(_ n: Int) -> ISequence<T> {
		return self.Skip(n)
	}

	public func dropLast() -> ISequence<T> {
		fatalError("dropLast() is not implemented yet.")
	}

	public func dropLast(_ n: Int) -> ISequence<T> {
		fatalError("dropLast() is not implemented yet.")
	}

	public func enumerated() -> ISequence<(Int, T)> {
		var index = 0
		for element in self {
			__yield (index++, element)
		}
	}

	public func indexOf(@noescape _ predicate: (T) -> Bool) -> Int? {
		for (i, element) in self.enumerated() {
			if (predicate(element) == true){
				return i
			}
		}
		return nil
	}

	public func filter(_ includeElement: (T) throws -> Bool) rethrows -> ISequence<T> {
		return self.Where() { return try! includeElement($0) }
	}

	public func count(`where` countElement: (T) throws -> Bool) rethrows -> Int {
		var result = 0;
		for i in self {
			if try countElement(i) {
				result++
			}
		}
		return result
	}

	public var first: T? {
		return self.FirstOrDefault()
	}

	func flatMap(@noescape _ transform: (T) throws -> T?) rethrows -> ISequence<T> {
		for e in self {
			if let e = try! transform(e) {
				__yield e
			}
		}
	}

	public func flatten() -> ISequence<T> { // no-op in Silver? i dont get what this does.
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

	public func joined(separator: String) -> String {
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

	public func joined(separator: ISequence<T>) -> ISequence<T> {
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

	public func joined(separator: T[]) -> ISequence<T> {
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

	public func map<U>(_ transform: (T) -> U) -> ISequence<U> {
		return self.Select() { return transform($0) }
	}

	//74101: Silver: still two issues with try!
	public func maxElement(_ isOrderedBefore: (T, T) /*throws*/ -> Bool) -> T? {
		var m: T? = nil
		for e in self {
			if m == nil || /*try!*/ !isOrderedBefore(m!, e) { // ToDo: check if this is the right order
				m = e
			}
		}
		return m
	}

	public func minElement(_ isOrderedBefore: (T, T) /*throws*/ -> Bool) -> T? {
		var m: T? = nil
		for e in self {
			if m == nil || /*try!*/ isOrderedBefore(m!, e) { // ToDo: check if this is the right order
				m = e
			}
		}
		return m
	}

	public func `prefix`(_ maxLength: Int) -> ISequence<T> {
		return self.Take(maxLength)
	}

	public func reduce<U>(_ initial: U, _ combine: (U, T) -> U) -> U {
		var value = initial
		for i in self {
			value = combine(value, i)
		}
		return value
	}

	public func reverse() -> ISequence<T> {
		return self.Reverse()
	}

	public func sorted(by isOrderedBefore: (T, T) -> Bool) -> ISequence<T> {
		//todo: make more lazy?
		#if JAVA
		let result = self.ToList()
		java.util.Collections.sort(result, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int32 { // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		}})
		return result
		#elseif CLR || ISLAND
		let result = self.ToList()
		result.Sort() { (a: T, b: T) -> Integer in // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return -1
			} else {
				return 1
			}
		}
		return result
		#elseif COCOA
		return self.ToNSArray().sortedArrayWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in // ToDo: check if this is the right order
			if isOrderedBefore(a == NSNull.null ? nil : a, b == NSNull.null ? nil : b) {
				return .NSOrderedDescending
			} else {
				return .NSOrderedAscending
			}
		})!
		#endif
	}

	/*public func split(_ isSeparator: (T) -> Bool, maxSplit: Int = 0, allowEmptySlices: Bool = false) -> ISequence<ISequence<T>> {

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

	public func startsWith(`prefix` p: ISequence<T>) -> Bool {
		#if JAVA
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
		#elseif CLR || ISLAND
		let sEnum = self.GetEnumerator()
		let pEnum = p.GetEnumerator()
		while true {
			if pEnum.MoveNext() {
				if sEnum.MoveNext() {
					#if CLR
					if !EqualityComparer<T>.Default.Equals(sEnum.Current, pEnum.Current) {
						return false // cound mismatch
					}
					#elseif ISLAND
					if sEnum.Current == nil && pEnum.Current == nil {
					} else if sEnum.Current != nil && pEnum.Current != nil && sEnum.Current.Equals(pEnum.Current) {
					} else {
						return false
					}
					#endif
				} else {
					return false // reached end of s
				}

			} else {
				return true // reached end of prefix
			}
		}
		#elseif COCOA
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
		#endif
	}

	public func suffix(_ maxLength: Int) -> ISequence<T> {
		fatalError("suffix() is not implemented yet.")
	}

	public func underestimateCount() -> Int { // we just return the accurate count here
		return self.Count()
	}

	//
	// Silver-specific extensions not defined in standard Swift.Array:
	//

	/*public func nativeArray() -> T[] {
		#if JAVA
		//return self.toArray()//T[]())
		#elseif CLR
		return self.ToArray()
		#elseif COCOA
		//return self.array()
		#endif
	}*/

	public func toSwiftArray() -> [T] {
		#if JAVA
		let result = ArrayList<T>()
		for e in self {
			result.add(e);
		}
		return [T](result)
		#elseif CLR || ISLAND
		return [T](self.ToList())
		#elseif COCOA
		return [T](self.ToNSArray())
		#endif
	}

	public func contains(_ item: T) -> Bool {
		return self.Contains(item)
	}

	#if COCOA
	override var debugDescription: String! {
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
	#else
	public var debugDescription: String {
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
	#endif
}

#if JAVA
public extension java.util.Map.Entry {

	public func GetTuple() -> (K,V) {
		return (Key,Value)
	}
}
#elseif CLR
public extension System.Collections.Generic.KeyValuePair {

	public func GetTuple() -> (TKey,TValue) {
		return (Key,Value)
	}
}
#elseif COCOA
public extension Foundation.NSDictionary {

	public func GetSequence() -> ISequence<(KeyType,ObjectType)> {
		for entry in self {
		  __yield (entry, self[entry]?)
		}
	}
}

#endif