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

public __inline func countElements(source: String?) -> Int {
	return length(source)
}

public __inline func countElements<T>(source: [T]?) -> Int {
	return length(source)
}

public __inline func countElements<T>(source: T[]?) -> Int {
	return length(source)
}

public __inline func countElements<T>(source: ISequence<T>?) -> Int {
	if let s = source {
		#if COOPER | ECHOES
		return s.Count()
		#elseif NOUGAT
		return s.count()
		#endif
	}
	return 0
}

/* count() just duplicates countElements. We know, Ugh. */

public __inline func count(source: String?) -> Int { return countElements(source) }
public __inline func count<T>(source: [T]?) -> Int { return countElements(source) }
public __inline func count<T>(source: T[]?) -> Int { return countElements(source) }
public __inline func count<T>(source: ISequence<T>) -> Int { return countElements(source) }

public __inline func contains<T>(source: ISequence<T>?, predicate: (T) -> Bool) -> Bool {
	if let s = source {
		#if COOPER
		return s.Any({ return predicate($0) })
		#elseif ECHOES
		return s.Any(predicate)
		#elseif NOUGAT
		return s.Any({ return predicate($0) })
		#endif
	}
	return false
}

public __inline public func filter<T>(source: ISequence<T>, includeElement: (T) -> Bool) -> ISequence<T> {
	#if COOPER
	return source.Where({ return includeElement($0) })
	#elseif ECHOES
	return source.Where(includeElement)
	#elseif NOUGAT
	return source.Where({ return includeElement($0) })
	#endif
}

/*public __inline func first<T>(source: ISequence<T>?) -> T? { // Type "T" cannot be used as nullable
	if let s = source {
		return !s.FirstOrDefault()
	}
	return nil
}*/

public __inline func isEmpty<T>(source: ISequence<T>?) -> Bool {
	if let s = source {
		return !s.Any()
	}
	return true
}

public __inline public func map<T, U>(source: ISequence<T>, transform: (T) -> U) -> ISequence<U> {
	#if COOPER
	return source.Select({ return transform($0) })
	#elseif ECHOES | NOUGAT
	return source.Select(transform)
	#endif
}

public __inline public func reverse<T>(source: ISequence<T>) -> ISequence<T>
{
	return source.Reverse()
}

public __inline public func sorted<T>(source: ISequence<T>, isOrderedBefore: (T,T) -> Bool) -> [T]
{
	//70099: Silver: several weird errors implementing global sorted() method
	/*let result = [T](sequence: source) 
	#if COOPER
	java.util.Collections.sort(result, class java.util.Comparator<T> { func compare(a: T, b: T) -> Int { // ToDo: check if this is the right order
		if isOrderedBefore(a,b) {
			return 1
		} else {
			return -1
		}
	}})	
	return result
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

//public func split<S : Sliceable, R : BooleanType>(elements: S, isSeparator: (S.Generator.Element) -> R, maxSplit: Int = default, allowEmptySlices: Bool = default) -> [S.SubSlice]

public func split(elements: String, isSeparator: (Char) -> Bool, maxSplit: Int = default, allowEmptySlices: Bool = default) -> [String] {
	
	let result = [String]()
	var currentString = ""
	
	func appendCurrent() -> Bool {
		if maxSplit > 0 && result.count >= maxSplit {
			return false
		}
		if allowEmptySlices || currentString.length() > 0 {
			result.append(currentString)
		}
		return true
	}
	
	for var i = 0; i < elements.length(); i++ {
		let ch = elements[i]
		if isSeparator(ch) {
			if !appendCurrent() {
				break
			}
			currentString = ""
		} else {
			currentString += ch
		}
	}
	
	if currentString.length() > 0 {
		appendCurrent()
	}
	
	return result
}



