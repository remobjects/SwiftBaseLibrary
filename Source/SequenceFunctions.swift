﻿#if COOPER
import java.util
import com.remobjects.elements.linq
#elseif ECHOES
import System.Collections.Generic
import System.Linq
#elseif NOUGAT
import Foundation
import RemObjects.Elements.Linq
#endif

func countElements(source: String?) -> Int {
	return length(source)
}

func countElements<T>(source: [T]?) -> Int {
	return source?.count
	//return length(source) // 70204: length() CMF should work with NS(Mutable)Array, and with Silver [T] arrays
}

func countElements<T>(source: T[]?) -> Int {
	return length(source)
}

func countElements<T>(source: ISequence<T>?) -> Int {
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

// 70205: Silver: __inline support
func count(source: String?) -> Int { return countElements(source) }
func count<T>(source: [T]?) -> Int { return countElements(source) }
func count<T>(source: T[]?) -> Int { return countElements(source) }
func count<T>(source: ISequence<T>) -> Int { return countElements(source) }

func contains<T>(source: ISequence<T>?, predicate: (T) -> Bool) -> Bool {
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

public func filter<T>(source: ISequence<T>, includeElement: (T) -> Bool) -> ISequence<T> {
	#if COOPER
	return source.Where({ return includeElement($0) })
	#elseif ECHOES
	return source.Where(includeElement)
	#elseif NOUGAT
	return source.Where({ return includeElement($0) })
	#endif
}

func isEmpty<T>(source: ISequence<T>?) -> Bool {
	if let s = source {
		return !s.Any()
	}
	return true
}

public func map<T, U>(source: ISequence<T>, transform: (T) -> U) -> ISequence<U> {
	#if COOPER
	return source.Select({ return transform($0) })
	#elseif ECHOES | NOUGAT
	return source.Select(transform)
	#endif
}

public func reverse<T>(source: ISequence<T>) -> ISequence<T>
{
	return source.Reverse()
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

