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

//70103: Silver: should be able to overload global functions by name type.
/*func countElements(source: String) -> Int {
	if let s = source {
		#if COOPER | NOUGAT
		return s.length()
		#elseif ECHOES
		//return s.Length() //70102: Silver: Echoes: No member "Length" on type "String!", and "if let" var should not be nullable to begin with
		//return length(s); // The length() compiler magic function expects an array, System.Array, ICollection or ICollection<T>implementation
		#endif
	}
	return 0
}

func countElements<T>(source: T[]) -> Int {
	if let s = source {
		return length(s)
	}
	return 0
}*/

func countElements<T>(source: ISequence<T>) -> Int {
	if let s = source {
		#if COOPER | ECHOES
		return s.Count()
		#elseif NOUGAT
		return s.count()
		#endif
	}
	return 0
}

/*func count<T>(source: ISequence<T>) -> Int { // inline?
	return countElements(source) // 70105: Silver: Type mismatch, cannot assign "ISequence<T>" to "ISequence<T>"
}*/

func contains<T>(source: ISequence<T>, predicate: (T) -> Bool) -> Bool {
	#if COOPER
	//return source.Any(predicate) // 70104: LINQ Base Libs: implement Any & Co for Nougat and Cooper
	#elseif ECHOES
	return source.Any(predicate)
	#elseif NOUGAT
	//return source.Any(predicate) // 70104: LINQ Base Libs: implement Any & Co for Nougat and Cooper
	#endif
}

public func filter<T, U>(source: ISequence<T>, includeElement: (T) -> Bool) -> ISequence<T> {
	#if COOPER
	//return source.Where(includeElement) // Parameter 2 is "com.remobjects.elements.system.Func2<T,Boolean>!", should be "Predicate<T>!", in call to static __Extensions!.Where<T>(arg1: Iterable<T>!, arg2: Predicate<T>!) -> Iterable<T>!
	#elseif ECHOES
	return source.Where(includeElement)
	#elseif NOUGAT
	//return source.Where(includeElement) // Parameter 2 is "block (param0: T) -> Bool<T,U>!", should be "block (aItem: T) -> Boolean<T>!", in call to static RemObjects_Elements_Linq__Extensions!.Where<T>(self: RemObjects.Elements.System.INSFastEnumeration<T>!, aBlock: block (aItem: T) -> Boolean<T>!) -> RemObjects.Elements.System.INSFastEnumeration<T>!
	#endif
}

func isEmpty<T>(source: ISequence<T>) -> Bool {
	#if COOPER
	return source.iterator().hasNext()
	//return source.Select(transform) // 70053: Silver: can't call LINQ Selecr or Where on mapped Cooper array
	#elseif ECHOES
	return source.Any()
	#elseif NOUGAT
	return source.isEmpty()
	#endif
}

public func map<T, U>(source: ISequence<T>, transform: (T) -> U) -> ISequence<U> {
	#if COOPER
	//return source.Select(transform) // 70053: Silver: can't call LINQ Selecr or Where on mapped Cooper array
	#elseif ECHOES
	return source.Select(transform)
	#elseif NOUGAT
	//return source.Select(transform) // 70052: Silver: Can't call LINQ Select on mapped NSArray
	#endif
}

public func reverse<T>(source: ISequence<T>) -> ISequence<T>
{
	#if COOPER
	return source.Reverse() as ISequence<T> // 70100: Silver: Cooper: Type mismatch, cannot assign "Iterable<T>" to "ISequence<T>"
	#elseif ECHOES
	return source.Reverse() 
	#elseif NOUGAT
	return source.Reverse() 
	#endif
}

public func sorted<T>(source: ISequence<T>, isOrderedBefore: (T,T) -> Bool) -> [T]
{
	//70099: Silver: several weird errors implementing global sorted() method
	/*let result = [T](sequence: source) 
	#if COOPER
	//todo, clone fromabove once it works
	#elseif ECHOES
	(result as List<T>).Sort({ (a: T, b: T) -> Boolean in // ToDo: check if this is the right order
		if isOrderedBefore(a,b) {
			return 1
		} else {
			return -1
		}
	})
	return result
	#elseif NOUGAT
	(result as NSArray).sortedArrayWithOptions(0, usingComparator: { (a: id!, b: id!) -> NSComparisonResult in // ToDo: check if this is the right order
		if isOrderedBefore(a,b) {
			return .NSOrderedAscending
		} else {
			return .NSOrderedDescending
		}
	})
	#endif
	return result*/
}

