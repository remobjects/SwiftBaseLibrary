//
//
// CAUTION: Magic type name. 
// The compiler will map the [] array syntax to Swift.Array<T>
//
//

#if NOUGAT
__mapped public class Array<T: class> : INSFastEnumeration<T> => Foundation.NSMutableArray {
#elseif COOPER
__mapped public class Array<T> : Iterable<T> => java.util.ArrayList<T> {
#elseif ECHOES
__mapped public class Array<T> : IEnumerable<T> => System.Collections.Generic.List<T> {
#endif

	public init() {
		#if COOPER
		return ArrayList<T>()
		#elseif ECHOES
		return List<T>()
		#elseif NOUGAT
		return NSMutableArray.array()
		#endif
	}
	
	public init(items: [T]) {
		#if COOPER
		return ArrayList<T>(items)
		#elseif ECHOES
		return List<T>(items)
		#elseif NOUGAT
		return items.mutableCopy
		#endif
	}
	
	//init(array: T[]) { } // same as below.
	public init(arrayLiteral array: T...) {
		if array == nil || length(array) == 0 {
			return [T]()
		}
		
		#if COOPER
		return ArrayList<T>(java.util.Arrays.asList(array))
		#elseif ECHOES
		return List<T>(array)
		#elseif NOUGAT
		return NSMutableArray.arrayWithObjects((&array[0] as! UnsafePointer<id>), count: length(array))
		#endif		
	}
	
	#if NOUGAT
	public init(NSArray array: NSArray<T>) {
		if array == nil {
			return [T]()
		}
		return array.mutableCopy()
	}

	/*public init(_fromCocoaArray source: _CocoaArrayType, noCopy: Bool = default) {
	}*/
	#endif
	
	public init(sequence: ISequence<T>) {
		#if COOPER
		return sequence.ToList()
		#elseif ECHOES
		return sequence.ToList()
		#elseif NOUGAT
		return sequence.array().mutableCopy()
		#endif
	}

	public init(count: Int, repeatedValue: T) {
		#if COOPER
		let newSelf: [T] = ArrayList<T>(count)
		#elseif ECHOES
		let newSelf: [T] = List<T>(count)
		#elseif NOUGAT
		let newSelf: [T] = NSMutableArray(capacity: count)
		#endif
		for var i: Int = 0; i < count; i++ {
			newSelf.append(repeatedValue)
		}
		return newSelf
	}
	
	public init(capacity: Int) { // not in Apple Swift 
		#if COOPER
		return ArrayList<T>(capacity)
		#elseif ECHOES
		return List<T>(capacity)
		#elseif NOUGAT
		return NSMutableArray(capacity: capacity)
		#endif
	}
	
	public var nativeArray: T[] {
		#if COOPER
		return __mapped.toArray(T[](__mapped.Count()))
		#elseif ECHOES
		return __mapped.ToArray()
		#elseif NOUGAT
		let c = count
		var result = T[](c)
		__mapped.getObjects((&result[0] as! UnsafePointer<id>), range: NSMakeRange(0, c))
		return result
		#endif
	}
	
	public subscript (index: Int) -> T {
		get {
			#if ECHOES || COOPER 
			return __mapped[index]
			#elseif NOUGAT
			var value: AnyObject! = __mapped[index]
			if value == NSNull.null {
				value = nil
			}
			return value
			#endif
		}
		set {
			#if COOPER || ECHOES
			__mapped[index] = newValue
			#elseif NOUGAT
			if newValue == nil {
				__mapped[index] = NSNull.null
			} else {
				__mapped[index] = newValue
			}
			#endif
		}
	}
	
	public var count: Int {
		#if COOPER
		return __mapped.size()
		#elseif ECHOES
		return __mapped.Count
		#elseif NOUGAT
		return __mapped.count
		#endif
	}
	
	public var capacity: Int { 
		#if COOPER
		return -1
		#elseif ECHOES
		return __mapped.Capacity
		#elseif NOUGAT
		return -1
		#endif
	}

	public var isEmpty: Bool { 
		return count == 0 
	}

	public var first: T? { 
		if count > 0 {
			return __mapped[0]
		}
		return nil
	}

	public var last: T? { 
		let c = count
		if c > 0 {
			return __mapped[c-1]
		}
		return nil
	}

	public mutating func reserveCapacity(minimumCapacity: Int) {
		#if COOPER
		__mapped.ensureCapacity(minimumCapacity)
		#elseif ECHOES | NOUGAT
		// N/A
		#endif
	}

	public mutating func extend(sequence: ISequence<T>) {
		#if COOPER
		__mapped.addAll(sequence.ToList())
		#elseif ECHOES
		__mapped.AddRange(sequence.ToList())
		#elseif NOUGAT
		__mapped.addObjectsFromArray(sequence.array())
		#endif
	}
	
	public mutating func extend(array: [T]) {
		#if COOPER
		__mapped.addAll(array)
		#elseif ECHOES
		__mapped.AddRange(array)
		#elseif NOUGAT
		__mapped.addObjectsFromArray(array)
		#endif
	}

	public mutating func append(newElement: T) {
		#if COOPER
		__mapped.add(newElement)
		#elseif ECHOES
		__mapped.Add(newElement)
		#elseif NOUGAT
		if let val = newElement {
			__mapped.addObject(newElement)
		} else {
			__mapped.addObject(NSNull.null)
		}
		#endif
	}

	public mutating func insert(newElement: T, atIndex index: Int) {
		#if COOPER
		__mapped.add(index, newElement)
		#elseif ECHOES
		__mapped.Insert(index, newElement)
		#elseif NOUGAT
		if let val = newElement {
			__mapped.insertObject(newElement, atIndex: index)
		} else {
			__mapped.insertObject(NSNull.null, atIndex: index)
		}
		#endif
	}

	public mutating func removeAtIndex(index: Int) -> T {
		#if COOPER
		return __mapped.remove(index)
		#elseif ECHOES
		let result = self[index]
		__mapped.RemoveAt(index)
		return result
		#elseif NOUGAT
		let result = self[index]
		__mapped.removeObjectAtIndex(index)
		return result
		#endif
	}

	public mutating func removeLast() -> T {
		let c = count
		if c > 0 {
			return removeAtIndex(c-1)
		}  else {
			__throw Exception("Cannot remove last item of an empty array.")
		}
	}

	public mutating func removeAll(keepCapacity: Bool = default) {
		#if COOPER
		__mapped.clear()
		#elseif ECHOES
		__mapped.Clear()
		#elseif NOUGAT
		__mapped.removeAllObjects()
		#endif
	}

	// availabvle via ISequence anyways
	/*public func enumerate() -> ISequence<(Int, T)> {
		var index = 0
		for element in self {
			__yield (index, element)
		}
	}*/

	public func lazy() -> ISequence<T> {
		return self
	}
	
	public mutating func sort(isOrderedBefore: (T, T) -> Bool) {
		#if COOPER
		java.util.Collections.sort(__mapped, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int32 {
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		}})	
		#elseif ECHOES
		__mapped.Sort({ (a: T, b: T) -> Boolean in
			if isOrderedBefore(a,b) {
				return -1
			} else {
				return 1
			}
		})
		#elseif NOUGAT
		__mapped.sortWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in
			if isOrderedBefore(a == NSNull.null ? nil : a, b == NSNull.null ? nil : b) {
				return .NSOrderedDescending
			} else {
				return .NSOrderedAscending
			}
		})
		#endif
	}

	public func sorted(isOrderedBefore: (T, T) -> Bool) -> [T] { 
		#if COOPER
		let result: ArrayList<T> = [T](items: self) 
		java.util.Collections.sort(result, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int32 { // ToDo: check if this is the right order
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
		return __mapped.sortedArrayWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in // ToDo: check if this is the right order
			if isOrderedBefore(a == NSNull.null ? nil : a, b == NSNull.null ? nil : b) {
				return .NSOrderedDescending
			} else {
				return .NSOrderedAscending
			}
		})! as! [T]
		#endif
	}

	public func map<U>(transform: (T) -> U) -> ISequence<U> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if COOPER
		return __mapped.Select({ return transform($0) })
		#elseif ECHOES | NOUGAT
		return __mapped.Select(transform)
		#endif
	}

	public func reverse() -> ISequence<T> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		return (__mapped as! ISequence<T>).Reverse()
	}

	public func filter(includeElement: (T) -> Bool) -> ISequence<T> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if COOPER
		return __mapped.Where({ return includeElement($0) })
		#elseif ECHOES | NOUGAT
		return __mapped.Where(includeElement)
		#endif
	}

	/// Call body(p), where p is a pointer to the Array's contiguous storage
	/*func withUnsafeBufferPointer<R>(body: (UnsafeBufferPointer<T>) -> R) -> R {
	}
	
	mutating func withUnsafeMutableBufferPointer<R>(body: (inout UnsafeMutableBufferPointer<T>) -> R) -> R {
	}

	/// This function "seeds" the ArrayLiteralConvertible protocol
	static func convertFromHeapArray(base: Builtin.RawPointer, owner: Builtin.NativeObject, count: Builtin.Word) -> [T] {
	}*/

	/*mutating func replaceRange<C : CollectionType where T == T>(subRange: Range<Int>, with newValues: C) {
	}
	mutating func splice<S : CollectionType where T == T>(s: S, atIndex i: Int) {
	}*/
	/*mutating func removeRange(subRange: Range<Int>) {
	}*/
	
	//
	// Silver-specific extensions not defined in standard Swift.Array:
	//

	public func contains(item: T) -> Bool {
		#if COOPER
		return __mapped.contains(item)
		#elseif ECHOES
		return __mapped.Contains(item)
		#elseif NOUGAT
		return __mapped.containsObject(item)
		#endif
	}

}