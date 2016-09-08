#if JAVA
typealias NativeString = java.lang.String
#elseif CLR
typealias NativeString = System.String
#elseif ISLAND
typealias NativeString = RemObjects.Elements.System.String
#elseif COCOA
typealias NativeString = Foundation.NSString
#endif

public struct SwiftString /*: Streamable*/ {
	
	typealias Index = Int
	
	fileprivate var nativeStringValue: NativeString
	
	public init(count: Int, repeatedValue c: Char) {

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
		init(count: 1, repeatedValue: c)
	}

	public init(_ s: NativeString) {
		nativeStringValue = s
	}

	public init(_ s: SwiftString) {
		nativeStringValue = s.nativeStringValue
	}

	#if !ECHOES
	public init(stringLiteral s: String) {
		nativeStringValue = s
	}
	#endif

	public init(_ object: AnyObject) {
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
	// Properties
	//
	
	public var characters: SwiftString.CharacterView {
		return SwiftString.CharacterView(string: nativeStringValue) 
	}
	
	#if !ISLAND && !COCOA
	//76074: Island: SBL: cannot use `@ToString` on a struct
	@ToString public func description() -> String {
		return nativeStringValue
	}
	#endif
	
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
		return RemObjects.Elements.System.length(nativeStringValue) == 0
	}
	
	public var lowercaseString: SwiftString {
		#if JAVA
		return SwiftString(nativeStringValue.toLowerCase())
		#elseif CLR || ISLAND
		return SwiftString(nativeStringValue.ToLower())
		#elseif COCOA
		return SwiftString(nativeStringValue.lowercaseString())
		#endif
	}
	
	#if COCOA
	/*public var nulTerminatedUTF8: Character[] {
		return cStringUsingEncoding(.UTF8StringEncoding) // E62 Type mismatch, cannot assign "UnsafePointer<AnsiChar>" to "Character[]"
	}*/
	#endif
	
	public var startIndex: SwiftString.Index {
		return 0
	}
	
	public var uppercaseString: SwiftString {
		#if JAVA
		return SwiftString(nativeStringValue.toUpperCase())
		#elseif CLR || ISLAND
		return SwiftString(nativeStringValue.ToUpper())
		#elseif COCOA
		return SwiftString(nativeStringValue.uppercaseString())
		#endif
	}

	#if !ISLAND
	public var utf8: SwiftString.UTF8View {
		return SwiftString.UTF8View(string: nativeStringValue)
	}
	#endif
	
	public var utf16: SwiftString.UTF16View {
		return SwiftString.UTF16View(string: nativeStringValue)
	}
	
	#if !ISLAND
	public var unicodeScalars: SwiftString.UnicodeScalarView {
		return SwiftString.UnicodeScalarView(string: nativeStringValue)
	}
	#endif
	
	//
	// Methods
	//

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
		#if JAVA
		return SwiftString(nativeStringValue.substring(range.startIndex, range.length))
		#elseif CLR || ISLAND
		return SwiftString(nativeStringValue.Substring(range.startIndex, range.length))
		#elseif COCOA
		return SwiftString(nativeStringValue.substringWithRange(range.nativeRange)) // todo: make a cast operator
		#endif
	}
	
	// Streamable
	func writeTo(_ target: OutputStreamType) {
		target.write(nativeStringValue)
	}

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
		if Int32.TryParse(nativeStringValue, &i) {
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
	
	//
	// Nested types
	//
	
	public __abstract class BaseCharacterView {
		internal init(string: NativeString) {
		}

		public var startIndex: SwiftString.Index { return 0 }
		public __abstract var endIndex: SwiftString.Index { get }
		
	}
	
	public typealias CharacterView = UTF16View // for now
	#if !ISLAND
	public typealias UnicodeScalarView = UTF32View // for now
	#endif
	
	public class UTF16View: BaseCharacterView {
		private let stringData: NativeString
		
		internal init(string: NativeString) {
			self.stringData = string
		}
		
		public override var endIndex: SwiftString.Index { return length(stringData) }

		public subscript(index: Int) -> UTF16Char {
			return stringData[index]
		}

		@ToString public func description() -> String {
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
	}
	
	#if !ISLAND
	public class UTF32View: BaseCharacterView {
		private let stringData: Byte[]

		internal init(string: NativeString) {
			#if JAVA
			stringData = []
			fatalError("UTF32CharacterView is not implemenyted for Java yet.")
			#elseif CLR
			stringData = System.Text.UTF32Encoding(/*bigendian:*/false, /*BOM:*/false).GetBytes(string) // todo check order  
			#elseif ISLAND
			throw Exception("UTF32View is not supported on Island yet.")
			#elseif COCOA
			if let utf32 = string.dataUsingEncoding(.NSUTF16LittleEndianStringEncoding) { // todo check order  
				stringData = Byte[](capacity: utf32.length);
				utf32.getBytes(stringData, length: utf32.length);
			} else {
				stringData = []
				fatalError("Encoding of SwiftString to UTF32 failed.")
			}
			#endif
		}
		
		public override var endIndex: SwiftString.Index { return RemObjects.Elements.System.length(stringData)/4 }

		public subscript(index: Int) -> UTF32Char {
			return stringData[index*4] + stringData[index*4+1]<<8 + stringData[index*4+2]<<16 + stringData[index*4+3]<<24 // todo: check if order is correct
		}

		@ToString public func description() -> String {
			var result = "UTF32CharacterView("
			for i in startIndex..<endIndex {
				if i > startIndex {
					result += " "
				}
				result += UInt64(self[i]).toHexString(length: 8)
			}
			result += ")"
			return result
		}
	}
	#endif
	
	#if !ISLAND
	public class UTF8View: BaseCharacterView {
		internal let stringData: UTF8Char[]
		
		internal init(string: NativeString) {
			#if JAVA
			stringData = []
			fatalError("UTF8CharacterView is not implemenyted for Java yet.")
			#elseif CLR
			stringData = System.Text.UTF8Encoding(/*BOM:*/false).GetBytes(string) // todo check order  
			#elseif ISLAND
			throw Exception("UTF8View is not supported on Island yet.")
			#elseif COCOA
			if let utf8 = string.dataUsingEncoding(.NSUTF8StringEncoding) { // todo check order  
				stringData = UTF8Char[](capacity: utf8.length);
				utf8.getBytes(stringData, length: utf8.length);
			} else {
				stringData = []
				fatalError("Encoding of String to UTF8 failed.")
			}
			#endif
		}
		
		public override var endIndex: SwiftString.Index { return RemObjects.Elements.System.length(stringData) }

		public subscript(index: Int) -> UTF8Char {
			return stringData[index]
		}

		@ToString public func description() -> String {
			var result = "UTF8CharacterView("
			for i in startIndex..<endIndex {
				if i > startIndex {
					result += " "
				}
				result += UInt64(self[i]).toHexString(length: 2)
			}
			result += ")"
			return result
		}
	}
	#endif
}

