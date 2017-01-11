//
//
// CAUTION: Magic type name.
// The compiler will map the [] array syntax to Swift.Array<T>
//
//

#if COCOA
__mapped public class Array<T: class> : INSFastEnumeration<T> => Foundation.NSMutableArray {
#elseif JAVA
__mapped public class Array<T> : Iterable<T> => java.util.ArrayList<T> {
#elseif CLR
__mapped public class Array<T> : IEnumerable<T> => System.Collections.Generic.List<T> {
#elseif ISLAND
__mapped public class Array<T> : ISequence<T> => RemObjects.Elements.System.List<T> {
#endif

	public init() {
		#if JAVA
		return ArrayList<T>()
		#elseif CLR | ISLAND
		return List<T>()
		#elseif COCOA
		return NSMutableArray.array()
		#endif
	}

	public init(items: [T]) {
		#if JAVA
		return ArrayList<T>(items)
		#elseif CLR | ISLAND
		return List<T>(items)
		#elseif COCOA
		return items.mutableCopy
		#endif
	}

	//init(array: T[]) { } // same as below.
	public init(arrayLiteral array: T...) {
		if array == nil || length(array) == 0 {
			return [T]()
		}

		#if JAVA
		return ArrayList<T>(java.util.Arrays.asList(array))
		#elseif CLR | ISLAND
		return List<T>(array)
		#elseif COCOA
		return NSMutableArray.arrayWithObjects((&array[0] as! UnsafePointer<id>), count: length(array))
		#endif
	}

	#if COCOA
	public init(NSArray array: NSArray<T>) {
		if array == nil {
			return [T]()
		}
		return array.mutableCopy()
	}

	/*public init(_fromCocoaArray source: _CocoaArrayType, noCopy: Bool = false) {
	}*/
	#endif

	public init(sequence: ISequence<T>) {
		#if JAVA
		return sequence.ToList()
		#elseif CLR | ISLAND
		return sequence.ToList()
		#elseif COCOA
		return sequence.array().mutableCopy()
		#endif
	}

	// our aggregate operations like .map, .filter will errase our collection type and yield ISequence
	// so in order to have consistency with apple swift compiling
	// we will do something like [String](fields.map(fieldNameWithRemovedPrivatePrefix)).someArrayFunc
	public convenience init(_ sequence: ISequence<T>) {
		return self.init(sequence: sequence)
	}

	public init(count: Int, repeatedValue: T) {
		#if JAVA
		let newSelf: [T] = ArrayList<T>(count)
		#elseif CLR | ISLAND
		let newSelf: [T] = List<T>(count)
		#elseif COCOA
		let newSelf: [T] = NSMutableArray(capacity: count)
		#endif
		for i in 0 ..< count {
			newSelf.append(repeatedValue)
		}
		return newSelf
	}

	public init(capacity: Int) { // not in Apple Swift
		#if JAVA
		return ArrayList<T>(capacity)
		#elseif CLR | ISLAND
		return List<T>(capacity)
		#elseif COCOA
		return NSMutableArray(capacity: capacity)
		#endif
	}

	public var nativeArray: T[] {
		#if JAVA
		return __mapped.toArray(T[](__mapped.Count()))
		#elseif CLR | ISLAND
		return __mapped.ToArray()
		#elseif COCOA
		let c = count
		var result = T[](c)
		__mapped.getObjects((&result[0] as! UnsafePointer<id>), range: NSMakeRange(0, c))
		return result
		#endif
	}

	func `prefix`(through: Int) -> [T] {
		return self[0...through]
	}

	func `prefix`(upTo: Int) -> [T] {
		return self[0..<upTo]
	}

	func suffix(from: Int) -> [T] {
		return self[from..<count]
	}

	public subscript (range: Range) -> [T] {
		#if COCOA
		return self.Skip(range.lowerBound).Take(range.length).array().mutableCopy() as! NSMutableArray<T>
		#else
		return self.Skip(range.lowerBound).Take(range.length).ToList()
		#endif
	}

	public subscript (index: Int) -> T {
		get {
			#if CLR || JAVA | ISLAND
			return __mapped[index]
			#elseif COCOA
			var value: AnyObject! = __mapped[index]
			if value == NSNull.null {
				value = nil
			}
			return value
			#endif
		}
		set {
			#if JAVA | CLR | ISLAND
			__mapped[index] = newValue
			#elseif COCOA
			if newValue == nil {
				__mapped[index] = NSNull.null
			} else {
				__mapped[index] = newValue
			}
			#endif
		}
	}

	public var count: Int {
		#if JAVA
		return __mapped.size()
		#elseif CLR | ISLAND
		return __mapped.Count
		#elseif COCOA
		return __mapped.count
		#endif
	}

	public var capacity: Int {
		#if JAVA
		return -1
		#elseif CLR | ISLAND
		return __mapped.Capacity
		#elseif COCOA
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

	public mutating func reserveCapacity(_ minimumCapacity: Int) {
		#if JAVA
		__mapped.ensureCapacity(minimumCapacity)
		#elseif CLR | ISLAND | COCOA
		// N/A
		#endif
	}

	public mutating func extend(_ sequence: ISequence<T>) {
		#if JAVA
		__mapped.addAll(sequence.ToList())
		#elseif CLR | ISLAND
		__mapped.AddRange(sequence.ToList())
		#elseif COCOA
		__mapped.addObjectsFromArray(sequence.array())
		#endif
	}

	public mutating func extend(_ array: [T]) {
		#if JAVA
		__mapped.addAll(array)
		#elseif CLR | ISLAND
		__mapped.AddRange(array)
		#elseif COCOA
		__mapped.addObjectsFromArray(array)
		#endif
	}

	public mutating func append(_ newElement: T) {
		#if JAVA
		__mapped.add(newElement)
		#elseif CLR | ISLAND
		__mapped.Add(newElement)
		#elseif COCOA
		if let val = newElement {
			__mapped.addObject(newElement)
		} else {
			__mapped.addObject(NSNull.null)
		}
		#endif
	}

	public mutating func insert(_ newElement: T, at index: Int) {
		#if JAVA
		__mapped.add(index, newElement)
		#elseif CLR | ISLAND
		__mapped.Insert(index, newElement)
		#elseif COCOA
		if let val = newElement {
			__mapped.insertObject(newElement, atIndex: index)
		} else {
			__mapped.insertObject(NSNull.null, atIndex: index)
		}
		#endif
	}

	@discardableResult public mutating func remove(at index: Int) -> T {
		#if JAVA
		return __mapped.remove(index)
		#elseif CLR | ISLAND
		let result = self[index]
		__mapped.RemoveAt(index)
		return result
		#elseif COCOA
		let result = self[index]
		__mapped.removeObjectAtIndex(index)
		return result
		#endif
	}

	public mutating func remove(_ object: T) {
		#if JAVA
		__mapped.remove(object)
		#elseif CLR | ISLAND
		__mapped.Remove(object)
		#elseif COCOA
		__mapped.removeObject(object)
		#endif
	}

	@discardableResult public mutating func removeLast() -> T {
		let c = count
		if c > 0 {
			return remove(at: c-1)
		}  else {
			__throw Exception("Cannot remove last item of an empty array.")
		}
	}

	public mutating func removeAll(keepCapacity: Bool = false) {
		#if JAVA
		__mapped.clear()
		#elseif CLR | ISLAND
		__mapped.Clear()
		#elseif COCOA
		__mapped.removeAllObjects()
		#endif
	}

	// availabvle via ISequence anyways
	/*public func enumerate() -> ISequence<(Int, T)> {
		var index = 0
		for element in self {
			__yield (index, element)
			index += 1
		}
	}*/

	public func lazy() -> ISequence<T> {
		return self
	}

	public mutating func sort(_ isOrderedBefore: (T, T) -> Bool) {
		#if JAVA
		java.util.Collections.sort(__mapped, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int32 {
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		}})
		#elseif CLR
		__mapped.Sort({ (a: T, b: T) -> Boolean in
			if isOrderedBefore(a,b) {
				return -1
			} else {
				return 1
			}
		})
		#elseif COCOA
		__mapped.sortWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in
			if isOrderedBefore(a == NSNull.null ? nil : a, b == NSNull.null ? nil : b) {
				return .NSOrderedDescending
			} else {
				return .NSOrderedAscending
			}
		})
		#endif
	}

	public func sorted(_ isOrderedBefore: (T, T) -> Bool) -> [T] {
		#if JAVA
		let result: ArrayList<T> = [T](items: self)
		java.util.Collections.sort(result, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int32 { // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		}})
		return result
		#elseif CLR || ISLAND
		let result: List<T> = [T](items: self)
		result.Sort() { (a: T, b: T) -> Integer in // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return -1
			} else {
				return 1
			}
		}
		return result
		#elseif COCOA
		return __mapped.sortedArrayWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in // ToDo: check if this is the right order
			if isOrderedBefore(a == NSNull.null ? nil : a, b == NSNull.null ? nil : b) {
				return .NSOrderedDescending
			} else {
				return .NSOrderedAscending
			}
		})! as! [T]
		#endif
	}

	public func map<U>(_ transform: (T) -> U) -> ISequence<U> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if JAVA
		return __mapped.Select({ return transform($0) })
		#elseif CLR || ISLAND || COCOA
		return __mapped.Select(transform)
		#endif
	}

	public func reverse() -> ISequence<T> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		return (__mapped as! ISequence<T>).Reverse()
	}

	public func filter(_ includeElement: (T) -> Bool) -> ISequence<T> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if JAVA
		return __mapped.Where({ return includeElement($0) })
		#elseif CLR || ISLAND || COCOA
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

	public func contains(_ item: T) -> Bool {
		#if JAVA
		return __mapped.contains(item)
		#elseif CLR || ISLAND
		return __mapped.Contains(item)
		#elseif COCOA
		return __mapped.containsObject(item)
		#endif
	}

	public static func + <T>(lhs: Array<T>, rhs: ISequence<T>) -> Array<T> {

		let targetArray = [T](items: lhs)
		for element in rhs {
			targetArray.append(element)
		}

		return targetArray
	}


}