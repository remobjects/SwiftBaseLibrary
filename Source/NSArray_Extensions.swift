#if DARWIN
public extension NSArray {

	init(nativeArray: ObjectType[]) {
		let result = NSMutableArray(capacity: length(nativeArray))
		for e in nativeArray {
			result.addObject(e)
		}
		return result
	}

	init(array: [ObjectType]) {
		return array as! ISequence<ObjectType> // 74041: Silver: warning for "as" cast that should be known safe
	}

	public func ToSwiftArray() -> [ObjectType] {
		//workaround for E25642: Island/Darwin: can't use generic params with Cocoa collection even if consrained to NSObject
		//if let array = self as? [ObjectType] {
			//return array.platformList
		//}
		var result = [ObjectType]()
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

	public func dropFirst() -> ISequence<ObjectType> {
		return self.Skip(1)
	}

	public func dropFirst(_ n: Int) -> ISequence<ObjectType> {
		return self.Skip(n)
	}

	public func dropLast() -> ISequence<ObjectType> {
		fatalError("dropLast() is not implemented yet.")
	}

	public func dropLast(_ n: Int) -> ISequence<ObjectType> {
		fatalError("dropLast() is not implemented yet.")
	}

	public func enumerated() -> ISequence<(Int, ObjectType)> {
		var index = 0
		for element in self {
			__yield (index++, element)
		}
	}

	public func indexOf(@noescape _ predicate: (ObjectType) -> Bool) -> Int? {
		for (i, element) in self.enumerated() {
			if (predicate(element) == true){
				return i
			}
		}
		return nil
	}

	public func filter(_ includeElement: (ObjectType) throws -> Bool) rethrows -> ISequence<ObjectType> {
		return self.Where() { return try! includeElement($0) }
	}

	public func count(`where` countElement: (ObjectType) throws -> Bool) rethrows -> Int {
		var result = 0;
		for i in self {
			if try countElement(i) {
				result++
			}
		}
		return result
	}

	public var first: ObjectType? {
		return self.FirstOrDefault()
	}

	func flatMap(@noescape _ transform: (ObjectType) throws -> ObjectType?) rethrows -> ISequence<ObjectType> {
		for e in self {
			if let e = try! transform(e) {
				__yield e
			}
		}
	}

	public func flatten() -> ISequence<ObjectType> { // no-op in Silver? i dont get what this does.
		return self
	}

	public func forEach(@noescape body: (ObjectType) throws -> ()) rethrows {
		for e in self {
			try! body(e)
		}
	}

	@Obsolete("generate() is not supported in Silver.", true) public func generate() -> ISequence<ObjectType> { // no-op in Silver? i dont get what this does.
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
			//workaround for E25643: Island: ambiguous call to "description"
			result += (e as! NSObject).description
		}
		return result
	}

	public func joined(separator: ISequence<ObjectType>) -> ISequence<ObjectType> {
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

	public func joined(separator: ObjectType[]) -> ISequence<ObjectType> {
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

	public var lazy: ISequence<ObjectType> { // sequences are always lazy in Silver
		return self
	}

	public func map<U>(_ transform: (ObjectType) -> U) -> ISequence<U> {
		return self.Select() { return transform($0) }
	}

	//74101: Silver: still two issues with try!
	public func maxElement(_ isOrderedBefore: (ObjectType, ObjectType) /*throws*/ -> Bool) -> ObjectType? {
		var m: ObjectType? = nil
		for e in self {
			if m == nil || /*try!*/ !isOrderedBefore(m!, e) { // ToDo: check if this is the right order
				m = e
			}
		}
		return m
	}

	public func minElement(_ isOrderedBefore: (ObjectType, ObjectType) /*throws*/ -> Bool) -> ObjectType? {
		var m: ObjectType? = nil
		for e in self {
			if m == nil || /*try!*/ isOrderedBefore(m!, e) { // ToDo: check if this is the right order
				m = e
			}
		}
		return m
	}

	public func `prefix`(_ maxLength: Int) -> ISequence<ObjectType> {
		return self.Take(maxLength)
	}

	public func reduce<U>(_ initial: U, _ combine: (U, ObjectType) -> U) -> U {
		var value = initial
		for i in self {
			value = combine(value, i)
		}
		return value
	}

	public func reverse() -> ISequence<ObjectType> {
		return self.Reverse()
	}

	public func sorted(by isOrderedBefore: (ObjectType, ObjectType) -> Bool) -> ISequence<ObjectType> {
		//todo: make more lazy?
		#if JAVA
		let result = self.ToList()
		java.util.Collections.sort(result, class java.util.Comparator<ObjectType> { func compare(a: ObjectType, b: ObjectType) -> Int32 { // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		}})
		return result
		#elseif CLR || ISLAND
		let result = self.ToList()
		result.Sort() { (a: ObjectType, b: ObjectType) -> Integer in // ToDo: check if this is the right order
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

	/*public func split(_ isSeparator: (ObjectType) -> Bool, maxSplit: Int = 0, allowEmptySlices: Bool = false) -> ISequence<ISequence<ObjectType>> {

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

	public func startsWith(`prefix` p: ISequence<ObjectType>) -> Bool {
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
		let pEnum = p.GetEnumerator()
		for c in self {
			if pEnum.MoveNext() {
				#if CLR
				if !EqualityComparer<ObjectType>.Default.Equals(c, pEnum.Current) {
					return false // cound mismatch
				}
				#elseif ISLAND
				if c == nil && pEnum.Current == nil {
				} else if c != nil && pEnum.Current != nil && c.Equals(pEnum.Current) {
				} else {
					return false
				}
				#endif
			} else {
				return true // reached end of prefix
			}
		}
		return true // reached end of s
		#elseif COCOA
		let LOOP_SIZE = 16
		let sState: NSFastEnumerationState = `default`(NSFastEnumerationState)
		let pState: NSFastEnumerationState = `default`(NSFastEnumerationState)
		var sObjects = ObjectType[](count: LOOP_SIZE)
		var pObjects = ObjectType[](count: LOOP_SIZE)

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

	public func suffix(_ maxLength: Int) -> ISequence<ObjectType> {
		fatalError("suffix() is not implemented yet.")
	}

	public func underestimateCount() -> Int { // we just return the accurate count here
		return self.Count()
	}

	//
	// Silver-specific extensions not defined in standard Swift.Array:
	//

	/*public func nativeArray() -> ObjectType[] {
		#if JAVA
		//return self.toArray()//ObjectType[]())
		#elseif CLR
		return self.ToArray()
		#elseif COCOA
		//return self.array()
		#endif
	}*/

	public func toSwiftArray() -> [ObjectType] {
		#if JAVA
		let result = ArrayList<ObjectType>()
		for e in self {
			result.add(e);
		}
		return [ObjectType](result)
		#elseif CLR || ISLAND
		return [ObjectType](self.ToList())
		#elseif COCOA
		return [ObjectType](self.ToNSArray())
		#endif
	}

	public func contains(_ item: ObjectType) -> Bool {
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

#endif