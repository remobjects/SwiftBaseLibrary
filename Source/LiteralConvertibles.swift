public typealias ExpressibleByArrayLiteral = IExpressibleByArrayLiteral
public typealias ExpressibleByBooleanLiteral = IExpressibleByBooleanLiteral
public typealias ExpressibleByDictionaryLiteral = IExpressibleByDictionaryLiteral
//public typealias ExpressibleByExtendedGraphemeClusterLiteral = IExpressibleByExtendedGraphemeClusterLiteral
public typealias ExpressibleByFloatLiteral = IExpressibleByFloatLiteral
public typealias ExpressibleByIntegerLiteral = IExpressibleByIntegerLiteral
public typealias ExpressibleByNilLiteral = IExpressibleByNilLiteral
public typealias ExpressibleByStringLiteral = IExpressibleByStringLiteral
public typealias ExpressibleByStringInterpolation = IExpressibleByStringInterpolation
public typealias ExpressibleByUnicodeScalarLiteral = IExpressibleByUnicodeScalarLiteral

public typealias NilLiteralConvertible = ExpressibleByNilLiteral
public typealias BooleanLiteralConvertible = ExpressibleByBooleanLiteral
public typealias FloatLiteralConvertible = ExpressibleByFloatLiteral
public typealias IntegerLiteralConvertible = ExpressibleByIntegerLiteral
public typealias UnicodeScalarLiteralConvertible = ExpressibleByUnicodeScalarLiteral
//public typealias ExtendedGraphemeClusterLiteralConvertible = ExpressibleByExtendedGraphemeClusterLiteral
public typealias StringLiteralConvertible = ExpressibleByStringLiteral
public typealias StringInterpolationConvertible = ExpressibleByStringInterpolation
public typealias ArrayLiteralConvertible = ExpressibleByArrayLiteral
public typealias DictionaryLiteralConvertible = ExpressibleByDictionaryLiteral

public protocol IExpressibleByArrayLiteral {
	associatedtype Element
	
	init(arrayLiteral elements: Element...)
}

public protocol IExpressibleByBooleanLiteral {
	associatedtype BooleanLiteralType

	init(booleanLiteral value: BooleanLiteralType)
}

public protocol IExpressibleByDictionaryLiteral {
	associatedtype Key
	associatedtype Value

	init(dictionaryLiteral elements: (Key, Value)...)
}

//73998: Silver: compiler crash in base library
public protocol IExpressibleByExtendedGraphemeClusterLiteral /*: ExpressibleByUnicodeScalarLiteral*/ {
	associatedtype ExtendedGraphemeClusterLiteralType

	/// Create an instance initialized to `value`.
	init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType)
}

public protocol IExpressibleByFloatLiteral {
	associatedtype FloatLiteralType

	init(floatLiteral value: FloatLiteralType)
}

public protocol IExpressibleByIntegerLiteral {
	associatedtype IntegerLiteralType

	init(integerLiteral value: IntegerLiteralType)
}

public protocol IExpressibleByNilLiteral {

	//init(nilLiteral: ())
}

public protocol IExpressibleByStringLiteral /*: ExpressibleByExtendedGraphemeClusterLiteral*/ {
	associatedtype StringLiteralType

	init(stringLiteral value: StringLiteralType)
}

public protocol IExpressibleByStringInterpolation /*: ExpressibleByExtendedGraphemeClusterLiteral*/ {
	associatedtype StringInterpolationType

	init(stringInterpolation value: StringInterpolationType)
}

public protocol IExpressibleByUnicodeScalarLiteral {
	associatedtype UnicodeScalarLiteralType

	init(unicodeScalarLiteral value: UnicodeScalarLiteralType)
}

#if COCOA
public extension NSURL/*: ExpressibleByStringLiteral*/ {
	
	//typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
	
	public class func convertFromExtendedGraphemeClusterLiteral(value: String) -> Self {
		return self(string: value)
	}

	init(stringLiteral value: String) {
		return NSURL(string: value)
	}
}
#endif
