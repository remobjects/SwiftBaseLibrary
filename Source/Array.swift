
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
__mapped public class Array<T: class> /*: INSFastEnumeration<T>*/ => Foundation.NSMutableArray {
#elseif COOPER
__mapped public class Array<T> => java.util.ArrayList<T> {
#elseif ECHOES
__mapped public class Array<T> => System.Collections.Generic.List<T> {
#endif
	/*private
	method SetItem(&Index: Integer Value: T)
	method GetItem(&Index: Integer): T*/

	//hack for now so we have a "mapped" field
	/*#if COOPER
	let mapped: java.util.ArrayList<T>!
	#elseif ECHOES
	let mapped: System.Collections.Generic.List<T>!
	#elseif NOUGAT
	let mapped: Foundation.NSMutableArray!
	#endif*/

	init() {
		#if COOPER
		return ArrayList<T>()
		#elseif ECHOES
		return List<T>()
		#elseif NOUGAT
		return NSMutableArray.array()
		#endif
	}
	
	init (items: [T]) {
		#if COOPER
		return items.clone() as [T]
		#elseif ECHOES
		return List<T>(items)
		#elseif NOUGAT
		return items.mutableCopy
		#endif
	}
	
	#if NOUGAT
	init (NSArray array: NSArray<T>) {
		return array.mutableCopy()
	}

	/*init(_fromCocoaArray source: _CocoaArrayType, noCopy: Bool = default) {
	}*/
	#endif
	
	
	init (array: T[]) { // Low-level arrays
		//todo
	}
	
	init (sequence: ISequence<T>) {
		#if COOPER
		#elseif ECHOES
		return sequence.ToList()
		#elseif NOUGAT
		#endif
	}

	init(count: Int, repeatedValue: T) {
		#if COOPER
		let newSelf: [T] = ArrayList<T>(count)
		#elseif ECHOES
		let newSelf: [T] = List<T>(count)
		#elseif NOUGAT
		let newSelf: [T] = NSMutableArray.arrayWithCapacity(count)
		#endif
		for var i: Int = 0; i < count; i++ {
			newSelf.append(repeatedValue)
		}
		return newSelf
	}
	
	public var count: Int {
		#if COOPER
		return __mapped.size()
		#elseif ECHOES
		return __mapped.Count
		#elseif NOUGAT
		return __mapped.count
		#endif
	}
	
	public var capacity: Int { 
		#if COOPER
		#elseif ECHOES
		return __mapped.Capacity
		#elseif NOUGAT
		#endif
		return -1 // todo
	}

	public var isEmpty: Bool { 
		return count == 0 
	}

	public var first: T? { 
		if count > 0 {
			return __mapped[0]
		}
		return nil
	}

	public var last: T? { 
		let c = count
		if c > 0 {
			return __mapped[c-1]
		}
		return nil
	}

	/// Ensure the array has enough mutable contiguous storage to store
	/// minimumCapacity elements in.  Note: does not affect count.
	/// Complexity: O(N)
	public mutating func reserveCapacity(minimumCapacity: Int) {
	}

	/// Append elements from `sequence` to the Array
	/*public mutating func extend<S : SequenceType where T == T>(sequence: S) {
	}*/

	/// Append newElement to the Array in O(1) (amortized)
	public mutating func append(newElement: T) {
		#if COOPER
		__mapped.add(newElement)
		#elseif ECHOES
		__mapped.Add(newElement)
		#elseif NOUGAT
		__mapped.addObject(newElement)
		#endif
	}

	public mutating func insert(newElement: T, atIndex index: Int) {
		#if COOPER
		__mapped.add(index, newElement)
		#elseif ECHOES
		__mapped.Insert(index, newElement)
		#elseif NOUGAT
		__mapped.insertObject(newElement, atIndex: index)
		#endif
	}

	public mutating func removeAtIndex(index: Int) -> T {
		#if COOPER
		__mapped.remove(index)
		#elseif ECHOES
		__mapped.RemoveAt(index)
		#elseif NOUGAT
		__mapped.removeObjectAtIndex(index)
		#endif
	}

	public mutating func removeLast() -> T {
		let c = count
		if c > 0 {
			removeAtIndex(c-1)
		}		
	}

	public /*mutating*/ func removeAll(keepCapacity: Bool = default) {
		#if COOPER
		__mapped.clear()
		#elseif ECHOES
		__mapped.Clear()
		#elseif NOUGAT
		__mapped.removeAllObjects()
		#endif
	}

	/// Interpose `self` between each consecutive pair of `elements`,
	/// and concatenate the elements of the resulting sequence.  For
	/// example, `[-1, -2].join([[1, 2, 3], [4, 5, 6], [7, 8, 9]])`
	/// yields `[1, 2, 3, -1, -2, 4, 5, 6, -1, -2, 7, 8, 9]`
	/*public func join<S : SequenceType where [T] == [T]>(elements: S) -> [T] {
	}*/

	/// Return the result of repeatedly calling `combine` with an
	/// accumulated value initialized to `initial` and each element of
	/// `self`, in turn, i.e. return
	/// `combine(combine(...combine(combine(initial, self[0]),
	/// self[1]),...self[count-2]), self[count-1])`.
	/*public func reduce<U>(initial: U, combine: (U, T) -> U) -> U {
	}*/

	public mutating func sort(isOrderedBefore: (T, T) -> Bool) {
		#if COOPER
		//70057: Silver: support for anonymous classes & nested classes
		/*java.util.Collections.sort(mapped, new class java.util.Comparator<T>(compare: { (a: id!, b: id!) -> NSComparisonResult in // TODo: check if this is the right order
			if isOrderedBefore(a,b) {
				return .NSOrderedAscending
			} else {
				return .NSOrderedDescending
			}
		})*/
		#elseif ECHOES
		__mapped.Sort({ (a: T, b: T) -> Boolean in // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		})
		#elseif NOUGAT
		__mapped.sortWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in // TODo: check if this is the right order
			if isOrderedBefore(a,b) {
				return .NSOrderedAscending
			} else {
				return .NSOrderedDescending
			}
		})
		#endif
	}

	public func sorted(isOrderedBefore: (T, T) -> Bool) -> [T] { 
		#if COOPER
		//todo, clone fromabove once it works
		#elseif ECHOES
		let result: List<T> = Array<T>(items: self) //70035: Silver: "[T]" array syntax doesn't work yet to new up an array.
		result.Sort({ (a: T, b: T) -> Boolean in // ToDo: check if this is the right order
			if isOrderedBefore(a,b) {
				return 1
			} else {
				return -1
			}
		})
		return result
		#elseif NOUGAT
		__mapped.sortedArrayWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in // TODo: check if this is the right order
			if isOrderedBefore(a,b) {
				return .NSOrderedAscending
			} else {
				return .NSOrderedDescending
			}
		})
		#endif
	}

	public func map<U>(transform: (T) -> U) -> ISequence<U> { // we deliberatey change this to return a sequence, not an array, for efficiency.
		#if COOPER
		//return __mapped.Select(transform) // 70053: Silver: can't call LINQ Selecr or Where on mapped Cooper array
		#elseif ECHOES
		return __mapped.Select(transform)
		#elseif NOUGAT
		//return __mapped.Select(transform) // 70052: Silver: Can't call LINQ Select on mapped NSArray
		#endif
	}

	public func reverse() -> ISequence<T> { // we deliberatey change this to return a sequence, not an array, for efficiency.
		#if COOPER
		//return (__mapped as Iterable<T>).Reverse()
		//return (__mapped as ISequence<T>).Reverse() // 70055: Silver: all platforms,cannot cast to ISequence (but can to IEnumerable on Echoes)
		#elseif ECHOES
		return (__mapped as System.Collections.Generic.IEnumerable<T>).Reverse()
		//return (__mapped as ISequence<T>).Reverse() //7 0055: Silver: all platforms,cannot cast to ISequence (but can to IEnumerable on Echoes)
		#elseif NOUGAT
		return (__mapped as INSFastEnumeration<T>).Reverse()
		//return (__mapped as ISequence<T>).Reverse() // 70055: Silver: all platforms,cannot cast to ISequence (but can to IEnumerable on Echoes)
		#endif
	}

	public func filter(includeElement: (T) -> Bool) -> ISequence<T> { // we deliberatey change this to return a sequence, not an array, for efficiency.
		#if COOPER
		//return __mapped.Where(includeElement) // 70053: Silver: can't call LINQ Selecr or Where on mapped Cooper array
		#elseif ECHOES
		return __mapped.Where(includeElement)
		#elseif NOUGAT
		//return (self as NSArray<T>!).Where(includeElement) // 70052: Silver: Can't call LINQ Select on mapped NSArray
		#endif
	}

	/// Construct a Array of `count` elements, each initialized to
	/// `repeatedValue`.
	
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

}
