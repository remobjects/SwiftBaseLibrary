public extension String {
	
	typealias Index = Int
	
	public init(count: Int, repeatedValue c: Char) {

		#if COOPER
		var chars = Char[](count)
		for var i: Int = 0; i < count; i++ {
			chars[i] = c
		}
		return String(chars)
		#elseif ECHOES
		return String(c, count)
		#elseif NOUGAT
		return "".stringByPaddingToLength(count, withString: NSString.stringWithFormat("%c", c), startingAtIndex: 0)
		#endif
	}
	
	public var startIndex: String.Index { return 0 }
	
	public var endIndex: String.Index { 
		#if ECHOES
		return self.Length-1
		#else
		return self.length()-1 
		#endif
	}
	
	#if !NOUGAT
	public func length() -> Int {
		#if ECHOES
		return self.Length
		#else
		return self.length() 
		#endif
	}
	#endif
	
	public var isEmpty: Bool { return length() == 0 }
	
	#if !NOUGAT
	public func lowercaseString() -> String {
		#if COOPER
		return self.toLowerCase()
		#elseif ECHOES
		return self.ToLower()
		#endif
	}
	public func uppercaseString() -> String {
		#if COOPER
		return self.toUpperCase()
		#elseif ECHOES
		return self.ToUpper()
		#endif
	}
	
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
		return self.integerValue 
		#hint ToDo: doesnt handle invalid strings to return nil, yet
		#endif
	}
	
	/*public func generate() -> IndexingGenerator<String> {
	}*/
	
	/*public var utf8: UTF8View {
	}
	
	public var nulTerminatedUTF8: ContiguousArray<CodeUnit> { 
		#if ECHOES
		#elseif NOUGAT
		return self.UTF8String()
		#endif
	}*/
	
	/*public func rangeOfString(string: String) -> Range? {
		#if COOPER
		#elseif ECHOES
		let start = IndexOf(string);
		if start >= 0 {
			return Range(start: start, length: string.length())
		}
		#elseif NOUGAT
		var range = (self as! NSString).rangeOfString(string);
		if range.location != NSNotFound {
			return Range(Range: range)
		}
		#endif
		return nil
	}*/
	
	/*
	#if NOUGAT
	public static func fromCString(cs: UnsafePointer<CChar>) -> String? {
	}

	/// Creates a new `String` by copying the nul-terminated UTF-8 data
	/// referenced by a `CString`.
	///
	/// Returns `nil` if the `CString` is `NULL`.  If `CString` contains
	/// ill-formed UTF-8 code unit sequences, replaces them with replacement
	/// characters (U+FFFD).
	public static func fromCStringRepairingIllFormedUTF8(cs: UnsafePointer<CChar>) -> (String?, hadError: Bool) {
	}
	#endif
	/* Views */

	public var unicodeScalars: String.UnicodeScalarView { 
		//return String.UnicodeScalarView(/*string:*/ self)
	}
	public var utf8: String.UTF8View {
		//return String.UTF8View(string: self)
	}
	public var utf16: String.UTF16View { 
		//return String.UTF16View(string: self)
	}

	public class BaseView /*: ISequence<UnicodeScalar>*/ {
		internal let _string: String
		internal public init(string: String) {
			_string = string;
		}
	}
	
	public class UnicodeScalarView : BaseView /*: ISequence<UnicodeScalar>*/ {

		internal public init(string: String) {
			super.init(string: string)
			#if COOPER
			#elseif ECHOES
			_data = System.Text.UTF32Encoding(/*bigendian:*/false, /*BOM:*/false).GetBytes(string) // todo check order  
			#elseif NOUGAT
			_utf32 = (string as! NSString).dataUsingEncoding(NSStringEncoding.NSUTF16LittleEndianStringEncoding) // todo check order  
			_data = _utf32.bytes as! UnsafePointer<Byte>
			#endif
		}

		#if COOPER
		private let _data: Byte[] //todo
		private var _length: Int { return _data.length/4 }
		#elseif ECHOES
		private let _data: Byte[]
		private var _length: Int { return _data.Length/4 }
		#elseif NOUGAT
		private let _utf32: NSData
		private let _data: UnsafePointer<Byte>
		private var _length: Int { return _utf32.length/4 }
		#endif

		public var startIndex: String.Index { return 0 }
		public var endIndex: String.Index { return _length-1 }

		public subscript (i: String.Index) -> UInt32 {
			return _data[i] | _data[i+1] << 8 | _data[i+2] << 16 | _data[i+3] << 24 // todo: probably wrong order, check
		}
	}
	
	public class UTF8View : BaseView /*: ISequence<UnicodeScalar>*/ {
		
		internal public init(string: String) {
			super.init(string: string)
			#if COOPER
			#elseif ECHOES
			_data = System.Text.UTF8Encoding(/*BOM:*/false).GetBytes(string)
			#elseif NOUGAT
			_data = (string as! NSString).UTF8String
			_length = strlen(_data)
			#endif
		}
		
		#if COOPER
		private let _data: Byte[] //todo
		private var _length: Int { return _data.length }
		#elseif ECHOES
		private let _data: Byte[]
		private var _length: Int { return _data.Length }
		#elseif NOUGAT
		private let _data: UnsafePointer<AnsiChar>
		private let _length: Int
		#endif

		public var startIndex: String.Index { return 0 }
		public var endIndex: String.Index { return _length-1 }

		public subscript (i: String.Index) -> AnsiChar {
			return _data[i]
		}
	}
	public class UTF16View : BaseView /*: ISequence<UnicodeScalar>*/ {

		public var startIndex: String.Index { return _string.startIndex }
		public var endIndex: String.Index { return _string.endIndex }

		public subscript (i: String.Index) -> Character {
			#if COOPER
			return (_string as! java.lang.String)[i]
			#elseif ECHOES
			return (_string as! System.String)[i]
			#elseif NOUGAT
			return (_string as! Foundation.NSString)[i]
			#endif
		}
	}

*/

}