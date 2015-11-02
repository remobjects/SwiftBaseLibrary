public typealias ArrayLiteralConvertible<T> = IArrayLiteralConvertible<T>
public typealias BooleanLiteralConvertible<T> = IBooleanLiteralConvertible<T>
public typealias DictionaryLiteralConvertible<K,V> = IDictionaryLiteralConvertible<K,V>
//public typealias ExtendedGraphemeClusterLiteralConvertible<T> = IExtendedGraphemeClusterLiteralConvertible<T>
public typealias FloatLiteralConvertible<T> = IFloatLiteralConvertible<T>
public typealias IntegerLiteralConvertible<T> = IIntegerLiteralConvertible<T>
public typealias NilLiteralConvertible<T> = INilLiteralConvertible
public typealias StringLiteralConvertible<T> = IStringLiteralConvertible<T>
public typealias UnicodeScalarLiteralConvertible<T> = IUnicodeScalarLiteralConvertible<T>

public protocol IArrayLiteralConvertible {
	typealias Element
	
	init(arrayLiteral elements: Element...)
}

public protocol IBooleanLiteralConvertible {
	typealias BooleanLiteralType

	init(booleanLiteral value: BooleanLiteralType)
}

public protocol IDictionaryLiteralConvertible {
	typealias Key
	typealias Value

	init(dictionaryLiteral elements: (Key, Value)...)
}

/*public protocol ExtendedGraphemeClusterLiteralConvertible : UnicodeScalarLiteralConvertible {
	typealias ExtendedGraphemeClusterLiteralType

	/// Create an instance initialized to `value`.
	init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
	}
}*/

public protocol IFloatLiteralConvertible {
	typealias FloatLiteralType

	init(floatLiteral value: FloatLiteralType)
}

public protocol IIntegerLiteralConvertible {
	typealias IntegerLiteralType

	init(integerLiteral value: IntegerLiteralType)
}

public protocol INilLiteralConvertible {

	//init(nilLiteral: ())
}

public protocol IStringLiteralConvertible /*: ExtendedGraphemeClusterLiteralConvertible*/ {
	typealias StringLiteralType

	init(stringLiteral value: StringLiteralType)
}

public protocol IUnicodeScalarLiteralConvertible {
	typealias UnicodeScalarLiteralType

	init(unicodeScalarLiteral value: UnicodeScalarLiteralType)
}

#if NOUGAT
public extension NSURL/*: StringLiteralConvertible*/ {
	
	//typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
	
	public class func convertFromExtendedGraphemeClusterLiteral(value: String) -> Self {
		return self(string: value)
	}

	init(stringLiteral value: String) {
		return NSURL(string: value)
	}
}
#endif
