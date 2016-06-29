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
	associatedtype Element
	
	init(arrayLiteral elements: Element...)
}

public protocol IBooleanLiteralConvertible {
	associatedtype BooleanLiteralType

	init(booleanLiteral value: BooleanLiteralType)
}

public protocol IDictionaryLiteralConvertible {
	associatedtype Key
	associatedtype Value

	init(dictionaryLiteral elements: (Key, Value)...)
}

//73998: Silver: compiler crash in base library
public protocol IExtendedGraphemeClusterLiteralConvertible /*: UnicodeScalarLiteralConvertible*/ {
	associatedtype ExtendedGraphemeClusterLiteralType

	/// Create an instance initialized to `value`.
	init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType)
}

public protocol IFloatLiteralConvertible {
	associatedtype FloatLiteralType

	init(floatLiteral value: FloatLiteralType)
}

public protocol IIntegerLiteralConvertible {
	associatedtype IntegerLiteralType

	init(integerLiteral value: IntegerLiteralType)
}

public protocol INilLiteralConvertible {

	//init(nilLiteral: ())
}

public protocol IStringLiteralConvertible /*: ExtendedGraphemeClusterLiteralConvertible*/ {
	associatedtype StringLiteralType

	init(stringLiteral value: StringLiteralType)
}

public protocol IStringInterpolationConvertible /*: ExtendedGraphemeClusterLiteralConvertible*/ {
	associatedtype StringInterpolationType

	init(stringInterpolation value: StringInterpolationType)
}

public protocol IUnicodeScalarLiteralConvertible {
	associatedtype UnicodeScalarLiteralType

	init(unicodeScalarLiteral value: UnicodeScalarLiteralType)
}

#if COCOA
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
