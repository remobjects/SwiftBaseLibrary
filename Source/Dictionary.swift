#if COCOA
public typealias PlatformDictionary<T,U> = NSMutableDictionary<T,U>
public typealias PlatformImmutableDictionary<T,U> = NSDictionary<T,U>
#elseif JAVA
public typealias PlatformDictionary<T,U> = java.util.HashMap<T,U>
public typealias PlatformImmutableDictionary<T,U> = PlatformDictionary<T,U>
#elseif CLR
public typealias PlatformDictionary<T,U> = System.Collections.Generic.Dictionary<T,U>
public typealias PlatformImmutableDictionary<T,U> = PlatformDictionary<T,U>
#elseif ISLAND
public typealias PlatformDictionary<T,U> = RemObjects.Elements.System.Dictionary<T,U>
public typealias PlatformImmutableDictionary<T,U> = PlatformDictionary<T,U>
#endif

//
//
// CAUTION: Magic type name.
// The compiler will map the [:] dictionary syntax to Swift.Dictionaty<T,U>
//
//

public struct Dictionary<Key, Value> /*: INSFastEnumeration<T>*/
{
	public init(copy original: inout [Key:Value]) {
		self.dictionary = original.dictionary
		self.unique = false
		original.unique = false
	}

	public init() {
		dictionary = PlatformDictionary<Key,Value>()
	}

	//public init(items: inout [Key:Value]) { // E59 Duplicate constructor with same signature "init(items var items: [Key:Value])"
	public init(items: [Key:Value]) {
		self.dictionary = items.dictionary
		self.unique = false
		makeUnique() // workaorund for not having inout
		//items.unique = false
	}

	public init(minimumCapacity: Int) {
		#if JAVA
		dictionary = PlatformDictionary<Key,Value>(minimumCapacity)
		#elseif CLR
		dictionary = PlatformDictionary<Key,Value>(minimumCapacity)
		#elseif ISLAND
		dictionary = PlatformDictionary<Key,Value>(minimumCapacity)
		#elseif COCOA
		dictionary = PlatformDictionary(capacity: minimumCapacity)
		#endif
	}

	public init(_ dictionary: PlatformImmutableDictionary<Key,Value>) {
		#if JAVA | CLR | ISLAND
		self.dictionary = PlatformDictionary<Key,Value>(dictionary)
		#elseif COCOA
		self.dictionary = dictionary.mutableCopy
		#endif
		self.unique = false
		makeUnique()
	}

	#if COCOA
	//public init(_ dictionary: NSDictionary) {
		//self.dictionary = dictionary.mutableCopy
	//}
	#endif

	public convenience init(dictionaryLiteral elements: (Key, Value)...) {
		init(minimumCapacity: length(elements))
		for e in elements {
			self[e[0]] = e[1]
		}
	}

	//
	// Storage
	//

	private var dictionary: PlatformDictionary<Key,Value>
	private var unique: Boolean = true

	private mutating func makeUnique()
	{
		if !unique {
			dictionary = platformDictionary // platformDictionary returns a unique new copy
			unique = true
		}
	}

	//
	//
	//

	public func GetSequence() -> ISequence<(Key, Value)> {
		return DictionaryHelper.Enumerate<Key, Value>(dictionary)
	}

	//
	// Operators
	//

	public static func __implicit(_ dictionary: PlatformDictionary<Key,Value>) -> [Key:Value] {
		return [Key:Value](dictionary)
	}

	// 80753: `inout` and implicit cast operators
	//public static func __implicit(_ array: inout [T]) -> PlatformList<T> {
		//return array.list
		//array.unique = false
	//}
	public static func __implicit(_ dictionary: [Key:Value]) -> PlatformDictionary<Key,Value> {
		return dictionary.platformDictionary
	}

	//
	// Native Access
	//

	public var platformDictionary: PlatformDictionary<Key,Value>
	{
		#if COOPER || ECHOES
		return PlatformDictionary<Key,Value>(dictionary)
		#elseif ISLAND
		#warning Implement for Island
		//return PlatformDictionary<Key,Value>(dictionary)
		#elseif TOFFEE
		return dictionary.mutableCopy()
		#endif
	}

	//
	// Subscripts
	//

	public subscript (key: Key) -> Value? {
		get {
			#if JAVA
			if dictionary.containsKey(key) {
				return dictionary[key]
			}
			return nil
			#elseif CLR || ISLAND
			if dictionary.ContainsKey(key) {
				return dictionary[key]
			}
			return nil
			#elseif COCOA
			return dictionary[key]
			#endif
		}
		set {
			makeUnique()
			#if JAVA
			if let v = newValue {
				dictionary[key] = v
			} else {
					if dictionary.containsKey(key) {
					dictionary.remove(key)
				}
			}
			#elseif CLR || ISLAND
			if let v = newValue {
				dictionary[key] = v
			} else {
					if dictionary.ContainsKey(key) {
					dictionary.Remove(key)
				}
			}
			#elseif COCOA
			if let val = newValue {
				dictionary[key] = val
			} else {
				dictionary.removeObjectForKey(key)
			}
			#endif
		}
	}

	public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
		makeUnique()
		#if JAVA
		if dictionary.containsKey(key) {
			let old = dictionary[key]
			dictionary[key] = value
			return old
		}
		return nil
		#elseif CLR || ISLAND
		if dictionary.ContainsKey(key) {
			let old = dictionary[key]
			dictionary[key] = value
			return old
		}
		return nil
		#elseif COCOA
		let old = dictionary[key]
		if let val = value {
			dictionary[key] = val
		} else {
			dictionary.removeObjectForKey(key)
		}
		return old
		#endif
	}

	public mutating func removeValueForKey(_ key: Key) -> Value? {
		makeUnique()
		#if JAVA
		if dictionary.containsKey(key) {
			return dictionary.remove(key)
		}
		return nil
		#elseif CLR || ISLAND
		if dictionary.ContainsKey(key) {
			let old = dictionary[key]
			dictionary.Remove(key)
			return old
		}
		return nil
		#elseif COCOA
		let old = dictionary[key]
		dictionary.removeObjectForKey(key)
		return old
		#endif
	}

	public mutating func removeAll(keepCapacity: Bool = false) {
		dictionary = PlatformDictionary<Key,Value>()
		unique = true
	}

	public var count: Int {
		#if JAVA
		return dictionary.keySet().Count()
		#elseif CLR
		return dictionary.Count()
		#elseif ISLAND
		return dictionary.Count
		#elseif COCOA
		return dictionary.count
		#endif
	}

	public var isEmpty: Bool {
		#if JAVA
		return dictionary.isEmpty()
		#elseif CLR
		return dictionary.Count() == 0
		#elseif ISLAND
		return dictionary.Count == 0
		#elseif COCOA
		return dictionary.count == 0
		#endif
	}

	public var keys: ISequence<Key> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if JAVA
		return dictionary.keySet()
		#elseif CLR || ISLAND
		return dictionary.Keys
		#elseif COCOA
		return dictionary.allKeys as! ISequence<Key>
		#endif
	}

	public var values: ISequence<Value> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if JAVA
		return dictionary.values()
		#elseif CLR || ISLAND
		return dictionary.Values
		#elseif COCOA
		return dictionary.allValues as! ISequence<Value>
		#endif
	}
}

public static class DictionaryHelper {
	#if JAVA
	public static func Enumerate<Key, Value>(_ val: PlatformDictionary<Key,Value>) -> ISequence<(Key, Value)> {
		for entry in val.entrySet() {
			var item: (Key, Value) =  (entry.Key, entry.Value)
		  __yield item
		}
	}
	#elseif CLR | ISLAND
	public static func Enumerate<Key, Value>(_ val: PlatformDictionary<Key,Value>) -> ISequence<(Key, Value)> {
		for entry in val {
			var item: (Key, Value) =  (entry.Key, entry.Value)
		  __yield item
		}
	}
	#elseif COCOA
	public static func Enumerate<Key, Value>(_ val: PlatformDictionary<Key,Value>) -> ISequence<(Key, Value)> {
		for entry in val {
			var item: (Key, Value) =  (entry, val[entry]?)
		  __yield item
		}
	}
	#endif
}