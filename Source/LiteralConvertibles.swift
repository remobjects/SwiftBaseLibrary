public typealias ArrayLiteralConvertible = IArrayLiteralConvertible
public typealias BooleanLiteralConvertible = IBooleanLiteralConvertible
public typealias DictionaryLiteralConvertible = IDictionaryLiteralConvertible
//public typealias ExtendedGraphemeClusterLiteralConvertible = IExtendedGraphemeClusterLiteralConvertible
public typealias FloatLiteralConvertible = IFloatLiteralConvertible
public typealias IntegerLiteralConvertible = IIntegerLiteralConvertible
public typealias NilLiteralConvertible = INilLiteralConvertible
public typealias StringLiteralConvertible = IStringLiteralConvertible
public typealias StringInterpolationConvertible = IStringInterpolationConvertible
public typealias UnicodeScalarLiteralConvertible = IUnicodeScalarLiteralConvertible

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

//73998: Silver: compiler crash in base library
public protocol IExtendedGraphemeClusterLiteralConvertible /*: UnicodeScalarLiteralConvertible*/ {
	typealias ExtendedGraphemeClusterLiteralType

	/// Create an instance initialized to `value`.
	init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType)
}

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

public protocol IStringInterpolationConvertible /*: ExtendedGraphemeClusterLiteralConvertible*/ {
	typealias StringInterpolationType

	init(stringInterpolation value: StringInterpolationType)
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
