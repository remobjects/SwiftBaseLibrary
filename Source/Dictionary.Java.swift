#if JAVA
public extension Swift.Dictionary : java.util.Map<Key,Value> {

	public func size() -> Int32 {
		return dictionary.size()
	}
	public func isEmpty() -> Bool {
		return dictionary.isEmpty()
	}
	public func containsKey(_ arg1: Object!) -> Bool {
		return dictionary.containsKey(arg1)
	}
	public func containsValue(_ arg1: Object!) -> Bool {
		return dictionary.containsValue(arg1)
	}
	public func `get`(_ arg1: Object!) -> Value! {
		return dictionary.`get`(arg1)
	}
	public mutating func put(_ arg1: Key!, _ arg2: Value!) -> Value! {
		makeUnique()
		return dictionary.put(arg1, arg1)
	}
	public mutating func remove(_ arg1: Object!, _ arg2: Object!) -> Bool {
		makeUnique()
		return dictionary.remove(arg1, arg1)
	}
	public mutating func remove(_ arg1: Object!) -> Value! {
		makeUnique()
		return dictionary.remove(arg1)
	}
	public mutating func putAll(_ arg1: Map</*? extends Key,? extends Value*/Key,Value>!) {
		makeUnique()
		dictionary.putAll(arg1)
	}
	public mutating func clear() {
		makeUnique()
		dictionary.clear()
	}
	public func keySet() -> java.util.Set<Key>! {
		return platformDictionary.keySet()
	}
	public func values() -> Collection<Value>! {
		return platformDictionary.values()
	}
	public func entrySet() -> java.util.Set<Map.Entry<Key,Value>!>! {
		return platformDictionary.entrySet()
	}
	public override func equals(_ arg1: Object!) -> Bool {
		return dictionary.equals(arg1)
	}
	public override func hashCode() -> Int32 {
		return dictionary.hashCode()
	}
	public func getOrDefault(_ arg1: Object!, _ arg2: Value!) -> Value! {
		return dictionary.getOrDefault(arg1, arg2)
	}
	public func forEach(_ arg1: java.util.function.BiConsumer</*? super Key,? super Value*/Key,Value>!) {
		dictionary.forEach(arg1)
	}
	public mutating func replaceAll(_ arg1: java.util.function.BiFunction</*? super Key,? super Value,? extends Value*/Key,Value>!) {
		makeUnique()
		dictionary.replaceAll(arg1)
	}
	public mutating func putIfAbsent(_ arg1: Key!, _ arg2: Value!) -> Value! {
		makeUnique()
		return dictionary.putIfAbsent(arg1, arg2)
	}
	public mutating func replace(_ arg1: Key!, _ arg2: Value!) -> Value! {
		makeUnique()
		return dictionary.replace(arg1, arg2)
	}
	public mutating func replace(_ arg1: Key!, _ arg2: Value!, _ arg3: Value!) -> Bool {
		makeUnique()
		return dictionary.replace(arg1, arg2, arg3)
	}
	public func computeIfAbsent(_ arg1: Key!, _ arg2: java.util.function.function</*? super Key,? extends Value*/Key,Value>!) -> Value! {
		return dictionary.computeIfAbsent(arg1, arg2)
	}
	public func computeIfPresent(_ arg1: Key!, _ arg2: java.util.function.BiFunction</*? super Key,? super Value,? extends Value*/Key,Value>!) -> Value! {
		return dictionary.computeIfPresent(arg1, arg2)
	}
	public func compute(_ arg1: Key!, _ arg2: java.util.function.BiFunction</*? super Key,? super Value,? extends Value*/Key,Value>!) -> Value! {
		return dictionary.compute(arg1, arg2)
	}
	public mutating func merge(_ arg1: Key!, _ arg2: Value!, _ arg3: java.util.function.BiFunction</*? super Value,? super Value,? extends Value*/Key,Value>!) -> Value! {
		makeUnique()
		return dictionary.merge(arg1, arg2, arg3)
	}
}
#endif