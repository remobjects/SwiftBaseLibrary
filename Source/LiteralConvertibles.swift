typealias ArrayLiteralConvertible<T> = IArrayLiteralConvertible<T>
typealias BooleanLiteralConvertible<T> = IBooleanLiteralConvertible<T>
typealias DictionaryLiteralConvertible<K,V> = IDictionaryLiteralConvertible<K,V>
//typealias ExtendedGraphemeClusterLiteralConvertible<T> = IExtendedGraphemeClusterLiteralConvertible<T>
typealias FloatLiteralConvertible<T> = IFloatLiteralConvertible<T>
typealias IntegerLiteralConvertible<T> = IIntegerLiteralConvertible<T>
typealias NilLiteralConvertible<T> = INilLiteralConvertible
typealias StringLiteralConvertible<T> = IStringLiteralConvertible<T>
typealias UnicodeScalarLiteralConvertible<T> = IUnicodeScalarLiteralConvertible<T>

protocol IArrayLiteralConvertible {
	typealias Element
	
	init(arrayLiteral elements: Element...)
}

protocol IBooleanLiteralConvertible {
	typealias BooleanLiteralType

	init(booleanLiteral value: BooleanLiteralType)
}

protocol IDictionaryLiteralConvertible {
	typealias Key
	typealias Value

	init(dictionaryLiteral elements: (Key, Value)...)
}

/*protocol ExtendedGraphemeClusterLiteralConvertible : UnicodeScalarLiteralConvertible {
	typealias ExtendedGraphemeClusterLiteralType

	/// Create an instance initialized to `value`.
	init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
	}
}*/

protocol IFloatLiteralConvertible {
	typealias FloatLiteralType

	init(floatLiteral value: FloatLiteralType)
}

protocol IIntegerLiteralConvertible {
	typealias IntegerLiteralType

	init(integerLiteral value: IntegerLiteralType)
}

protocol INilLiteralConvertible {

	//init(nilLiteral: ())
}

protocol IStringLiteralConvertible /*: ExtendedGraphemeClusterLiteralConvertible*/ {
	typealias StringLiteralType

	init(stringLiteral value: StringLiteralType)
}

protocol IUnicodeScalarLiteralConvertible {
	typealias UnicodeScalarLiteralType

	init(unicodeScalarLiteral value: UnicodeScalarLiteralType)
}

#if NOUGAT
extension NSURL/*: StringLiteralConvertible*/ {
	
	//typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
	
	public class func convertFromExtendedGraphemeClusterLiteral(value: String) -> Self {
		return self(string: value)
	}

	init(stringLiteral value: String) {
		return NSURL(string: value)
	}
}
#endif
