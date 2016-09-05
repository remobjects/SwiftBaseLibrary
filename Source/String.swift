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
	
	fileprivate var stringValue: NativeString
	
	public init(count: Int, repeatedValue c: Char) {

		#if JAVA || ISLAND
		var chars = Char[](count)
		for i in 0 ..< count {
			chars[i] = c
		}
		stringValue = NativeString(chars)
		#elseif CLR
		stringValue = NativeString(c, count)
		#elseif COCOA
		stringValue = "".stringByPaddingToLength(count, withString: NSString.stringWithFormat("%c", c), startingAtIndex: 0)
		#endif
	}

	public convenience init(_ c: Char) {
		init(count: 1, repeatedValue: c)
	}

	public init(_ object: AnyObject) {
		if let o = object as? ICustomStringConvertible {
			stringValue = o.description
		} else {
			#if JAVA
			stringValue = object.toString()
			#elseif CLR || ISLAND
			stringValue = object.ToString()
			#elseif COCOA
			stringValue = object.description
			#endif
		}
	}
	
	//76037: Silver: compiler gets confused with overloaded ctors
	/*public convenience init(reflecting subject: Object) {
		if let o = subject as? ICustomDebugStringConvertible {
			init(o.debugDescription)
		} else {
			#if JAVA
			// ToDo: fall back to reflection to call debugDescription?
			// ToDo: fall back to checking for extension methods
			#elseif CLR
			// ToDo: fall back to reflection to call debugDescription?
			// ToDo: fall back to checking for extension methods
			#elseif COCOA
			if subject.respondsToSelector(#selector(debugDescription)) {
				stringValue = subject.debugDescription
			}
			// ToDo: fall back to checking for extension methods
			#endif
			init(subject)
		}
	}*/
	
	#if COCOA
	init/*?*/ (cString: UnsafePointer<AnsiChar>, encoding: SwiftString.Encoding) {
		stringValue = "" // WORKAROUND
		if cString == nil {
			//return nil
		} else {
			stringValue = NSString.stringWithCString(cString, encoding: encoding.nativeEncoding)
			if stringValue == nil {
				//return nil
			}
		}
	}
	
	init/*?*/ (utf8String: UnsafePointer<AnsiChar>) {
		stringValue = "" // WORKAROUND
		if utf8String == nil {
			//return nil
		} else {
			stringValue = NSString.stringWithUTF8String(utf8String)
			if stringValue == nil {
				//return nil
			}
		}
	}

	init/*?*/ (validatingUTF8 utf8String: UnsafePointer<AnsiChar>) { // E1 opening bracket expected, got 
		if utf8String == nil {
			//return nil
		}
		//todo:  If CString contains ill-formed UTF-8 code unit sequences, replaces them with replacement characters (U+FFFD).
		stringValue = NSString.stringWithUTF8String(utf8String)
		if stringValue == nil {
			//return nil
		}
	}
	#endif
	
	//
	// Properties
	//
	
	public var characters: SwiftString.CharacterView {
		return SwiftString.CharacterView(string: stringValue) 
	}
	
	#if !COCOA
	public var debugDescription: SwiftString {
		return self
	}
	#endif
	
	public var endIndex: SwiftString.Index { 
		return RemObjects.Elements.System.length(stringValue) // for now?
	}
	
	var fastestEncoding: SwiftString.Encoding { return SwiftString.Encoding.utf16 }
	
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
		return RemObjects.Elements.System.length(stringValue) == 0
	}
	
	public var lowercaseString: SwiftString {
		#if JAVA
		return SwiftString(stringValue.toLowerCase())
		#elseif CLR || ISLAND
		return SwiftString(stringValue.ToLower())
		#elseif COCOA
		return SwiftString(stringValue.lowercaseString())
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
		return SwiftString(stringValue.toUpperCase())
		#elseif CLR || ISLAND
		return SwiftString(stringValue.ToUpper())
		#elseif COCOA
		return SwiftString(stringValue.uppercaseString())
		#endif
	}

	public var utf8: SwiftString.UTF8View {
		return SwiftString.UTF8View(string: stringValue)
	}
	
	public var utf16: SwiftString.UTF16View {
		return SwiftString.UTF16View(string: stringValue)
	}
	
	public var unicodeScalars: SwiftString.UnicodeScalarView {
		return SwiftString.UnicodeScalarView(string: stringValue)
	}
	
	//
	// Methods
	//

	#if !COCOA
	public func hasPrefix(_ `prefix`: SwiftString) -> Bool {
		#if JAVA
		return stringValue.startsWith(`prefix`.stringValue)
		#elseif CLR || ISLAND
		return stringValue.StartsWith(`prefix`.stringValue)
		#elseif COCOA
		return stringValue.hasPrefix(`prefix`.stringValue)
		#endif
	}

	public func hasSuffix(_ suffix: SwiftString) -> Bool {
		#if JAVA
		return stringValue.endsWith(suffix.stringValue)
		#elseif CLR || ISLAND
		return stringValue.EndsWith(suffix.stringValue)
		#elseif COCOA
		return stringValue.hasSuffix(`prefix`.stringValue)
		#endif
	}
	#endif
	
	public func withUTF8Buffer<R>(@noescape _ body: (/*UnsafeBufferPointer<UInt8>*/UTF8Char[]) -> R) -> R {
		return body(utf8.stringData)
	}
	
	//
	// Subscripts
	//
	
	//public subscript(range: SwiftString.Index) -> Character // implicitly provided by the compiler, already
	
	public subscript(range: Range/*<Int>*/) -> SwiftString {
		#if JAVA
		return SwiftString(stringValue.substring(range.startIndex, range.length))
		#elseif CLR || ISLAND
		return SwiftString(stringValue.Substring(range.startIndex, range.length))
		#elseif COCOA
		return SwiftString(stringValue.substringWithRange(range.nativeRange)) // todo: make a cast operator
		#endif
	}
	
	// Streamable
	func writeTo(_ target: OutputStreamType) {
		target.write(stringValue)
	}

	//
	// Silver-specific extensions not defined in standard Swift.SwiftString:
	//

	public func length() -> Int {
		#if CLR || ISLAND
		return stringValue.Length
		#else
		return stringValue.length() 
		#endif
	}
	
	public func toInt() -> Int? {
		#if JAVA
		__try {
			return Integer.parseInt(stringValue)
		} __catch E: NumberFormatException {
			return nil
		}
		//return self.toLowercase()
		#elseif CLR// || ISLAND
		var i = 0
		if Int32.TryParse(stringValue, &i) {
			return i
		}
		return nil
		#elseif COCOA
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .NSNumberFormatterOrdinalStyle
		if let number = formatter.numberFromString(stringValue) {
			return number.integerValue
		}
		return nil
		#endif
	}
	
	//
	// Nested types
	//
	
	public struct Encoding {
		static let utf16: SwiftString.Encoding = Encoding()
		#if COCOA
		var nativeEncoding: NSStringEncoding
		#endif
	}
	
	public __abstract class BaseCharacterView {
		internal init(string: NativeString) {
		}

		public var startIndex: SwiftString.Index { return 0 }
		public __abstract var endIndex: SwiftString.Index { get }
		
	}
	
	public typealias CharacterView = UTF16View // for now
	public typealias UnicodeScalarView = UTF32View // for now
	
	public class UTF16View: BaseCharacterView, ICustomDebugStringConvertible {
		private let stringData: NativeString
		
		internal init(string: NativeString) {
			self.stringData = string
		}
		
		public override var endIndex: SwiftString.Index { return length(stringData) }

		public subscript(index: Int) -> UTF16Char {
			return stringData[index]
		}

		//@ToString public func description() -> String { // ASPE ToString method must return a String type
		#if COCOA
		override var debugDescription: String! {
		#else
		public var debugDescription: String {
		#endif
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
	
	public class UTF32View: BaseCharacterView, ICustomDebugStringConvertible {
		private let stringData: Byte[]

		internal init(string: NativeString) {
			#if JAVA
			stringData = []
			fatalError("UTF32CharacterView is not implemenyted for Java yet.")
			#elseif CLR
			stringData = System.Text.UTF32Encoding(/*bigendian:*/false, /*BOM:*/false).GetBytes(string) // todo check order  
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

		//@ToString public func description() -> String { // ASPE ToString method must return a String type
		#if COCOA
		override var debugDescription: String! {
		#else
		public var debugDescription: String {
		#endif
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
	
	public class UTF8View: BaseCharacterView, ICustomDebugStringConvertible {
		internal let stringData: UTF8Char[]
		
		internal init(string: NativeString) {
			#if JAVA
			stringData = []
			fatalError("UTF8CharacterView is not implemenyted for Java yet.")
			#elseif CLR
			stringData = System.Text.UTF8Encoding(/*BOM:*/false).GetBytes(string) // todo check order  
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

		//@ToString public func description() -> String { // ASPE ToString method must return a String type
		#if COCOA
		override var debugDescription: String! {
		#else
		public var debugDescription: String {
		#endif
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
}

