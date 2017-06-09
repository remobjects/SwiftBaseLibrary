public extension NativeString : Streamable {

	typealias Index = Int

	public init(count: Int, repeatedValue c: Char) {

		#if JAVA || ISLAND
		var chars = Char[](count)
		for i in 0 ..< count {
			chars[i] = c
		}
		return NativeString(chars)
		#elseif CLR
		return NativeString(c, count)
		#elseif COCOA
		return "".stringByPaddingToLength(count, withString: NSString.stringWithFormat("%c", c), startingAtIndex: 0)
		#endif
	}

	public init(_ c: Char) {
		return NativeString(count: 1, repeatedValue: c)
	}

	public init(_ object: AnyObject) {
		if let o = object as? ICustomStringConvertible {
			return o.description
		} else {
			#if JAVA
			return object.toString()
			#elseif CLR || ISLAND
			return object.ToString()
			#elseif COCOA
			return object.description
			#endif
		}
	}

	public convenience init(reflecting subject: Object) {
		if let o = subject as? ICustomDebugStringConvertible {
			return o.debugDescription
		} else {
			#if JAVA
			// ToDo: fall back to reflection to call debugDescription?
			// ToDo: fall back to checking for extension methods
			#elseif CLR
			// ToDo: fall back to reflection to call debugDescription?
			// ToDo: fall back to checking for extension methods
			#elseif COCOA
			if subject.respondsToSelector(#selector(debugDescription)) {
				return subject.debugDescription
			}
			// ToDo: fall back to checking for extension methods
			#endif
		}

		return init(subject)
	}

	//
	// Properties
	//

	public var characters: SwiftString.CharacterView {
		return SwiftString.CharacterView(string: self)
	}

	#if !COCOA
	public var debugDescription: NativeString {
		return self
	}
	#endif

	public var endIndex: NativeString.Index {
		#if CLR
		return self.Length
		#else
		return self.length()
		#endif
	}

	public var hashValue: Int {
		#if JAVA
		return self.hashCode()
		#elseif CLR || ISLAND
		return self.GetHashCode()
		#elseif COCOA
		return self.hashValue()
		#endif
	}

	public var isEmpty : Bool {
		return length() == 0
	}

	#if !COCOA
	public var lowercaseString: NativeString {
		#if JAVA
		return self.toLowerCase()
		#elseif CLR || ISLAND
		return self.ToLower()
		#endif
	}
	#endif

	#if COCOA
	/*public var nulTerminatedUTF8: Character[] {
		return cStringUsingEncoding(.UTF8StringEncoding) // E62 Type mismatch, cannot assign "UnsafePointer<AnsiChar>" to "Character[]"
	}*/
	#endif

	public var startIndex: NativeString.Index {
		return 0
	}

	#if !COCOA
	public var uppercaseString: NativeString {
		#if JAVA
		return self.toUpperCase()
		#elseif CLR || ISLAND
		return self.ToUpper()
		#endif
	}
	#endif

	#if !ISLAND
	public var utf8: SwiftString.UTF8View {
		return SwiftString.UTF8View(string: self)
	}
	#endif

	public var utf16: SwiftString.UTF16View {
		return SwiftString.UTF16View(string: self)
	}

	#if !ISLAND
	public var unicodeScalars: SwiftString.UnicodeScalarView {
		return SwiftString.UnicodeScalarView(string: self)
	}
	#endif

	//
	// Methods
	//

	#if !COCOA
	public func hasPrefix(_ `prefix`: NativeString) -> Bool {
		#if JAVA
		return startsWith(`prefix`)
		#elseif CLR || ISLAND
		return StartsWith(`prefix`)
		#endif
	}

	public func hasSuffix(_ suffix: NativeString) -> Bool {
		#if JAVA
		return endsWith(suffix)
		#elseif CLR || ISLAND
		return EndsWith(suffix)
		#endif
	}
	#endif

	#if COCOA
	public static func fromCString(cs: UnsafePointer<AnsiChar>) -> NativeString? {
		if cs == nil {
			return nil
		}
		return NSString.stringWithUTF8String(cs)
	}

	public static func fromCStringRepairingIllFormedUTF8(_ cs: UnsafePointer<AnsiChar>) -> (NativeString?, /*hadError:*/ Bool) {
		if cs == nil {
			return (nil, false)
		}
		//todo:  If CString contains ill-formed UTF-8 code unit sequences, replaces them with replacement characters (U+FFFD).
		return (NSString.stringWithUTF8String(cs), false)
	}
	#endif

	#if !ISLAND
	public func withUTF8Buffer<R>(@noescape _ body: (/*UnsafeBufferPointer<UInt8>*/UTF8Char[]) -> R) -> R {
		return body(utf8.stringData)
	}
	#endif

	//
	// Subscripts
	//

	func `prefix`(through: Index) -> NativeString {
		return __substring(range: 0...through)
	}

	func `prefix`(upTo: Index) -> NativeString {
		return __substring(range: 0..<upTo)
	}

	func suffix(from: Index) -> NativeString {
		return __substring(range: from..<length())
	}

	//public subscript(range: NativeString.Index) -> Character // implicitly provided by the compiler, already

	//76192: Silver: can't use range as subscript? (SBL)
	internal func __substring(range: Range/*<Int>*/) -> NativeString {
	//public subscript(range: Range/*<Int>*/) -> NativeString {
		#if JAVA
		return substring(range.lowerBound, range.length)
		#elseif CLR || ISLAND
		return Substring(range.lowerBound, range.length)
		#elseif COCOA
		return substringWithRange(range.nativeRange) // todo: make a cast operator
		#endif
	}

	// Streamable
	func writeTo(_ target: OutputStreamType) {
		target.write(self)
	}

	//
	// Silver-specific extensions not defined in standard Swift.NativeString:
	//

	#if !COCOA
	public func length() -> Int {
		#if CLR
		return self.Length
		#else
		return self.length()
		#endif
	}
	#endif

	public func toInt() -> Int? {
		#if JAVA
		__try {
			return Integer.parseInt(self)
		} __catch E: NumberFormatException {
			return nil
		}
		#elseif CLR || ISLAND
		var i = 0
		if Int32.TryParse(self, &i) {
			return i
		}
		return nil
		#elseif COCOA
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .NSNumberFormatterOrdinalStyle
		if let number = formatter.numberFromString(self) {
			return number.integerValue
		}
		return nil
		#endif
	}

	public __abstract class CharacterView {
		/*fileprivate*/internal init(string: NativeString) {
		}

		public var startIndex: NativeString.Index { return 0 }
		public __abstract var endIndex: NativeString.Index { get }

	}

	public class UTF16CharacterView: CharacterView, ICustomDebugStringConvertible {
		private let string: NativeString

		/*fileprivate*/internal  init(string: NativeString) {
			self.string = string
		}

		public override var endIndex: NativeString.Index { return length(string) }

		public subscript(index: Int) -> UTF16Char {
			return string[index]
		}

		#if COCOA
		override var debugDescription: NativeString! {
			var result = "UTF16CharacterView("
			for i in startIndex..<endIndex {
				if i > startIndex {
					result += " "
				}
				result += UInt64(self[i]).toHexString(length: 4)
			}
			result += ")"
			return result
		}
		#else
		public var debugDescription: NativeString {
			var result = "UTF16CharacterView("
			for i in startIndex..<endIndex {
				if i > startIndex {
					result += " "
				}
				result += UInt64(self[i]).toHexString(length: 4)
			}
			result += ")"
			return result
		}
		#endif
	}

}

