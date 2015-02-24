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
__mapped public class Set<T: class> : INSFastEnumeration<T> => Foundation.NSMutableSet {
#elseif COOPER
__mapped public class Set<T> : Iterable<T> => java.util.ArrayList<T> {
#elseif ECHOES
__mapped public class Set<T> : IEnumerable<T> => System.Collections.Generic.List<T> {
#endif
	typealias Element = T
	//typealias Index = SetIndex<T>
	//typealias GeneratorType = SetGenerator<T>

	/// Create an empty `Set`.
	init() {
		#if COOPER
		return ArrayList<T>()
		#elseif ECHOES
		return List<T>()
		#elseif NOUGAT
		return NSMutableSet.set()
		#endif
	}

	/// Create an empty set with at least the given number of
	/// elements worth of storage.  The actual capacity will be the
	/// smallest power of 2 that's >= `minimumCapacity`.
	init(minimumCapacity: Int) {
		#if COOPER
		return ArrayList<T>()
		#elseif ECHOES
		return List<T>()
		#elseif NOUGAT
		return NSMutableSet.setWithCapacity(minimumCapacity)
		#endif
	}

	init(arrayLiteral elements: T...) {
		if elements == nil || length(elements) == 0 {
			return Set<T>()
		}
		
		#if COOPER
		return ArrayList<T>(java.util.Arrays.asList(elements))
		#elseif ECHOES
		return List<T>(elements)
		#elseif NOUGAT
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
	func contains(member: T) -> Bool {
		#if COOPER
		return __mapped.contains(member)
		#elseif ECHOES
		return __mapped.Contains(member)
		#elseif NOUGAT
		return __mapped.containsObject(member)
		#endif
	}

	/// Returns the `Index` of a given member, or `nil` if the member is not
	/// present in the set.
	//func indexOf(member: T) -> SetIndex<T>? {
	// }

	/// Insert a member into the set.
	mutating func insert(member: T) {
		#if COOPER
		if !__mapped.contains(member) {
			__mapped.add(member)
		}
		#elseif ECHOES
		if !__mapped.Contains(member) {
			__mapped.Add(member)
		}
		#elseif NOUGAT
		if !__mapped.containsObject(member) {
			__mapped.addObject(member)
		}
		#endif
	}

	/// Remove the member from the set and return it if it was present.
	mutating func remove(member: T) -> T? {
	}

	/// Remove the member referenced by the given index.
	//mutating func removeAtIndex(index: SetIndex<T>) {
	//}

	/// Erase all the elements.  If `keepCapacity` is `true`, `capacity`
	/// will not decrease.
	mutating func removeAll(keepCapacity: Bool = default) {
	}

	/// Remove a member from the set and return it. Requires: `count > 0`.
	mutating func removeFirst() -> T {
	}

	/// The number of members in the set.
	///
	/// Complexity: O(1)
	public var count: Int {
		#if COOPER
		return __mapped.size()
		#elseif ECHOES
		return __mapped.Count
		#elseif NOUGAT
		return __mapped.count
		#endif
	}

	var isEmpty: Bool { 
		return count == 0 
	}
	
	//subscript (position: SetIndex<T>) -> T { get }

	/// Return a *generator* over the members.
	///
	/// Complexity: O(1)
	//func generate() -> SetGenerator<T>

	/// A member of the set, or `nil` if the set is empty.
	var first: T? { 
		if count > 0 {
			#if COOPER || ECHOES
			return __mapped[0]
			#elseif NOUGAT
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

	//var hashValue: Int { get }

	/// A textual representation of `self`.
	var description: String { 
		#if COOPER
		return __mapped.toString()
		#elseif ECHOES
		return __mapped.ToString()
		#elseif NOUGAT
		return __mapped.description
		#endif
	}

	/// A textual representation of `self`, suitable for debugging.
	var debugDescription: String { 
		return description
	}
}
