protocol ArrayLiteralConvertible {
	typealias Element
	
	/*init(arrayLiteral elements: Element...) { // 70146: Silver: support "params" syntax with "..."
	}*/
}

protocol BooleanLiteralConvertible {
	typealias BooleanLiteralType

	/*init(booleanLiteral value: BooleanLiteralType) {
	}*/
}

protocol DictionaryLiteralConvertible {
	typealias Key
	typealias Value

	/// Create an instance initialized with `elements`.
	/*init(dictionaryLiteral elements: (Key, Value)...) {
	}*/
}

/*
protocol ExtendedGraphemeClusterLiteralConvertible : UnicodeScalarLiteralConvertible {
	typealias ExtendedGraphemeClusterLiteralType

	/// Create an instance initialized to `value`.
	init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
	}
}
*/

protocol FloatLiteralConvertible {
	typealias FloatLiteralType

	/*init(floatLiteral value: FloatLiteralType) {
	}*/
}
/*
protocol IntegerLiteralConvertible {
	typealias IntegerLiteralType

	init(integerLiteral value: IntegerLiteralType) {
	}
}*/

protocol NilLiteralConvertible {

	/*init(nilLiteral: ()) {
	}*/
}
/*
protocol StringLiteralConvertible : ExtendedGraphemeClusterLiteralConvertible {
	typealias StringLiteralType

	init(stringLiteral value: StringLiteralType) {
	}
}

protocol UnicodeScalarLiteralConvertible {
	typealias UnicodeScalarLiteralType

	init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
	}
}*/


#if NOUGAT
extension NSURL/*: StringLiteralConvertible*/ {
	
	//typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
	
	public class func convertFromExtendedGraphemeClusterLiteral(value: String) -> Self {
		return self(string: value)
	}

	/*init(stringLiteral value: String) -> Self {
		return self(string: value)
	}*/
}
#endif
