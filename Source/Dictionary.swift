#if COOPER
import java.util
import com.remobjects.elements.linq
#elseif ECHOES
import System.Collections.Generic
import System.Linq
#elseif NOUGAT
import Foundation
import RemObjects.Elements.Linq
#endif


#if NOUGAT
__mapped public class Dictionary<Key: class, INSCopying, Value: class> /*: INSFastEnumeration<T>*/ => Foundation.NSMutableDictionary {
#elseif COOPER
__mapped public class Dictionary<Key,Value> => java.util.HashMap<Key,Value> {
#elseif ECHOES
__mapped public class Dictionary<Key,Value> => System.Collections.Generic.Dictionary<Key,Value> {
#endif

	public init() {
		#if COOPER
		return java.util.HashMap<Key,Value>()
		#elseif ECHOES
		return System.Collections.Generic.Dictionary<Key,Value>()
		#elseif NOUGAT
		return Foundation.NSMutableDictionary()
		#endif
	}

	public init(minimumCapacity: Int) {
		#if COOPER
		return java.util.HashMap<Key,Value>(minimumCapacity)
		#elseif ECHOES
		return System.Collections.Generic.Dictionary<Key,Value>(minimumCapacity)
		#elseif NOUGAT
		return Foundation.NSMutableDictionary(capacity: minimumCapacity)
		#endif
	}

	#if NOUGAT
	public init (NSDictionary dictionary: NSDictionary) {
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
			#if COOPER
			if __mapped.containsKey(key) {
				return __mapped[key]
			}
			return nil
			#elseif ECHOES
			if __mapped.ContainsKey(key) {
				return __mapped[key]
			}
			return nil
			#elseif NOUGAT
			return __mapped[key]
			#endif
		}
		set {
			#if COOPER
			if let v = newValue {
				__mapped[key] = v
			} else { 
					if __mapped.containsKey(key) {
					__mapped.remove(key)
				} 
			}
			#elseif ECHOES
			if let v = newValue {
				__mapped[key] = v
			} else { 
					if __mapped.ContainsKey(key) {
					__mapped.Remove(key)
				} 
			}
			#elseif NOUGAT
			if let val = newValue {
				__mapped[key] = val
			} else {
				__mapped.removeObjectForKey(key)
			}
			#endif
		}
	}

	public mutating func updateValue(value: Value, forKey key: Key) -> Value? {
		#if COOPER
		if __mapped.containsKey(key) {
			let old = __mapped[key]
			__mapped[key] = value
			return old
		}
		return nil
		#elseif ECHOES
		if __mapped.ContainsKey(key) {
			let old = __mapped[key]
			__mapped[key] = value
			return old
		}
		return nil
		#elseif NOUGAT
		let old = __mapped[key]
		if let val = value {
			__mapped[key] = val
		} else {
			__mapped.removeObjectForKey(key)
		}
		return old
		#endif
	}

	public mutating func removeValueForKey(key: Key) -> Value? {
		#if COOPER
		if __mapped.containsKey(key) {
			return __mapped.remove(key)
		}
		return nil
		#elseif ECHOES
		if __mapped.ContainsKey(key) {
			let old = __mapped[key]
			__mapped.Remove(key)
			return old
		}
		return nil
		#elseif NOUGAT
		let old = __mapped[key]
		__mapped.removeObjectForKey(key)
		return old
		#endif
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

	public var count: Int {
		#if COOPER
		return __mapped.keySet().Count()
		#elseif ECHOES
		return __mapped.Count()
		#elseif NOUGAT
		return __mapped.count
		#endif
	}

	public var isEmpty: Bool { 
		#if COOPER
		return __mapped.isEmpty()
		#elseif ECHOES
		return __mapped.Count() == 0
		#elseif NOUGAT
		return __mapped.count == 0
		#endif
	}

	public var keys: ISequence<Key> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if COOPER
		return __mapped.keySet()
		#elseif ECHOES
		return __mapped.Keys
		#elseif NOUGAT
		return __mapped.allKeys as! ISequence<Key> 
		#endif
	}

	public var values: ISequence<Value> { // we deliberatey return a sequence, not an array, for efficiency and flexibility.
		#if COOPER
		return __mapped.values()
		#elseif ECHOES
		return __mapped.Values
		#elseif NOUGAT
		return __mapped.allValues as! ISequence<Value>
		#endif
	}
}