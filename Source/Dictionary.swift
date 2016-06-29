//
//
// CAUTION: Magic type name. 
// The compiler will map the [:] dictionary syntax to Swift.Dictionaty<T,U> 
//
//

#if COCOA
__mapped public class Dictionary<Key: class, Value: class> /*: INSFastEnumeration<T>*/ => Foundation.NSMutableDictionary {
#elseif JAVA
__mapped public class Dictionary<Key,Value> => java.util.HashMap<Key,Value> {
#elseif CLR
__mapped public class Dictionary<Key,Value> => System.Collections.Generic.Dictionary<Key,Value> {
#elseif ISLAND
__mapped public class Dictionary<Key,Value> => RemObjects.Elements.System.Dictionary<Key,Value> {
#endif

	public init() {
		#if JAVA
		return java.util.HashMap<Key,Value>()
		#elseif CLR
		return System.Collections.Generic.Dictionary<Key,Value>()
		#elseif COCOA
		return Foundation.NSMutableDictionary()
		#endif
	}

	public func GetSequence() -> ISequence<(Key, Value)> {
		return DictionaryHelper.Enumerate<Key, Value>(self)
	}

	public init(minimumCapacity: Int) {
		#if JAVA
		return java.util.HashMap<Key,Value>(minimumCapacity)
		#elseif CLR
		return System.Collections.Generic.Dictionary<Key,Value>(minimumCapacity)
		#elseif COCOA
		return Foundation.NSMutableDictionary(capacity: minimumCapacity)
		#endif
	}

	#if COCOA
	public init(NSDictionary dictionary: NSDictionary) {
		if dictionary == nil {
			return Dictionary<Key,Value>()
		}
		return dictionary.mutableCopy()
	}
	#endif

	public init(dictionaryLiteral elements: (Key, Value)...) {
		var result = init(minimumCapacity: length(elements))
		for e in elements {
			result[e[0]] = e[1]
		}
		return result
	}

	public subscript (key: Key) -> Value? {
		get {
			#if JAVA
			if __mapped.containsKey(key) {
				return __mapped[key]
			}
			return nil
			#elseif CLR
			if __mapped.ContainsKey(key) {
				return __mapped[key]
			}
			return nil
			#elseif COCOA
			return __mapped[key]
			#endif
		}
		set {
			#if JAVA
			if let v = newValue {
				__mapped[key] = v
			} else { 
					if __mapped.containsKey(key) {
					__mapped.remove(key)
				} 
			}
			#elseif CLR
			if let v = newValue {
				__mapped[key] = v
			} else { 
					if __mapped.ContainsKey(key) {
					__mapped.Remove(key)
				} 
			}
			#elseif COCOA
			if let val = newValue {
				__mapped[key] = val
			} else {
				__mapped.removeObjectForKey(key)
			}
			#endif
		}
	}

	public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
		#if JAVA
		if __mapped.containsKey(key) {
			let old = __mapped[key]
			__mapped[key] = value
			return old
		}
		return nil
		#elseif CLR
		if __mapped.ContainsKey(key) {
			let old = __mapped[key]
			__mapped[key] = value
			return old
		}
		return nil
		#elseif COCOA
		let old = __mapped[key]
		if let val = value {
			__mapped[key] = val
		} else {
			__mapped.removeObjectForKey(key)
		}
		return old
		#endif
	}

	public mutating func removeValueForKey(_ key: Key) -> Value? {
		#if JAVA
		if __mapped.containsKey(key) {
			return __mapped.remove(key)
		}
		return nil
		#elseif CLR
		if __mapped.ContainsKey(key) {
			let old = __mapped[key]
			__mapped.Remove(key)
			return old
		}
		return nil
		#elseif COCOA
		let old = __mapped[key]
		__mapped.removeObjectForKey(key)
		return old
		#endif
	}

	public mutating func removeAll(keepCapacity: Bool = false) {
		#if JAVA
		__mapped.clear()
		#elseif CLR
		__mapped.Clear()
		#elseif COCOA
		__mapped.removeAllObjects()
		#endif
	}

	public var count: Int {
		#if JAVA
		return __mapped.keySet().Count()
		#elseif CLR
		return __mapped.Count()
		#elseif COCOA
		return __mapped.count
		#endif
	}

	public var isEmpty: Bool { 
		#if JAVA
		return __mapped.isEmpty()
		#elseif CLR
		return __mapped.Count() == 0
		#elseif COCOA
		return __mapped.count == 0
		#endif
	}

	public var keys: ISequence<Key> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if JAVA
		return __mapped.keySet()
		#elseif CLR
		return __mapped.Keys
		#elseif COCOA
		return __mapped.allKeys as! ISequence<Key> 
		#endif
	}

	public var values: ISequence<Value> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if JAVA
		return __mapped.values()
		#elseif CLR
		return __mapped.Values
		#elseif COCOA
		return __mapped.allValues as! ISequence<Value>
		#endif
	}
}

public static class DictionaryHelper {
	#if JAVA
	public static func Enumerate<Key, Value>(_ val: java.util.HashMap<Key,Value>) -> ISequence<(Key, Value)> {
		for entry in val.entrySet() { 
			var item: (Key, Value) =  (entry.Key, entry.Value)
		  __yield item
		}
	}
	#elseif CLR
	public static func Enumerate<Key, Value>(_ val: System.Collections.Generic.Dictionary<Key,Value>) -> ISequence<(Key, Value)> {
		for entry in val { 
			var item: (Key, Value) =  (entry.Key, entry.Value)
		  __yield item
		}
	}
	#elseif ISLAND
	public static func Enumerate<Key, Value>(_ val: RemObjects.Elements.System.Dictionary<Key,Value>) -> ISequence<(Key, Value)> {
		for entry in val { 
			var item: (Key, Value) =  (entry.Key, entry.Value)
		  __yield item
		}
	}
	#elseif COCOA
	public static func Enumerate<Key, Value>(_ val: NSMutableDictionary) -> ISequence<(Key, Value)> {
		for entry in val { 
			var item: (Key, Value) =  (entry, val[entry]?)
		  __yield item
		}
	}
	#endif
}