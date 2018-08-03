//
//
// CAUTION: Magic type name.
// The compiler will map the [] array syntax to Swift.Array<T>
//
//

#if COCOA
typealias PlatformSequence<T> = INSFastEnumeration<T>
#elseif JAVA
typealias PlatformSequence<T> = Iterable<T>
#elseif CLR
typealias PlatformSequence<T> = IEnumerable<T>
#elseif ISLAND
typealias PlatformSequence<T> = ISequence<T>
#endif

#if COCOA
typealias PlatformList<T> = RemObjects.Elements.System.NSMutableArray<T>
#elseif JAVA
typealias PlatformList<T> = java.util.ArrayList<T>
#elseif CLR
typealias PlatformList<T> = System.Collections.Generic.List<T>
#elseif ISLAND
typealias PlatformList<T> = RemObjects.Elements.System.List<T>
#endif

//public func length<T>(_ array: Array<T>?) -> Int {
	//if let array = array {
		//return array.count
	//} else {
		//return 0
	//}
//}

public struct Array<T>
{
	public init(copy original: inout [T]) {
		self.list = original.list
		self.unique = false
		original.unique = false
	}

	public init() {
		list = PlatformList<T>()
	}

	public init(items: [T]) {
		self.list = items.list
		self.unique = false
	}

	//init(array: T[]) { } // same as below.
	public init(arrayLiteral array: T! ...) {
		if array == nil || length(array) == 0 {
			list = PlatformList<T>()
		} else {
			#if JAVA
			list = ArrayList<T>(java.util.Arrays.asList(array))
			#elseif CLR | ISLAND
			list = List<T>(array)
			#elseif COCOA
			list = NSMutableArray(capacity: length(array));
			for i in 0 ..< length(array) {
				list.addObject(array[i] ?? NSNull.null as! T);
				}
			#endif
		}
	}

	#if COCOA
	public init(NSArray array: NSArray<T>?) {
		if let array = array {
			list = array.mutableCopy()
		} else {
			list = PlatformList<T>()
		}
	}

	init(repeating value: T, count: Int) {
		if count == 0 {
			list = PlatformList<T>()
		} else {

			#if JAVA
			list = ArrayList<T>(count)
			#elseif CLR | ISLAND
			list = List<T>(count)
			#elseif COCOA
			list = NSMutableArray(capacity: count);
			#endif
			for i in 0 ..< count {
				list.addObject(value);
			}
		}
	}

	/*public init(_fromCocoaArray source: _CocoaArrayType, noCopy: Bool = false) {
	}*/
	#endif

	public init(_ list: PlatformList<T>) {
		self.list = list
		unique = false
	}

	public init(sequence: ISequence<T>) {
		#if JAVA
		list = sequence.ToList()
		#elseif CLR | ISLAND
		list = sequence.ToList()
		#elseif COCOA
		list = sequence.array().mutableCopy()
		#endif
	}

	// our aggregate operations like .map, .filter will errase our collection type and yield ISequence
	// so in order to have consistency with apple swift compiling
	// we will do something like [String](fields.map(fieldNameWithRemovedPrivatePrefix)).someArrayFunc
	#if !ECHOES
	public convenience init(_ sequence: ISequence<T>) {
		self.init(sequence: sequence)
	}
	#endif

	public init(count: Int, repeatedValue: T) {
		#if JAVA
		list = ArrayList<T>(count)
		for i in 0 ..< count {
			list.add(repeatedValue)
		}
		#elseif CLR | ISLAND
		list = List<T>(count)
		for i in 0 ..< count {
			list.Add(repeatedValue)
		}
		#elseif COCOA
		list = NSMutableArray(capacity: count)
		for i in 0 ..< count {
			list.addObject(repeatedValue)
	}
		#endif
	}

	public init(capacity: Int) { // not in Apple Swift
		#if JAVA
		list = ArrayList<T>(capacity)
		#elseif CLR | ISLAND
		list = List<T>(capacity)
		#elseif COCOA
		list = NSMutableArray(capacity: capacity)
		#endif
	}

	//
	// Storage
	//

	private var list: PlatformList<T>
	private var unique: Boolean = true

	private mutating func makeUnique()
	{
		if !unique {
			#if COOPER || ECHOES || ISLAND
			list = PlatformList<T>(list)
			#elseif TOFFEE
			list = list.mutableCopy()
			#endif
			unique = true
		}
	}

	//
	// Operators
	//

	public static func __implicit(_ array: T[]) -> [T] {
		return [T](arrayLiteral: array)
	}

	public static func __implicit(_ list: PlatformList<T>) -> [T] {
		return [T](list)
	}

	public static func __implicit(_ array: [T]) -> T[] {
		return array.nativeArray
	}

	// 80753: `inout` and implicit cast operators
	//public static func __implicit(_ array: inout [T]) -> PlatformList<T> {
		//return array.list
		//array.unique = false
	//}
	public static func __implicit(_ array: [T]) -> PlatformList<T> {
		array.makeUnique()
		return array.list
	}

	//
	// Native access & Conversions
	//

	public var nativeArray: T[] {
		#if JAVA
		return list.toArray(T[](list.Count()))
		#elseif CLR | ISLAND
		return list.ToArray()
		#elseif COCOA
		let c = count
		var result = T[](c)
		for i in 0 ..< count {
			result[i] = list[i] // todo: need to handle NSNull!
		}
		//list.getObjects((&result[0] as! UnsafePointer<id>), range: NSMakeRange(0, c))
		return result
		#endif
	}

	public var platformList: PlatformList<T> {
		//80754: Swift: better error if a non-mutating method chnages a field
		//unique = false
		//return list
		#if COOPER || ECHOES || ISLAND
		return PlatformList<T>(list)
		#elseif TOFFEE
		return list.mutableCopy()
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
		return [T](list.Skip(range.lowerBound).Take(range.length).array())
		#else
		return [T](list.Skip(range.lowerBound).Take(range.length).ToList())
		#endif
	}

	public subscript (index: Int) -> T {
		get {
			#if CLR || JAVA | ISLAND
			return list[index]
			#elseif COCOA
			var value: AnyObject! = list[index]
			if value == NSNull.null {
				value = nil
			}
			return value
			#endif
		}
		set {
			#if JAVA | CLR | ISLAND
			list[index] = newValue
			#elseif COCOA
			if newValue == nil {
				list[index] = NSNull.null as! T
			} else {
				list[index] = newValue
			}
			#endif
		}
	}

	public var count: Int {
		#if JAVA
		return list.size()
		#elseif CLR | ISLAND
		return list.Count
		#elseif COCOA
		return list.count
		#endif
	}

	public var capacity: Int {
		#if JAVA
		return -1
		#elseif CLR | ISLAND
		return list.Capacity
		#elseif COCOA
		return -1
		#endif
	}

	public var isEmpty: Bool {
		return count == 0
	}

	public var first: T? {
		if count > 0 {
			return list[0]
		}
		return nil
	}

	public var last: T? {
		let c = count
		if c > 0 {
			return list[c-1]
		}
		return nil
	}

	public mutating func reserveCapacity(_ minimumCapacity: Int) {
		#if JAVA
		list.ensureCapacity(minimumCapacity)
		#elseif CLR | ISLAND | COCOA
		// N/A
		#endif
	}

	public mutating func extend(_ sequence: ISequence<T>) {
		makeUnique()
		#if JAVA
		list.addAll(sequence.ToList())
		#elseif CLR | ISLAND
		list.AddRange(sequence.ToList())
		#elseif COCOA
		list.addObjectsFromArray(sequence.array())
		#endif
	}

	public mutating func extend(_ array: [T]) {
		makeUnique()
		#if JAVA
		list.addAll(array.list)
		#elseif CLR | ISLAND
		list.AddRange(array.list)
		#elseif COCOA
		list.addObjectsFromArray(array.list)
		#endif
	}

	public mutating func append(_ newElement: T) {
		makeUnique()
		#if JAVA
		list.add(newElement)
		#elseif CLR | ISLAND
		list.Add(newElement)
		#elseif COCOA
		if let val = newElement {
			list.addObject(newElement)
		} else {
			list.addObject(NSNull.null as! T)
		}
		#endif
	}

	public mutating func insert(_ newElement: T, at index: Int) {
		makeUnique()
		#if JAVA
		list.add(index, newElement)
		#elseif CLR | ISLAND
		list.Insert(index, newElement)
		#elseif COCOA
		if let val = newElement {
			list.insertObject(newElement, atIndex: index)
		} else {
			list.insertObject(NSNull.null as! T, atIndex: index)
		}
		#endif
	}

	@discardableResult public mutating func remove(at index: Int) -> T {
		makeUnique()
		#if JAVA
		return list.remove(index)
		#elseif CLR | ISLAND
		let result = self[index]
		list.RemoveAt(index)
		return result
		#elseif COCOA
		let result = self[index]
		list.removeObjectAtIndex(index)
		return result
		#endif
	}

	public mutating func remove(_ object: T) {
		makeUnique()
		#if JAVA
		list.remove(object)
		#elseif CLR | ISLAND
		list.Remove(object)
		#elseif COCOA
		list.removeObject(object)
		#endif
	}

	@discardableResult public mutating func removeLast() -> T {
		let c = count
		if c > 0 {
			makeUnique()
			return remove(at: c-1)
		}  else {
			__throw Exception("Cannot remove last item of an empty array.")
		}
	}

	public mutating func removeAll(keepCapacity: Bool = false) {
		if count > 0 {
			makeUnique()
			#if JAVA
			list.clear()
			#elseif CLR | ISLAND
			list.Clear()
			#elseif COCOA
			list.removeAllObjects()
			#endif
		}
	}

	public mutating func swapAt(_ i: Int, _ j: Int) {
		if i != j {
			makeUnique()
			let temp = self[i]
			self[i] = self[j]
			self[j] = temp
		}
	}

	// availabvle via ISequence anyways
	/*public func enumerated() -> ISequence<(Int, T)> {
		var index = 0
		for element in self {
			__yield (index, element)
			index += 1
		}
	}*/

	public func lazy() -> ISequence<T> {
		return list
	}

	public mutating func sort(by isOrderedBefore: (T, T) -> Bool) {
		makeUnique()
		#if JAVA
		java.util.Collections.sort(list, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int32 {
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		}})
		#elseif CLR
		list.Sort({ (a: T, b: T) -> Integer in
			if isOrderedBefore(a,b) {
				return -1
			} else {
				return 1
			}
		})
		#elseif COCOA
		list.sortWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in
			if isOrderedBefore(a == NSNull.null ? nil : a, b == NSNull.null ? nil : b) {
				return .NSOrderedDescending
			} else {
				return .NSOrderedAscending
			}
		})
		#endif
	}

	public func sorted(by isOrderedBefore: (T, T) -> Bool) -> [T] {
		#if JAVA
		let result = list
		java.util.Collections.sort(result, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int32 { // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		}})
		return [T](result)
		#elseif CLR || ISLAND
		let result = list
		result.Sort() { (a: T, b: T) -> Integer in // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return -1
			} else {
				return 1
			}
		}
		return [T](result)
		#elseif COCOA
		return [T](list.sortedArrayWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in // ToDo: check if this is the right order
			if isOrderedBefore(a == NSNull.null ? nil : a, b == NSNull.null ? nil : b) {
				return .NSOrderedDescending
			} else {
				return .NSOrderedAscending
			}
		}))
		#endif
	}

	public mutating func reverse() {
		makeUnique()
		for i in 0..<count/2 {
			swapAt(i, count-i-1)
		}
	}

	public func reversed() -> Array<T> {
		var result = Array<T>(capacity: count)
		for i in count>..0 {
			result.append(self[i])
		}
		return result
	}

	//public mutating func partition(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> Int {
	//}

	public func map<U>(_ transform: (T) -> U) -> ISequence<U> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if JAVA
		return list.Select({ return transform($0) })
		#elseif CLR || ISLAND || COCOA
		return list.Select(transform)
		#endif
	}

	//public func reversed() -> ISequence<T> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
	//return (list as! ISequence<T>).Reverse()
	//}

	public func filter(_ includeElement: (T) -> Bool) -> ISequence<T> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if JAVA
		return list.Where({ return includeElement($0) })
		#elseif CLR || ISLAND || COCOA
		return list.Where(includeElement)
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
		return list.contains(item)
		#elseif CLR || ISLAND
		return list.Contains(item)
		#elseif COCOA
		return list.containsObject(item)
		#endif
	}

	public static func + <T>(lhs: Array<T>, rhs: ISequence<T>) -> Array<T> {

		var targetArray = [T](items: lhs)
		for element in rhs {
			targetArray.append(element)
		}

		return targetArray
	}


}