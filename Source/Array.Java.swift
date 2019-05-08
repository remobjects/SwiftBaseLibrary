#if JAVA
public extension Swift.Array : java.util.List<T> {
	public func size() -> Int32 {
		return count
	}
	public func isEmpty() -> Bool {
		return isEmpty
	}
	public func contains(_ arg1: Object!) -> Bool {
		return list.contains(arg1)
	}
    @inline(__always)
	public func toArray<T>(_ arg1: T![]) -> T![] {
		return platformList.toArray<T>(arg1)
	}
    @inline(__always)
	public func toArray() -> Object![] {
		return platformList.toArray()
	}
	mutating func add(_ arg1: Int32, _ arg2: T!) {
		makeUnique()
		list.add(arg1, arg2)
	}
	public mutating func add(_ arg1: T!) -> Bool {
		makeUnique()
		return list.add(arg1)
	}
	public mutating func remove(_ arg1: Int32) -> T! {
		makeUnique()
		return list.remove(arg1)
	}
	public mutating func remove(_ arg1: Object!) -> Bool {
		makeUnique()
		return list.remove(arg1)
	}
	public func containsAll(_ arg1: Collection<T>!) -> Bool {
		return list.containsAll(arg1)
	}
	public mutating func addAll(_ arg1: Int32, _ arg2: Collection</*? extends T*/T>!) -> Bool {
		makeUnique()
		return list.addAll(arg1, arg2)
	}
	public mutating func addAll(_ arg1: Collection</*? extends T*/T>!) -> Bool {
		makeUnique()
		return list.addAll(arg1)
	}
	public mutating func removeAll(_ arg1: Collection<Object>!) -> Bool {
		makeUnique()
		return list.removeAll(arg1)
	}
	public mutating func retainAll(_ arg1: Collection<Object>!) -> Bool {
		makeUnique()
		return list.retainAll(arg1)
	}
	public mutating func replaceAll(_ arg1: java.util.function.UnaryOperator<T>!) {
		makeUnique()
		list.replaceAll(arg1)
	}
	public mutating func sort(_ arg1: Comparator</*? super T*/Object>!) {
		makeUnique()
		list.sort(arg1)
	}
	public mutating func clear() {
		removeAll()
	}
	public override func equals(_ arg1: Object!) -> Bool {
		if let a = arg1 as? [T] {
			return a == self
		}
		return false
	}
	public override func hashCode() -> Int32 {
		return list.hashCode()
	}
	public func indexOf(_ arg1: Object!) -> Int32 {
		return list.indexOf(arg1)
	}
	public func lastIndexOf(_ arg1: Object!) -> Int32 {
		return list.lastIndexOf(arg1)
	}
	public func listIterator(_ arg1: Int32) -> ListIterator<T>! {
		return platformList.listIterator(arg1)
	}
	public func listIterator() -> ListIterator<T>! {
		return platformList.listIterator()
	}
	public func subList(_ arg1: Int32, _ arg2: Int32) -> java.util.List<T>! {
		return self[arg1...arg2]
	}
	public func spliterator() -> Spliterator<T>! {
		return platformList.spliterator()
	}
	public func `get`(_ arg1: Int32) -> T {
		return self[arg1]
	}
	public mutating func `set`(_ arg1: Int32, _ value: T!)  -> T {
		let old = self[arg1]
		self[arg1] = value
		return old
	}
}
#endif