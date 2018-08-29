#if COCOA
typealias PlatformSet<T> = NSMutableSet<T>
#elseif JAVA
typealias PlatformSet<T> = java.util.ArrayList<T>
#elseif CLR
typealias PlatformSet<T> = System.Collections.Generic.List<T>
#elseif ISLAND
typealias PlatformSet<T> = RemObjects.Elements.System.List<T>
#endif

public struct Set<T> //:
  //#if COCOA
  //INSFastEnumeration<T>
  //#elseif JAVA
  //Iterable<T>
  //#elseif CLR
  //IEnumerable<T>
  //#elseif ISLAND
  //ISequence<T>
  //#else
  //#error Unknown platfomr
  //#endif
  //,
  //IExpressibleByArrayLiteral
{
	typealias Element = T
	//typealias Index = SetIndex<T>
	//typealias GeneratorType = SetGenerator<T>

	/// Create an empty `Set`.
	public init() {
		_set = PlatformSet<T>()
	}

	/// Create an empty set with at least the given number of
	/// elements worth of storage.  The actual capacity will be the
	/// smallest power of 2 that's >= `minimumCapacity`.
	public init(minimumCapacity: Int) {
		#if JAVA | CLR | ISLAND
		_set = PlatformSet<T>()
		#elseif COCOA
		_set = PlatformSet<T>.setWithCapacity(minimumCapacity)
		#endif
	}

	public init(arrayLiteral elements: T...) {
		if elements == nil || length(elements) == 0 {
			_set = PlatformSet<T>()
			return
		}

		#if JAVA
		_set = PlatformSet<T>(java.util.Arrays.asList(elements))
		#elseif CLR | ISLAND
		_set = PlatformSet<T>(elements)
		#elseif COCOA
		_set = PlatformSet<T>.setWithObjects((&elements[0] as! UnsafePointer<T>), count: length(elements)) as! PlatformSet<T>
		#endif
	}

	#if COCOA
	public init(_ theSet: PlatformSet<T>) {
		_set = theSet.mutableCopy
	}
	#endif

	//public init(_ elements: T...) { // E59 Duplicate constructor with same signature "init(params elements: T[])"
		//init(arrayLiteral: elements)
	//}

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


	//
	// Storage
	//

	fileprivate var _set: PlatformSet<T>
	private var unique: Boolean = true

	private mutating func makeUnique()
	{
		if !unique {
			_set = platformSet // platformSet returns a unique new copy
			unique = true
		}
	}

	//
	//
	//

	public func GetSequence() -> ISequence<T> {
		return _set
	}

	//
	// Operators
	//

	#if COCOA // only Cocoa has a Set class where this makes sense
	public static func __implicit(_ theSet: PlatformSet<T>) -> Set<T> {
		return Set<T>(theSet)
	}

	public static func __implicit(_ theSet: Set<T>) -> PlatformSet<T> {
		return theSet.platformSet
	}
	#endif

	public static func + (lhs: Set<T>, rhs: ISequence<T>) -> Set<T> {
		var targetSet = Set<T>().union(lhs)
		for element in rhs {
			targetSet.insert(element)
		}
		return targetSet
	}

	// workarund, while sets aren't sequences (yet)
	public static func + (lhs: Set<T>, rhs: Set<T>) -> Set<T> {
		return lhs + rhs._set
	}

   public static func == (lhs: Set<T>, rhs: Set<T>) -> Bool {
		if lhs._set == rhs._set {
			return true
		}
		guard lhs.count == rhs.count else {
			return false
		}

		for i in lhs {
			if !rhs.contains(i) {
				return false
			}
		}
		for i in rhs {
			if !lhs.contains(i) {
				return false
			}
		}
		return true
	}

	public static func != (lhs: Set<T>, rhs: Set<T>) -> Bool {
		return !(rhs == lhs)
	}

	//
	// Native access & Conversions
	//

	#if !COCOA
	private
	#endif
	var platformSet: PlatformSet<T>
	{
		#if COOPER || ECHOES || ISLAND
		return PlatformSet<T>(_set)
		#elseif TOFFEE
		return _set.mutableCopy()
		#endif
	}



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
		return _set.contains(member)
		#elseif CLR | ISLAND
		return _set.Contains(member)
		#elseif COCOA
		return _set.containsObject(member)
		#endif
	}

	/// Returns the `Index` of a given member, or `nil` if the member is not
	/// present in the set.
	func indexOf(member: T) -> /*SetIndex<T>*/Int? {
		#if JAVA
		if _set.contains(member) {
			return _set.indexOf(member)
		}
		#elseif CLR | ISLAND
		if _set.Contains(member) {
			return _set.IndexOf(member)
		}
		#elseif COCOA
		throw Exception("Not implemented for Cocosa")
		//if _set.containsObject(member) {
			//return _set.indexOf(member)
		//}
		#endif
		return nil
	}

	/// Insert a member into the set.
	public mutating func insert(_ member: T) {
		makeUnique()
		#if JAVA
		if !_set.contains(member) {
			_set.add(member)
		}
		#elseif CLR | ISLAND
		if !_set.Contains(member) {
			_set.Add(member)
		}
		#elseif COCOA
		if !_set.containsObject(member) {
			_set.addObject(member)
		}
		#endif
	}

	/// Remove the member from the set and return it if it was present.
	public mutating func remove(_ member: T) -> T? {
		makeUnique()
		#if JAVA
		if _set.contains(member) {
			_set.remove(member)
			return member
		}
		#elseif CLR | ISLAND
		if _set.Contains(member) {
			_set.Remove(member)
			return member
		}
		#elseif COCOA
		if _set.containsObject(member) {
			_set.removeObject(member)
			return member
		}
		#endif
		return nil
	}

	/// Remove the member referenced by the given index.
	mutating func remove(at index: /*SetIndex<T>*/Int) -> T {
		makeUnique()
		#if JAVA
		let result = _set.get(index)
		_set.remove(index)
		#elseif CLR | ISLAND
		let result = _set[index]
		_set.RemoveAt(index)
		#elseif COCOA
		let result = _set.allObjects[index]
		_set.removeObject(result)
		#endif
		return result
	}

	/// Erase all the elements.  If `keepCapacity` is `true`, `capacity`
	/// will not decrease.
	public mutating func removeAll(keepCapacity: Bool = false) {
		if count > 0 {
			if !keepCapacity {
				_set = PlatformSet<T>()
				unique = true
				return
			}
			makeUnique()
			#if JAVA
			_set.clear()
			#elseif CLR | ISLAND
			_set.Clear()
			#elseif COCOA
			_set.removeAllObjects()
			#endif
		}
	}

	/// Remove a member from the set and return it. Requires: `count > 0`.
	mutating func removeFirst() -> T {
		makeUnique()
		#if JAVA
		let result = _set.get(0)
		_set.remove(0)
		#elseif CLR | ISLAND
		let result = _set[0]
		_set.RemoveAt(0)
		#elseif COCOA
		let result = _set.allObjects[0]
		_set.removeObject(result)
		#endif
		return result
	}

	/// The number of members in the set.
	///
	/// Complexity: O(1)
	public var count: Int {
		#if JAVA
		return _set.size()
		#elseif CLR | ISLAND
		return _set.Count
		#elseif COCOA
		return _set.count
		#endif
	}

	public var isEmpty: Bool {
		return count == 0
	}

	subscript (position: Int/*SetIndex<T>*/) -> T {
		#if JAVA
		return _set.get(position)
		#elseif CLR | ISLAND
		return _set[position]
		#elseif COCOA
		return _set.allObjects[position]
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
			return _set[0]
			#elseif COCOA
			return _set.allObjects[0]
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

	//var hashValue: Int { get }

	/// A textual representation of `self`.
	@ToString public func description() -> String {
		#if JAVA
		return _set.toString()
		#elseif CLR || ISLAND
		return _set.ToString()
		#elseif COCOA
		return _set.description
		#endif
	}
}

#if !COCOA
public extension Swift.Set : ISequence<T> {

	#if JAVA
	public func iterator() -> Iterator<T>! {
		return _set.iterator()
	}
	#endif

	#if ECHOES
	func GetEnumerator() -> IEnumerator! {
		return _set.GetEnumerator()
	}

	@Implements(typeOf(IEnumerable<T>), "GetEnumerator")
	func GetEnumeratorT() -> IEnumerator<T>! {
		return _set.GetEnumerator()
	}
	#endif

	#if ISLAND
	func GetEnumerator() -> IEnumerator<T>! {
		return _set.GetEnumerator()
	}
	#endif
}
#endif