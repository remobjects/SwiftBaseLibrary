public extension String /*: Streamable*/ {
	
	typealias Index = Int
	
	public init(count: Int, repeatedValue c: Char) {

		#if COOPER
		var chars = Char[](count)
		for i in 0 ..< count {
			chars[i] = c
		}
		return String(chars)
		#elseif ECHOES
		return String(c, count)
		#elseif NOUGAT
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
			#if COOPER
			return object.toString()
			#elseif ECHOES
			return object.ToString()
			#elseif NOUGAT
			return object.description
			#endif
		}
	}
	
	public init(reflecting subject: Object) {
		if let o = subject as? ICustomDebugStringConvertible {
			return o.debugDescription
		} else {
			#if COOPER
			// ToDo: fall back to reflection to call debugDescription?
			// ToDo: fall back to checking for extension methods
			#elseif ECHOES
			// ToDo: fall back to reflection to call debugDescription?
			// ToDo: fall back to checking for extension methods
			#elseif NOUGAT
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
	
	#if !NOUGAT
	public var debugDescription: String {
		return self
	}
	#endif
	
	public var endIndex: String.Index { 
		#if ECHOES
		return self.Length
		#else
		return self.length()
		#endif
	}
	
	public var hashValue: Int {
		#if COOPER
		return self.hashCode()
		#elseif ECHOES
		return self.GetHashCode()
		#elseif NOUGAT
		return self.hashValue()
		#endif
	}
	
	public var isEmpty : Bool {
		return length() == 0
	}
	
	#if !NOUGAT
	public var lowercaseString: String {
		#if COOPER
		return self.toLowerCase()
		#elseif ECHOES
		return self.ToLower()
		#endif
	}
	#endif
	
	#if NOUGAT
	/*public var nulTerminatedUTF8: Character[] {
		return cStringUsingEncoding(.UTF8StringEncoding) // E62 Type mismatch, cannot assign "UnsafePointer<AnsiChar>" to "Character[]"
	}*/
	#endif
	
	public var startIndex: String.Index {
		return 0
	}
	
	#if !NOUGAT
	public var uppercaseString: String {
		#if COOPER
		return self.toUpperCase()
		#elseif ECHOES
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

	#if !NOUGAT
	public func hasPrefix(`prefix`: String) -> Bool {
		#if COOPER
		return startsWith(`prefix`)
		#elseif ECHOES
		return StartsWith(`prefix`)
		#endif
	}

	public func hasSuffix(suffix: String) -> Bool {
		#if COOPER
		return endsWith(suffix)
		#elseif ECHOES
		return EndsWith(suffix)
		#endif
	}
	#endif
	
	#if NOUGAT
	public static func fromCString(cs: UnsafePointer<AnsiChar>) -> String? {
		if cs == nil {
			return nil
		}
		return NSString.stringWithUTF8String(cs)
	}
	
	public static func fromCStringRepairingIllFormedUTF8(cs: UnsafePointer<AnsiChar>) -> (String?, /*hadError:*/ Bool) {
		if cs == nil {
			return (nil, false)
		}
		//todo:  If CString contains ill-formed UTF-8 code unit sequences, replaces them with replacement characters (U+FFFD).
		return (NSString.stringWithUTF8String(cs), false)
	}
	#endif
	
	public func withUTF8Buffer<R>(@noescape body: (/*UnsafeBufferPointer<UInt8>*/UTF8Char[]) -> R) -> R {
		return body(utf8.stringData)
	}
	
	//
	// Subscripts
	//
	
	//public subscript(range: String.Index) -> Character // implicitly provided by the compiler, already
	
	public subscript(range: Range/*<Int>*/) -> String {
		#if COOPER
		return substring(range.startIndex, range.length)
		#elseif ECHOES
		return Substring(range.startIndex, range.length)
		#elseif NOUGAT
		return substringWithRange(range.nativeRange) // todo: make a cast operator
		#endif
	}
	
	// Streamable
	func writeTo<Target: OutputStreamType>(inout _ target: Target) {
		target.write(self)
	}

	//
	// Silver-specific extensions not defined in standard Swift.String:
	//

	#if !NOUGAT
	public func length() -> Int {
		#if ECHOES
		return self.Length
		#else
		return self.length() 
		#endif
	}
	#endif
	
	public func toInt() -> Int? {
		#if COOPER
		__try {
			return Integer.parseInt(self)
		} __catch E: NumberFormatException {
			return nil
		}
		//return self.toLowercase()
		#elseif ECHOES
		var i = 0
		if Int32.TryParse(self, &i) {
			return i
		}
		return nil
		#elseif NOUGAT
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .NSNumberFormatterOrdinalStyle
		if let number = formatter.numberFromString(self) {
			return number.integerValue
		}
		return nil
		#endif
	}
	
	public __abstract class CharacterView {
		private init(string: String) {
		}

		public var startIndex: String.Index { return 0 }
		public __abstract var endIndex: String.Index { get }
		
	}
	
	public class UTF16CharacterView: CharacterView, ICustomDebugStringConvertible {
		private let string: String
		
		private init(string: String) {
			self.string = string
		}
		
		public override var endIndex: String.Index { return length(string) }

		public subscript(index: Int) -> UTF16Char {
			return string[index]
		}

		#if NOUGAT
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
		private let stringData: Byte[]

		private init(string: String) {
			#if COOPER
			stringData = []
			fatalError("UTF32CharacterView is not implemenyted for Java yet.")
			#elseif ECHOES
			stringData = System.Text.UTF32Encoding(/*bigendian:*/false, /*BOM:*/false).GetBytes(string) // todo check order  
			#elseif NOUGAT
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

		#if NOUGAT
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
		private let stringData: UTF8Char[]
		
		private init(string: String) {
			#if COOPER
			stringData = []
			fatalError("UTF8CharacterView is not implemenyted for Java yet.")
			#elseif ECHOES
			stringData = System.Text.UTF8Encoding(/*BOM:*/false).GetBytes(string) // todo check order  
			#elseif NOUGAT
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

		#if NOUGAT
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

