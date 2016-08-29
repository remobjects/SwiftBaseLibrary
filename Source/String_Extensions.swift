public extension String : Streamable {
	
	typealias Index = Int
	
	public init(count: Int, repeatedValue c: Char) {

		#if JAVA || ISLAND
		var chars = Char[](count)
		for i in 0 ..< count {
			chars[i] = c
		}
		return String(chars)
		#elseif CLR
		return String(c, count)
		#elseif COCOA
		return "".stringByPaddingToLength(count, withString: NSString.stringWithFormat("%c", c), startingAtIndex: 0)
		#endif
	}

	public init(_ c: Char) {
		return String(count: 1, repeatedValue: c)
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
	
	public init(reflecting subject: Object) {
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
	
	public var characters: String.UTF16CharacterView {
		return String.UTF16CharacterView(string: self)
	}
	
	#if !COCOA
	public var debugDescription: String {
		return self
	}
	#endif
	
	public var endIndex: String.Index { 
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
	public var lowercaseString: String {
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
	
	public var startIndex: String.Index {
		return 0
	}
	
	#if !COCOA
	public var uppercaseString: String {
		#if JAVA
		return self.toUpperCase()
		#elseif CLR || ISLAND
		return self.ToUpper()
		#endif
	}
	#endif

	public var utf8: String.UTF8CharacterView {
		return String.UTF8CharacterView(string: self)
	}
	
	public var utf16: String.UTF16CharacterView {
		return String.UTF16CharacterView(string: self)
	}
	
	public var unicodeScalars: String.UTF32CharacterView {
		return String.UTF32CharacterView(string: self)
	}
	
	//
	// Methods
	//

	#if !COCOA
	public func hasPrefix(_ `prefix`: String) -> Bool {
		#if JAVA
		return startsWith(`prefix`)
		#elseif CLR || ISLAND
		return StartsWith(`prefix`)
		#endif
	}

	public func hasSuffix(_ suffix: String) -> Bool {
		#if JAVA
		return endsWith(suffix)
		#elseif CLR || ISLAND
		return EndsWith(suffix)
		#endif
	}
	#endif
	
	#if COCOA
	public static func fromCString(cs: UnsafePointer<AnsiChar>) -> String? {
		if cs == nil {
			return nil
		}
		return NSString.stringWithUTF8String(cs)
	}
	
	public static func fromCStringRepairingIllFormedUTF8(_ cs: UnsafePointer<AnsiChar>) -> (String?, /*hadError:*/ Bool) {
		if cs == nil {
			return (nil, false)
		}
		//todo:  If CString contains ill-formed UTF-8 code unit sequences, replaces them with replacement characters (U+FFFD).
		return (NSString.stringWithUTF8String(cs), false)
	}
	#endif
	
	public func withUTF8Buffer<R>(@noescape _ body: (/*UnsafeBufferPointer<UInt8>*/UTF8Char[]) -> R) -> R {
		return body(utf8.stringData)
	}
	
	//
	// Subscripts
	//
	
	//public subscript(range: String.Index) -> Character // implicitly provided by the compiler, already
	
	public subscript(range: Range/*<Int>*/) -> String {
		#if JAVA
		return substring(range.startIndex, range.length)
		#elseif CLR || ISLAND
		return Substring(range.startIndex, range.length)
		#elseif COCOA
		return substringWithRange(range.nativeRange) // todo: make a cast operator
		#endif
	}
	
	// Streamable
	func writeTo(_ target: OutputStreamType) {
		target.write(self)
	}

	//
	// Silver-specific extensions not defined in standard Swift.String:
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
		//return self.toLowercase()
		#elseif CLR
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
		/*fileprivate*/internal init(string: String) {
		}

		public var startIndex: String.Index { return 0 }
		public __abstract var endIndex: String.Index { get }
		
	}
	
	public class UTF16CharacterView: CharacterView, ICustomDebugStringConvertible {
		private let string: String
		
		/*fileprivate*/internal  init(string: String) {
			self.string = string
		}
		
		public override var endIndex: String.Index { return length(string) }

		public subscript(index: Int) -> UTF16Char {
			return string[index]
		}

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
	
	public class UTF32CharacterView: CharacterView, ICustomDebugStringConvertible {
		/*fileprivate*/internal let stringData: Byte[]

		/*fileprivate*/internal  init(string: String) {
			#if JAVA
			stringData = []
			fatalError("UTF32CharacterView is not implemenyted for Java yet.")
			#elseif CLR
			stringData = System.Text.UTF32Encoding(/*bigendian:*/false, /*BOM:*/false).GetBytes(string) // todo check order  
			#elseif COCOA
			if let utf32 = (string as! NSString).dataUsingEncoding(.NSUTF16LittleEndianStringEncoding) { // todo check order  
				stringData = Byte[](capacity: utf32.length);
				utf32.getBytes(stringData, length: utf32.length);
			} else {
				stringData = []
				fatalError("Encoding of string to UTF32 failed.")
			}
			#endif
		}
		
		public override var endIndex: String.Index { return RemObjects.Elements.System.length(stringData)/4 }

		public subscript(index: Int) -> UTF32Char {
			return stringData[index*4] + stringData[index*4+1]<<8 + stringData[index*4+2]<<16 + stringData[index*4+3]<<24 // todo: check if order is correct
		}

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
	
	public class UTF8CharacterView: CharacterView, ICustomDebugStringConvertible {
		/*fileprivate*/internal  let stringData: UTF8Char[]
		
		/*fileprivate*/internal init(string: String) {
			#if JAVA
			stringData = []
			fatalError("UTF8CharacterView is not implemenyted for Java yet.")
			#elseif CLR
			stringData = System.Text.UTF8Encoding(/*BOM:*/false).GetBytes(string) // todo check order  
			#elseif COCOA
			if let utf8 = (string as! NSString).dataUsingEncoding(.NSUTF8StringEncoding) { // todo check order  
				stringData = UTF8Char[](capacity: utf8.length);
				utf8.getBytes(stringData, length: utf8.length);
			} else {
				stringData = []
				fatalError("Encoding of string to UTF8 failed.")
			}
			#endif
		}
		
		public override var endIndex: String.Index { return RemObjects.Elements.System.length(stringData) }

		public subscript(index: Int) -> UTF8Char {
			return stringData[index]
		}

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

