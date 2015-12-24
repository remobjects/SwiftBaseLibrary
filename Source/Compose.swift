/// The function composition operator is the only user-defined operator that
/// operates on functions.  That's why the numeric value of precedence does
/// not matter right now.
infix operator ∘ {
  // The character is U+2218 RING OPERATOR.
  //
  // Confusables:
  //
  // U+00B0 DEGREE SIGN
  // U+02DA RING ABOVE
  // U+25CB WHITE CIRCLE
  // U+25E6 WHITE BULLET
  associativity left
  precedence 100
}

/// Compose functions.
///
///	 (g ∘ f)(x) == g(f(x))
///
/// - Returns: a function that applies ``g`` to the result of applying ``f``
///   to the argument of the new function.
public func ∘<T, U, V>(g: U -> V, f: T -> U) -> (T -> V) {
  return { g(f($0)) }
}

infix operator ∖ { associativity left precedence 140 }
infix operator ∖= { associativity right precedence 90 assignment }
infix operator ∪ { associativity left precedence 140 }
infix operator ∪= { associativity right precedence 90 assignment }
infix operator ∩ { associativity left precedence 150 }
infix operator ∩= { associativity right precedence 90 assignment }
infix operator ⨁ { associativity left precedence 140 }
infix operator ⨁= { associativity right precedence 90 assignment }
infix operator ∈ { associativity left precedence 130 }
infix operator ∉ { associativity left precedence 130 }
infix operator ⊂ { associativity left precedence 130 }
infix operator ⊄ { associativity left precedence 130 }
infix operator ⊆ { associativity left precedence 130 }
infix operator ⊈ { associativity left precedence 130 }
infix operator ⊃ { associativity left precedence 130 }
infix operator ⊅ { associativity left precedence 130 }
infix operator ⊇ { associativity left precedence 130 }
infix operator ⊉ { associativity left precedence 130 }
