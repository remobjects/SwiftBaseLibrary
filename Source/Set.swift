__mapped public class Set<T> : 
  #if COCOA
  INSFastEnumeration<T>
  #elseif JAVA
  Iterable<T>
  #elseif CLR
  IEnumerable<T>
  #elseif ISLAND
  ISequence<T>
  #else 
  #error Unknown platfomr
  #endif
  ,IExpressibleByArrayLiteral
=> 

  #if COCOA
  Foundation.NSMutableSet 
  #elseif JAVA
  java.util.ArrayList<T> 
  #elseif CLR
  System.Collections.Generic.List<T> 
  #elseif ISLAND
  RemObjects.Elements.System.List<T> 
  #else
  #error Unknown platfomr
  #endif
{
	typealias Element = T
	//typealias Index = SetIndex<T>
	//typealias GeneratorType = SetGenerator<T>

	/// Create an empty `Set`.
	public init() {
		#if JAVA
		return ArrayList<T>()
		#elseif CLR | ISLAND
		return List<T>()
		#elseif COCOA
		return NSMutableSet.set()
		#endif
	}

	/// Create an empty set with at least the given number of
	/// elements worth of storage.  The actual capacity will be the
	/// smallest power of 2 that's >= `minimumCapacity`.
	public init(minimumCapacity: Int) {
		#if JAVA
		return ArrayList<T>()
		#elseif CLR | ISLAND
		return List<T>()
		#elseif COCOA
		return NSMutableSet.setWithCapacity(minimumCapacity)
		#endif
	}

	public init(arrayLiteral elements: T...) {
		if elements == nil || length(elements) == 0 {
			return Set<T>()
		}

		#if JAVA
		return ArrayList<T>(java.util.Arrays.asList(elements))
		#elseif CLR | ISLAND
		return List<T>(elements)
		#elseif COCOA
		return NSMutableSet.setWithObjects((&elements[0] as! UnsafePointer<id>), count: length(elements))
		#endif
	}

	/// Create a `Set` from a finite sequence of items.
	//init<S : SequenceType where T == T>(_ sequence: S) { // Generics not allowed here
	//}

	/// The position of the first element in a non-empty set.
	///
	/// This is identical to `endIndex` in an empty set.
	///
	/// Complexity: amortized O(1) if `self` does not wrap a bridged
	/// `NSSet`, O(N) otherwise.
	//var startIndex: SetIndex<T> { get }


	/// The collection's "past the end" position.
	///
	/// `endIndex` is not a valid argument to `subscript`, and is always
	/// reachable from `startIndex` by zero or more applications of
	/// `successor()`.
	///
	/// Complexity: amortized O(1) if `self` does not wrap a bridged
	/// `NSSet`, O(N) otherwise.
	//var endIndex: SetIndex<T> { get }

	/// Returns `true` if the set contains a member.
	public func contains(_ member: T) -> Bool {
		#if JAVA
		return __mapped.contains(member)
		#elseif CLR | ISLAND
		return __mapped.Contains(member)
		#elseif COCOA
		return __mapped.containsObject(member)
		#endif
	}

	/// Returns the `Index` of a given member, or `nil` if the member is not
	/// present in the set.
	//func indexOf(member: T) -> SetIndex<T>? {
	// }

	/// Insert a member into the set.
	public mutating func insert(_ member: T) {
		#if JAVA
		if !__mapped.contains(member) {
			__mapped.add(member)
		}
		#elseif CLR | ISLAND
		if !__mapped.Contains(member) {
			__mapped.Add(member)
		}
		#elseif COCOA
		if !__mapped.containsObject(member) {
			__mapped.addObject(member)
		}
		#endif
	}

	/// Remove the member from the set and return it if it was present.
	public mutating func remove(_ member: T) -> T? {
		#if JAVA
		if __mapped.contains(member) {
			__mapped.remove(member)
			return member
		}
		#elseif CLR | ISLAND
		if __mapped.Contains(member) {
			__mapped.Remove(member)
			return member
		}
		#elseif COCOA
		if __mapped.containsObject(member) {
			__mapped.removeObject(member)
			return member
		}
		#endif
		return nil
	}

	/// Remove the member referenced by the given index.
	mutating func remove(at index: /*SetIndex<T>*/Int) -> T {
		#if JAVA
		let result = __mapped.get(index)
		__mapped.remove(index)
		#elseif CLR | ISLAND
		let result = __mapped[index]
		__mapped.RemoveAt(index)
		#elseif COCOA
		let result = __mapped.allObjects[index]
		__mapped.removeObject(result)
		#endif
		return result
	}

	/// Erase all the elements.  If `keepCapacity` is `true`, `capacity`
	/// will not decrease.
	public mutating func removeAll(keepCapacity: Bool = false) {
		#if JAVA
		__mapped.clear()
		#elseif CLR | ISLAND
		__mapped.Clear()
		#elseif COCOA
		__mapped.removeAllObjects()
		#endif
	}

	/// Remove a member from the set and return it. Requires: `count > 0`.
	mutating func removeFirst() -> T {
		#if JAVA
		let result = __mapped.get(0)
		__mapped.remove(0)
		#elseif CLR | ISLAND
		let result = __mapped[0]
		__mapped.RemoveAt(0)
		#elseif COCOA
		let result = __mapped.allObjects[0]
		__mapped.removeObject(result)
		#endif
		return result
	}

	/// The number of members in the set.
	///
	/// Complexity: O(1)
	public var count: Int {
		#if JAVA
		return __mapped.size()
		#elseif CLR | ISLAND
		return __mapped.Count
		#elseif COCOA
		return __mapped.count
		#endif
	}

	public var isEmpty: Bool {
		return count == 0
	}

	subscript (position: Int/*SetIndex<T>*/) -> T {
		#if JAVA
		return __mapped.get(position)
		#elseif CLR | ISLAND
		return __mapped[position]
		#elseif COCOA
		return __mapped.allObjects[position]
		#endif
	}

	/// Return a *generator* over the members.
	///
	/// Complexity: O(1)
	//func generate() -> SetGenerator<T>

	/// A member of the set, or `nil` if the set is empty.
	public var first: T? {
		if count > 0 {
			#if JAVA || CLR || ISLAND
			return __mapped[0]
			#elseif COCOA
			return __mapped.allObjects[0]
			#endif
		}
		return nil
	}

	/// Returns true if the set is a subset of a finite sequence as a `Set`.
	/*func isSubsetOf<S : SequenceType where T == T>(sequence: S) -> Bool

	/// Returns true if the set is a subset of a finite sequence as a `Set`
	/// but not equal.
	func isStrictSubsetOf<S : SequenceType where T == T>(sequence: S) -> Bool

	/// Returns true if the set is a superset of a finite sequence as a `Set`.
	func isSupersetOf<S : SequenceType where T == T>(sequence: S) -> Bool

	/// Returns true if the set is a superset of a finite sequence as a `Set`
	/// but not equal.
	func isStrictSupersetOf<S : SequenceType where T == T>(sequence: S) -> Bool

	/// Returns true if no members in the set are in a finite sequence as a `Set`.
	func isDisjointWith<S : SequenceType where T == T>(sequence: S) -> Bool

	/// Return a new `Set` with items in both this set and a finite sequence.
	func union<S : SequenceType where T == T>(sequence: S) -> Set<T>

	/// Insert elements of a finite sequence into this `Set`.
	mutating func unionInPlace<S : SequenceType where T == T>(sequence: S)

	/// Return a new set with elements in this set that do not occur
	/// in a finite sequence.
	func subtract<S : SequenceType where T == T>(sequence: S) -> Set<T>

	/// Remove all members in the set that occur in a finite sequence.
	mutating func subtractInPlace<S : SequenceType where T == T>(sequence: S)

	/// Return a new set with elements common to this set and a finite sequence.
	func intersect<S : SequenceType where T == T>(sequence: S) -> Set<T>

	/// Remove any members of this set that aren't also in a finite sequence.
	mutating func intersectInPlace<S : SequenceType where T == T>(sequence: S)

	/// Return a new set with elements that are either in the set or a finite
	/// sequence but do not occur in both.
	func exclusiveOr<S : SequenceType where T == T>(sequence: S) -> Set<T>

	/// For each element of a finite sequence, remove it from the set if it is a
	/// common element, otherwise add it to the set. Repeated elements of the
	/// sequence will be ignored.
	mutating func exclusiveOrInPlace<S : SequenceType where T == T>(sequence: S)*/

	public func subtracting(_ anotherSet: Set<T>) -> Set<T> {
		var result = Set<T>()
		if (!anotherSet.isEmpty && !self.isEmpty) {
			for elem in self {
				if (!anotherSet.contains(elem)) {
					result.insert(elem)
				}
			}
		}
		return result
	}

	/*public func subtract(_ anotherSequence: ISequence<T>) -> Set<T> {
		var result = Set<T>()
		//74103: Silver: can't find (one specific) extension method on ISequence
		var array = anotherSequence.toSwiftArray()
		if (!array.isEmpty && !self.isEmpty) {
			for elem in self {
				if (!array.contains(elem)) {
					result.insert(elem)
				}
			}
		}
		return result
	}*/
	// todo: port others to Sequence as well.

	public func intersection(_ anotherSet: Set<T>) -> Set<T> {
		var result = Set<T>()
		if (!anotherSet.isEmpty && !self.isEmpty) {
			for elem in self {
				if (anotherSet.contains(elem)) {
					result.insert(elem)
				}
			}
		}
		return result
	}

	public func union(_ anotherSet: Set<T>) -> Set<T> {
		var result = Set<T>()
		for elem in self {
			result.insert(elem)
		}
		for elem in anotherSet {
			if (!result.contains(elem)) {
				result.insert(elem)
			}
		}
		return result
	}

	public func exclusiveOr(_ anotherSet: Set<T>) -> Set<T> {
		var result = Set<T>()
		for elem in self {
			if (!anotherSet.contains(elem)) {
				result.insert(elem)
			}
		}
		for elem in anotherSet {
			if (!self.contains(elem)) {
				result.insert(elem)
			}
		}
		return result
	}

	public static func + <T>(lhs: Set<T>, rhs: ISequence<T>) -> Set<T> {

		let targetSet = Set<T>().union(lhs)
		for element in rhs {
			targetSet.insert(element)
		}

		return targetSet
	}
	//var hashValue: Int { get }

	/// A textual representation of `self`.
	public var description: String {
		#if JAVA
		return __mapped.toString()
		#elseif CLR || ISLAND
		return __mapped.ToString()
		#elseif COCOA
		return __mapped.description
		#endif
	}

	/// A textual representation of `self`, suitable for debugging.
	public var debugDescription: NativeString {
		return description
	}
}