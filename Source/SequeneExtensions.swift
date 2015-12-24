
public extension ISequence {
	
	/*public func count() -> Int { // 74024: Silver: internal error in base library
		return self.Count()
	}*/

	public func countElements() -> Int {
		return self.Count()
	}

	public func filter(includeElement: (T) -> Bool) -> ISequence<T> { 
		return self.Where() { return includeElement($0) }
	}

	public func first() -> T? {
		return self.FirstOrDefault()
	}
	
	public func isEmpty<T>() -> Bool {
		return !self.Any()
	}

	public func join(elements: ISequence<T>) -> ISequence<T> {
		var first = true
		for e in elements {
			if !first {
				first = false
				for i in self {
					__yield i
				}
			}
			__yield e
		}
	}
	
	public func join(elements: T[]) -> ISequence<T> { 
		var first = true
		for e in elements {
			if !first {
				first = false
				for i in self {
					__yield i
				}
			}
			__yield e
		}
	}

	public func map<U>(transform: (T) -> U) -> ISequence<U> {
		return self.Select() { return transform($0) }
	}

	public func reduce<U>(initial: U, combine: (U, T) -> U) -> U {
		var value = initial
		for i in self {
			value = combine(value, i)
		}
		return value
	}

	/*public func reverse() -> ISequence<T> { // 74025: Silver: odd errors in base lib when i define Sequence.Reverse()
		return self.Reverse()
	}*/

	public func sorted(isOrderedBefore: (T, T) -> Bool) -> [T] { 
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

	/*public func split(isSeparator: (T) -> Bool, maxSplit: Int = default, allowEmptySlices: Bool = default) -> ISequence<ISequence<T>> {
	
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

	//
	// Silver-specific extensions not defined in standard Swift.Array:
	//

	public func contains(item: T) -> Bool {
		#if COOPER
		return self.contains(item)
		#elseif ECHOES
		return self.Contains(item)
		#elseif NOUGAT
		return self.contains(item)
		#endif
	}
}