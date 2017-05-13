
/// The function composition operator is the only user-defined operator that
/// operates on functions.  That's why the numeric value of precedence does
/// not matter right now.
infix operator ∘  { associativity left precedence 100 }  // The character is U+2218 RING OPERATOR.


/// Compose functions.
///
///     (g ∘ f)(x) == g(f(x))
///
/// - Returns: a function that applies ``g`` to the result of applying ``f``
///   to the argument of the new function.
public func ∘ <T, U, V>(g: U -> V, f: T -> U) -> (T -> V) {
  return { g(f($0)) }
}

infix operator ∖  { associativity left precedence 140 }
infix operator ∖= { associativity right precedence 90 assignment }
infix operator ∪  { associativity left precedence 140 }
infix operator ∪= { associativity right precedence 90 assignment }
infix operator ∩  { associativity left precedence 150 }
infix operator ∩= { associativity right precedence 90 assignment }
infix operator ⨁  { associativity left precedence 140 }
infix operator ⨁= { associativity right precedence 90 assignment }
infix operator ∈  { associativity left precedence 130 }
infix operator ∉  { associativity left precedence 130 }
infix operator ⊂  { associativity left precedence 130 }
infix operator ⊄  { associativity left precedence 130 }
infix operator ⊆  { associativity left precedence 130 }
infix operator ⊈  { associativity left precedence 130 }
infix operator ⊃  { associativity left precedence 130 }
infix operator ⊅  { associativity left precedence 130 }
infix operator ⊇  { associativity left precedence 130 }
infix operator ⊉  { associativity left precedence 130 }

/// - Returns: The relative complement of `lhs` with respect to `rhs`.
public func ∖ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Set<T> {
	return lhs.subtract(rhs)
}

/// Assigns the relative complement between `lhs` and `rhs` to `lhs`.
public func ∖= <T, S: SequenceType<T>>(inout lhs: Set<T>, rhs: S) {
	lhs.subtractInPlace(rhs)
}

/// - Returns: The union of `lhs` and `rhs`.
public func ∪ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Set<T> {
	return lhs.union(rhs)
}

/// Assigns the union of `lhs` and `rhs` to `lhs`.
public func ∪= <T, S: SequenceType<T>>(inout lhs: Set<T>, rhs: S) {
	lhs.unionInPlace(rhs)
}

/// - Returns: The intersection of `lhs` and `rhs`.
public func ∩ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Set<T> {
	return lhs.intersect(rhs)
}

/// Assigns the intersection of `lhs` and `rhs` to `lhs`.
public func ∩= <T, S: SequenceType<T>>(inout lhs: Set<T>, rhs: S) {
	lhs.intersectInPlace(rhs)
}

/// - Returns: A set with elements in `lhs` or `rhs` but not in both.
public func ⨁ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Set<T> {
	return lhs.exclusiveOr(rhs)
}

/// Assigns to `lhs` the set with elements in `lhs` or `rhs` but not in both.
public func ⨁= <T, S: SequenceType<T>>(inout lhs: Set<T>, rhs: S) {
	lhs.exclusiveOrInPlace(rhs)
}

/// - Returns: True if `x` is in the set.
public func ∈ <T>(x: T, rhs: Set<T>) -> Bool {
	return rhs.contains(x)
}

/// - Returns: True if `x` is not in the set.
public func ∉ <T>(x: T, rhs: Set<T>) -> Bool {
	return !rhs.contains(x)
}

/// - Returns: True if `lhs` is a strict subset of `rhs`.
public func ⊂ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Bool {
	return lhs.isStrictSubsetOf(rhs)
}

/// - Returns: True if `lhs` is not a strict subset of `rhs`.
public func ⊄ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Bool {
	return !lhs.isStrictSubsetOf(rhs)
}

/// - Returns: True if `lhs` is a subset of `rhs`.
public func ⊆ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Bool {
	return lhs.isSubsetOf(rhs)
}

/// - Returns: True if `lhs` is not a subset of `rhs`.
public func ⊈ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Bool {
	return !lhs.isSubsetOf(rhs)
}

/// - Returns: True if `lhs` is a strict superset of `rhs`.
public func ⊃ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Bool {
	return lhs.isStrictSupersetOf(rhs)
}

/// - Returns: True if `lhs` is not a strict superset of `rhs`.
public func ⊅ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Bool {
	return !lhs.isStrictSupersetOf(rhs)
}

/// - Returns: True if `lhs` is a superset of `rhs`.
public func ⊇ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Bool {
	return lhs.isSupersetOf(rhs)
}

/// - Returns: True if `lhs` is not a superset of `rhs`.
public func ⊉ <T, S: SequenceType<T>>(lhs: Set<T>, rhs: S) -> Bool {
	return !lhs.isSupersetOf(rhs)
}