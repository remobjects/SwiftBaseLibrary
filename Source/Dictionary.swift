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
	public convenience init(items: [Key:Value]) {
	  var litems = items;
	  self = Dictionary<Key, Value>(copy: &litems)
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

	@Sequence
	public func GetSequence() -> ISequence<(Key, Value)> {
		return DictionaryHelper.Enumerate<Key, Value>(dictionary)
	}

	//
	// Casts
	//

	// Cast from/to platform type

	public static func __implicit(_ dictionary: PlatformDictionary<Key,Value>) -> [Key:Value] {
		return [Key:Value](dictionary)
	}

	public static func __implicit(_ dictionary: [Key:Value]) -> PlatformDictionary<Key,Value> {
		return dictionary.platformDictionary
	}

	// Darwin only: cast from/to Cocoa type

	#if DARWIN
	#if ISLAND
	public static func __implicit(_ dictionary: NSDictionary<Key,Value>) -> [Key:Value] {
		return PlatformDictionary<Key,Value>(dictionary)
	}

	public static func __implicit(_ dictionary: [Key:Value]) -> NSDictionary<Key,Value> {
		return dictionary.dictionary.ToNSDictionary()
	}

	public static func __implicit(_ dictionary: [Key:Value]) -> NSMutableDictionary<Key,Value> {
		return dictionary.dictionary.ToNSMutableDictionary()
	}
	#else
	public static func __implicit(_ dictionary: [Key:Value]) -> PlatformImmutableDictionary<Key,Value> {
		return dictionary.platformDictionary
	}
	#endif

	// Cocoa only: cast from/to different generic Cocoa type

	public static func __explicit<Key2,Value2>(_ dictionary: NSDictionary<Key2,Value2>) -> [Key:Value] {
		return (dictionary as! NSDictionary<Key,Value>) as! [Key:Value]
	}

	public static func __explicit<Key2,Value2>(_ dictionary: [Key:Value]) -> NSDictionary<Key2,Value2> {
		return (dictionary as! NSDictionary<Key,Value>) as! NSDictionary<Key2,Value2>
	}

	public static func __explicit<Key2,Value2>(_ dictionary: [Key:Value]) -> NSMutableDictionary<Key2,Value2> {
		return (dictionary as! NSMutableDictionary<Key,Value>) as! NSMutableDictionary<Key2,Value2>
	}
	#endif

	//
	// Operators
	//

	public static func + <T>(lhs: [Key:Value], rhs: [Key:Value]) -> [Key:Value] {
		var result = lhs
		for k in rhs.keys {
			result[k] = rhs[k]
		}
		return result
	}

	public static func == (lhs: [Key:Value], rhs: [Key:Value]) -> Bool {
		if lhs.dictionary == rhs.dictionary {
			return true
		}
		guard lhs.keys.count == rhs.keys.count else {
			return false
		}

		func compare(_ r: Value, _ l: Value) -> Bool {
			#if COOPER
			return l.equals(r)
			#elseif ECHOES
			return System.Collections.Generic.EqualityComparer<Value>.Default.Equals(l, r)
			#elseif ISLAND
			return RemObjects.Elements.System.EqualityComparer.Equals(l, r)
			#elseif COCOA
			return l.isEqual(r)
			#endif
			return true
		}

		for k in lhs.keys {
			let l = lhs[k]!
			let r = rhs[k]
			guard let r = r else {
				return false
			}
			if !compare(l,r) {
				return false
			}
		}
		for k in rhs.keys {
			let l = lhs[k]!
			if l == nil {
				return false
			}
		}
		return true
	}

	public static func != (lhs: [Key:Value], rhs: [Key:Value]) -> Bool {
		return !(rhs == lhs)
	}

	#if CLR
	public override func Equals(_ other: Object!) -> Bool {
		guard let other = other as? [Key:Value] else {
			return false
		}
		return self == other
	}
	#elseif COCOA
	public override func isEqual(_ other: Object!) -> Bool {
		guard let other = other as? [Key:Value] else {
			return false
		}
		return self == other
	}
	#endif

	//
	// Native Access
	//

	public var platformDictionary: PlatformDictionary<Key,Value>
	{
		#if COOPER || ECHOES || ISLAND
		return PlatformDictionary<Key,Value>(dictionary)
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

	public var keys: ISequence<Key> { // we deliberatey return a sequence, not an dictionary, for efficiency and flexibility.
		#if JAVA
		return dictionary.keySet()
		#elseif CLR || ISLAND
		return dictionary.Keys
		#elseif COCOA
		return dictionary.allKeys as! ISequence<Key>
		#endif
	}

	public var values: ISequence<Value> { // we deliberatey return a sequence, not an dictionary, for efficiency and flexibility.
		#if JAVA
		return dictionary.values()
		#elseif CLR || ISLAND
		return dictionary.Values
		#elseif COCOA
		return dictionary.allValues as! ISequence<Value>
		#endif
	}

	@ToString
	public override func description() -> String {
		return dictionary.description
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