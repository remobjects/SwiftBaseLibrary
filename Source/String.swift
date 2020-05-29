#if JAVA
public typealias NativeString = java.lang.String
public typealias NativeStringBuilder = java.lang.StringBuilder
#elseif CLR
public typealias NativeString = System.String
public typealias NativeStringBuilder = System.Text.StringBuilder
#elseif ISLAND
public typealias NativeString = RemObjects.Elements.System.String
public typealias NativeStringBuilder = RemObjects.Elements.System.StringBuilder
#elseif COCOA
public typealias NativeString = Foundation.NSString
#endif

//public typealias String = SwiftString
//@assembly:DefaultStringType("Swift", typeOf(Swift.SwiftString))

public struct SwiftString /*: Streamable*/ {

	typealias Index = Int

	/*fileprivate*/internal var nativeStringValue: NativeString // only so the .pas partial can access it

	public init() {
		nativeStringValue = ""
	}

	public init(repeating c: Char, count: Int) {

		#if JAVA || ISLAND
		var chars = Char[](count)
		for i in 0 ..< count {
			chars[i] = c
		}
		nativeStringValue = NativeString(chars)
		#elseif CLR
		nativeStringValue = NativeString(c, count)
		#elseif COCOA
		nativeStringValue = "".stringByPaddingToLength(count, withString: NSString.stringWithFormat("%c", c), startingAtIndex: 0)
		#endif
	}

	public convenience init(_ c: Char) {
        init(repeating: c, count: 1)
	}

	public init(_ s: NativeString) {
		nativeStringValue = s
	}

	/*public init(_ s: SwiftString) {
		nativeStringValue = s.nativeStringValue
	}*/

	#if !ECHOES
	/*public init(stringLiteral s: SwiftString) {
		nativeStringValue = s
	}*/
	#endif

	public init(_ object: Object) {
		if let o = object as? ICustomStringConvertible {
			nativeStringValue = o.description
		} else {
			#if JAVA
			nativeStringValue = object.toString()
			#elseif CLR || ISLAND
			nativeStringValue = object.ToString()
			#elseif COCOA
			nativeStringValue = object.description
			#endif
		}
	}

	//76037: Silver: compiler gets confused with overloaded ctors
	#if !ECHOES
	/*public convenience init(reflecting subject: Object) {
		var subject = subject
		if let o = subject as? ICustomDebugStringConvertible {
			subject = o.debugDescription
		} else {
			#if JAVA
			// ToDo: fall back to reflection to call debugDescription?
			// ToDo: fall back to checking for extension methods
			#elseif CLR
			// ToDo: fall back to reflection to call debugDescription?
			// ToDo: fall back to checking for extension methods
			#elseif COCOA
			if subject.respondsToSelector(#selector(debugDescription)) {
				subject = subject.debugDescription
			}
			// ToDo: fall back to checking for extension methods
			#endif
		}
		init(subject)
	}*/
	#endif

	#if COCOA
	init/*?*/ (cString: UnsafePointer<AnsiChar>, encoding: SwiftString.Encoding) {
		nativeStringValue = "" // WORKAROUND
		if cString == nil {
			//return nil
		} else {
			nativeStringValue = NSString.stringWithCString(cString, encoding: encoding.rawValue)
			if nativeStringValue == nil {
				//return nil
			}
		}
	}

	init/*?*/ (utf8String: UnsafePointer<AnsiChar>) {
		nativeStringValue = "" // WORKAROUND
		if utf8String == nil {
			//return nil
		} else {
			nativeStringValue = NSString.stringWithUTF8String(utf8String)
			if nativeStringValue == nil {
				//return nil
			}
		}
	}

	init/*?*/ (validatingUTF8 utf8String: UnsafePointer<AnsiChar>) { // E1 opening bracket expected, got
		if utf8String == nil {
			//return nil
		}
		//todo:  If CString contains ill-formed UTF-8 code unit sequences, replaces them with replacement characters (U+FFFD).
		nativeStringValue = NSString.stringWithUTF8String(utf8String)
		if nativeStringValue == nil {
			//return nil
		}
	}
	#endif

	//
	// Operators
	//

	public static func __implicit(_ string: NativeString?) -> SwiftString {
		if let string = string {
			return SwiftString(string)
		} else {
			return SwiftString()
		}
	}

	public static func __explicit(_ string: NativeString?) -> SwiftString {
		if let string = string {
			return SwiftString(string)
		} else {
			return SwiftString()
		}
	}

	public static class func __implicit(_ string: SwiftString) -> NativeString {
		return string.nativeStringValue
	}

	public static class func __explicit(_ string: SwiftString) -> NativeString {
		return string.nativeStringValue
	}

	public class func + (_ stringA: SwiftString, _ stringB: SwiftString) -> NativeString {
		return stringA.nativeStringValue+stringB.nativeStringValue
	}

	//
	// Properties
	//

	#if DARWIN || !ISLAND
	public var characters: SwiftString.CharacterView {
		return SwiftString.CharacterView(string: nativeStringValue)
	}
	#endif

	@ToString public func description() -> NativeString {
		return nativeStringValue
	}

	public var endIndex: SwiftString.Index {
		return RemObjects.Elements.System.length(nativeStringValue) // for now?
	}

	var fastestEncoding: SwiftString.Encoding { return SwiftString.Encoding.utf16 }

	public var hashValue: Int {
		#if JAVA
		return nativeStringValue.hashCode()
		#elseif CLR || ISLAND
		return nativeStringValue.GetHashCode()
		#elseif COCOA
		return nativeStringValue.hashValue()
		#endif
	}

	public var isEmpty : Bool {
		#if JAVA
		return nativeStringValue.isEmpty()
		#elseif CLR || ISLAND
		return NativeString.IsNullOrEmpty(nativeStringValue)
		#elseif COCOA
		return nativeStringValue.length == 0
		#endif
	}

	public func lowercased() -> SwiftString {
		#if JAVA
		return SwiftString(nativeStringValue.toLowerCase())
		#elseif CLR || ISLAND
		return SwiftString(nativeStringValue.ToLower())
		#elseif COCOA
		return SwiftString(nativeStringValue.lowercaseString())
		#endif
	}

	public var startIndex: SwiftString.Index {
		return 0
	}

	public func uppercased() -> SwiftString {
		#if JAVA
		return SwiftString(nativeStringValue.toUpperCase())
		#elseif CLR || ISLAND
		return SwiftString(nativeStringValue.ToUpper())
		#elseif COCOA
		return SwiftString(nativeStringValue.uppercaseString())
		#endif
	}

	public var utf8: SwiftString.UTF8View {
		return SwiftString.UTF8View(string: nativeStringValue)
	}

	public var utf8CString: UTF8Char[] {
        #if CLR
        let result = System.Text.Encoding.UTF8.GetBytes(nativeStringValue)
        #elseif ISLAND
        let result = RemObjects.Elements.System.Encoding.UTF8.GetBytes(nativeStringValue, false)
        #elseif COCOA
		let utf8 = nativeStringValue.cStringUsingEncoding(.UTF8StringEncoding)
		let len = strlen(utf8) + 1
		let result = UTF8Char[](len)
		memcpy(result, utf8, len)
        #endif
        return result
	}
	
	public var utf16: SwiftString.UTF16View {
		return SwiftString.UTF16View(string: nativeStringValue)
	}

	public var unicodeScalars: SwiftString.UnicodeScalarView {
		return SwiftString.UnicodeScalarView(string: nativeStringValue)
	}

	//
	// Methods
	//

	public mutating func append(_ c: Character) {
		nativeStringValue = nativeStringValue+c.nativeStringValue
	}

	public mutating func append(_ c: Char) {
		nativeStringValue = nativeStringValue+c
	}

	public mutating func append(_ s: SwiftString) {
		nativeStringValue = nativeStringValue+s.nativeStringValue
	}

	public mutating func append(_ s: NativeString) {
		nativeStringValue = nativeStringValue+s
	}

	public func appending(_ s: SwiftString) -> SwiftString {
		return SwiftString(nativeStringValue+s.nativeStringValue)
	}

	public func appending(_ s: NativeString) -> SwiftString {
		return SwiftString(nativeStringValue+s)
	}

	public func contains(_ s: SwiftString) -> Bool {
		return index(of: s) != nil
	}

	#if !COCOA
	public func hasPrefix(_ `prefix`: SwiftString) -> Bool {
		#if JAVA
		return nativeStringValue.startsWith(`prefix`.nativeStringValue)
		#elseif CLR || ISLAND
		return nativeStringValue.StartsWith(`prefix`.nativeStringValue)
		#elseif COCOA
		return nativeStringValue.hasPrefix(`prefix`.nativeStringValue)
		#endif
	}

	public func hasSuffix(_ suffix: SwiftString) -> Bool {
		#if JAVA
		return nativeStringValue.endsWith(suffix.nativeStringValue)
		#elseif CLR || ISLAND
		return nativeStringValue.EndsWith(suffix.nativeStringValue)
		#elseif COCOA
		return nativeStringValue.hasSuffix(`prefix`.nativeStringValue)
		#endif
	}
	#endif

	public func index(of s: SwiftString) -> Int? {
		#if JAVA
		let result = nativeStringValue.indexOf(s.nativeStringValue)
		if result < 0 {
			return nil
		}
		#elseif CLR || ISLAND
		let result = nativeStringValue.IndexOf(s.nativeStringValue)
		if result < 0 {
			return nil
		}
		#elseif COCOA
		let result = nativeStringValue.rangeOfString(s.nativeStringValue).location
		if result == NSNotFound {
			return nil
		}
		#endif
		return result
	}

	#if !ISLAND
	public func withUTF8Buffer<R>(@noescape _ body: (/*UnsafeBufferPointer<UInt8>*/UTF8Char[]) -> R) -> R {
		return body(utf8.stringData)
	}
	#endif

	//
	// Subscripts
	//

	//public subscript(range: SwiftString.Index) -> Character // implicitly provided by the compiler, already

	public subscript(range: Range/*<Int>*/) -> SwiftString {
		if range.upperBound != nil {
			#if JAVA
			return SwiftString(nativeStringValue.substring(coalesce(range.lowerBound, 0), range.length))
			#elseif CLR || ISLAND
			return SwiftString(nativeStringValue.Substring(coalesce(range.lowerBound, 0), range.length))
			#elseif COCOA
			if range.lowerBound != nil {
				return SwiftString(nativeStringValue.substringWithRange(range.nativeRange)) // todo: make a cast operator
			} else {
				return SwiftString(nativeStringValue.substringToIndex(range.length))
			}
			#endif
		} else if let lowerBound = range.lowerBound {
			#if JAVA
			return SwiftString(nativeStringValue.substring(lowerBound))
			#elseif CLR || ISLAND
			return SwiftString(nativeStringValue.Substring(lowerBound))
			#elseif COCOA
			return SwiftString(nativeStringValue.substringFromIndex(lowerBound))
			#endif
		} else {
			return self
		}
	}

	// Streamable
	func writeTo(_ target: OutputStreamType) {
		//target.write(nativeStringValue)
	}

	//
	//
	//

	func split(_ separator: String) -> [String] {
		return nativeStringValue.components(separatedBy: separator)
	}

	//
	// Operators
	//

	//76158: Silver: two very odd warnings rthat make no sense
	/*func + (_ value1: SwiftString?, _ value2: SwiftString?) -> SwiftString {
		return SwiftString(value1?.nativeStringValue + value2?.nativeStringValue)
	}*/

	//76157: Silver: Internal Error in SBL
	/*
	func + (_ value1: AnyObject?, _ value2: AnyObject?) -> SwiftString {
		return SwiftString(__toNativeString(value1) + value2?.nativeStringValue)
	}*/

	//76158: Silver: two very odd warnings rthat make no sense
	/*func + (_ value1: SwiftString?, _ value2: AnyObject?) -> SwiftString {
		return SwiftString(value1?.nativeStringValue + __toNativeString(value2))
	}*/

	//
	// Silver-specific extensions not defined in standard Swift.SwiftString:
	//

	public func length() -> Int {
		#if CLR || ISLAND
		return nativeStringValue.Length
		#else
		return nativeStringValue.length()
		#endif
	}

	public func toInt() -> Int? {
		#if JAVA
		__try {
			return Integer.parseInt(nativeStringValue)
		} __catch E: NumberFormatException {
			return nil
		}
		//return self.toLowercase()
		#elseif CLR || ISLAND
		var i = 0
		if Int64.TryParse(nativeStringValue, &i) {
			return i
		}
		return nil
		#elseif COCOA
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .NSNumberFormatterOrdinalStyle
		if let number = formatter.numberFromString(nativeStringValue) {
			return number.integerValue
		}
		return nil
		#endif
	}
}
