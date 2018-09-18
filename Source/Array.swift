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
public typealias PlatformList<T> = NSMutableArray<T>
public typealias PlatformImmutableList<T> = NSArray<T>
#elseif JAVA
public typealias PlatformList<T> = java.util.ArrayList<T>
public typealias PlatformImmutableList<T> = PlatformList<T>
#elseif CLR
public typealias PlatformList<T> = System.Collections.Generic.List<T>
public typealias PlatformImmutableList<T> = PlatformList<T>
#elseif ISLAND
public typealias PlatformList<T> = RemObjects.Elements.System.List<T>
public typealias PlatformImmutableList<T> = PlatformList<T>
#endif

//public func length<T>(_ array: Array<T>?) -> Int {
	//if let array = array {
		//return array.count
	//} else {
		//return 0
	//}
//}

//
//
// CAUTION: Magic type name.
// The compiler will map the [] array syntax to Swift.Array<T>
//
//

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

	//public init(items: inout [T]) { // E59 Duplicate constructor with same signature "init(items var items: T[])"
	public init(items: [T]) {
		self.list = items.list
		self.unique = false
		makeUnique() // workaorund for not having inout
		//self.unique = false
		//items.unique = false
	}

	//init(array: T[]) { } // same as below.
	public init(arrayLiteral array: T¡ ...) {
		if array == nil || length(array) == 0 {
			list = PlatformList<T>()
		} else {
			#if JAVA
			list = ArrayList<T>(java.util.Arrays.asList(array))
			#elseif CLR | ISLAND
			list = List<T>(array)
			#elseif COCOA
			list = NSMutableArray(capacity: length(array))
			for i in 0 ..< length(array) {
				list.addObject(array[i] ?? NSNull.null as! T)
				}
			#endif
		}
	}

	#if COCOA
	//public init(_ array: NSArray<T>?) {
		//if let array = array {
			//list = array.mutableCopy()
		//} else {
			//list = PlatformList<T>()
		//}
	//}

	/*public init(_fromCocoaArray source: _CocoaArrayType, noCopy: Bool = false) {
	}*/
	#endif

	init(repeating value: T, count: Int) {
		if count == 0 {
			list = PlatformList<T>()
		} else {

			#if JAVA
			list = ArrayList<T>(count)
			#elseif CLR | ISLAND
			list = List<T>(count)
			#elseif COCOA
			list = NSMutableArray(capacity: count)
			for i in 0 ..< count {
				list.addObject(value)
			}
			#endif
		}
	}


	public init(_ list: PlatformImmutableList<T>) {
		#if JAVA | CLR | ISLAND
		self.list = PlatformList<T>(list)
		#elseif COCOA
		self.list = list.mutableCopy
		#endif
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

	fileprivate var list: PlatformList<T>
	private var unique: Boolean = true

	private mutating func makeUnique()
	{
		if !unique {
			list = platformList // platformList returns a unique new copy
			unique = true
		}
	}

	//
	//
	//

	public func GetSequence() -> ISequence<T> {
		return list
	}

	//
	// Operators
	//

	public static func __implicit(_ array: T[]) -> [T] {
		return [T](arrayLiteral: array)
	}

	public static func __explicit(_ array: T[]) -> [T] {
		return [T](arrayLiteral: array)
	}

	public static func __implicit(_ list: PlatformList<T>) -> [T] {
		return [T](list)
	}

	public static func __explicit(_ list: PlatformList<T>) -> [T] {
		return [T](list)
	}

	public static func __implicit(_ array: [T]) -> T[] {
		return array.nativeArray
	}

	public static func __explicit(_ array: [T]) -> T[] {
		return array.nativeArray
	}

	public static func __implicit(_ array: [T]) -> PlatformList<T> {
		return array.platformList
	}

	public static func __explicit(_ array: [T]) -> PlatformList<T> {
		return array.platformList
	}

	public static func + <T>(lhs: [T], rhs: [T]) -> [T] {
		var result = lhs
		for i in rhs.GetSequence() {
			result.append(i)
		}
		return result
	}

	public static func + <T>(lhs: Array<T>, rhs: ISequence<T>) -> Array<T> {
		var result = lhs
		for i in rhs {
			result.append(i)
		}
		return result
	}

	public static func == (lhs: [T], rhs: [T]) -> Bool {
		if lhs.list == rhs.list {
			return true
		}
		guard lhs.count == rhs.count else {
			return false
		}
		for i in 0..<lhs.list.count {
			let l = lhs.list[i]
			let r = rhs.list[i]
			if !compareElements(l,r) {
				return false
			}
		}
		return true
	}

	public static func != (lhs: [T], rhs: [T]) -> Bool {
		return !(rhs == lhs)
	}

	#if CLR
	public override func Equals(_ other: Object!) -> Bool {
		guard let other = other as? [T] else {
			return false
		}
		return self == other
	}
	#elseif COCOA
	public override func isEqual(_ other: Object!) -> Bool {
		guard let other = other as? [T] else {
			return false
		}
		return self == other
	}
	#endif

	//
	// Native access & Conversions
	//

	public var platformList: PlatformList<T>
	{
		#if COOPER || ECHOES || ISLAND
		return PlatformList<T>(list)
		#elseif TOFFEE
		return list.mutableCopy()
		#endif
	}

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

	//
	// Subscrits
	//

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
			makeUnique()
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

	func starts(with possiblePrefix: ISequence<T>) -> Bool {
		var i = 0
		for e in possiblePrefix {
			if !compareElements(e, self[i]) {
				return false
			}
		}
		return true
	}

	func starts(with possiblePrefix: [T]) -> Bool {
		return starts(with: possiblePrefix.GetSequence())
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

	public mutating func append(_ newElement: T¡) {
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

	public mutating func insert(_ newElement: T¡, at index: Int) {
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

	public mutating func remove(_ object: T¡) {
		makeUnique()
		#if JAVA
		list.remove(object)
		#elseif CLR | ISLAND
		list.Remove(object)
		#elseif COCOA
		list.removeObject(object)
		#endif
	}

	@discardableResult public mutating func removeLast() -> T¡ {
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
			list = PlatformList<T>()
			unique = true
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

	//public mutating func shuffle() {
		//makeUnique()
		////TODO
	//}
	////public mutating func shuffle<T>(using: inout T) {
		////makeUnique()
		////TODO
	////}
	//public func shuffled() -> [T] {
		//var result = self
		//result.shuffle()
		//return result
	//}

	public func enumerated() -> ISequence<(Int, T)> {
		var index = 0
		for element in self {
			__yield (index++, element)
		}
	}

	public func lazy() -> ISequence<T> {
		return list
	}

	private mutating func QuickSort(_ aLeft: Integer, _ aRight: Integer, by isOrderedBefore: (T, T) -> Bool) {
		var aLeft = aLeft
		while aLeft < aRight {
			var L = aLeft - 1
			var R = aRight + 1
			var Pivot = self[(aLeft + aRight) / 2]

			while true {
				repeat {
					R -= 1
				} while isOrderedBefore(Pivot, self[R])

				repeat {
					L += 1
				} while isOrderedBefore(self[L], Pivot)

				if L < R {
					swapAt(L, R)
				} else {
					break
				}
			}

			if aLeft < R {
				QuickSort(aLeft, R, by: isOrderedBefore)
			}
			aLeft = R + 1
		}
	}

	public mutating func sort(by isOrderedBefore: (T, T) -> Bool) {
		makeUnique()
		QuickSort(0, count-1, by: isOrderedBefore)
	}

	public func sorted(by isOrderedBefore: (T, T) -> Bool) -> [T] {
		var result = self
		result.sort(by: isOrderedBefore)
		return result
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

	func joined(separator: String) -> String {
		#if JAVA | CLR | ISLAND
		let result = NativeStringBuilder()
		for i in 0..<count {
			if i != 0, let separator = separator {
				result.Append(separator)
			}
			result.Append(self[i]?.ToString())
		}
		return result.ToString()!
		#elseif COCOA
		return list.componentsJoinedByString(separator)
		#endif
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

	private static func compareElements(_ r: T, _ l: T) -> Bool {
		if l == nil {
			return r == nil
		}
		if r == nil {
			return false
		}
		#if COOPER
		return l.equals(r)
		#elseif ECHOES
		return System.Collections.Generic.EqualityComparer<T>.Default.Equals(l, r)
		#elseif ISLAND
		return RemObjects.Elements.System.EqualityComparer.Equals(l, r)
		#elseif COCOA
		return l.isEqual(r)
		#endif
		return true
	}

}

#if !COCOA
public extension Swift.Array : ISequence<T> {

	#if JAVA
	public func iterator() -> Iterator<T>! {
		return list.iterator()
	}
	#endif

	#if ECHOES
	@Implements(typeOf(System.Collections.IEnumerable), "GetEnumerator")
	func GetEnumeratorNG() -> System.Collections.IEnumerator! {
		return list.GetEnumerator()
	}

	public func GetEnumerator() -> IEnumerator<T>! {
		return list.GetEnumerator()
	}
	#endif

	#if ISLAND
  @Implements(typeOf(IEnumerable), "GetEnumerator")
	func GetEnumeratorNG() -> IEnumerator! {
		return list.GetEnumerator()
	}

	public func GetEnumerator() -> IEnumerator<T>! {
		return list.GetEnumerator()
	}
	#endif
}
#endif

//public extension Swift.Array where T : ICollection {
	////func joined() -> ISequence<T> { // FlattenCollection<Array<Element>> {
	////return self.platformList.Join()
	////}
	////func joined() -> ISequence<T> { // FlattenSequence<Array<Element>>
	////}

	////func joined(separator: Separator) -> ISequence<T> { // JoinedSequence<Array<Element>>
	////}
//}