
#if !NOUGAT
extension Object  {

	public var description: String {
		#if COOPER
		return self.toString()
		#elseif ECHOES
		return self.ToString()
		#endif
	}

	public var debugDescription: String { 
		#if COOPER
		return self.toString()
		#elseif ECHOES
		return self.ToString()
		#endif
	}
}
#endif

extension UInt8 {
	public static let max: UInt8 = 0xff
	public static let min: UInt8 = 0
	public static let allZeros: UInt8 = 0
}

extension UInt16 {
	public static let max: UInt16 = 0xffff
	public static let min: UInt16 = 0
	public static let allZeros: UInt8 = 0
}

extension UInt32 {
	public static let max: UInt32 = 0xffff_ffff
	public static let min: UInt32 = 0
	public static let allZeros: UInt8 = 0
}

extension UInt64 {
	public static let max: UInt64 = 0xffff_ffff_ffff_ffff
	public static let min: UInt64 = 0
	public static let allZeros: UInt8 = 0
}

extension Int8 {
	public static let max: Int8 = 0x7f
	public static let min: Int8 = -0x80
	public static let allZeros: UInt8 = 0
}

extension Int16 {
	public static let max: Int16 = 0x7fff
	public static let min: Int16 = -0x8000
	public static let allZeros: UInt8 = 0
}

extension Int32 {
	public static let max: Int32 = 0x7fff_ffff
	public static let min: Int32 = -0x8000_0000
	public static let allZeros: UInt8 = 0
}

extension Int64 {
	public static let max: Int64 = 0x7fff_ffff_ffff_ffff 
	public static let min: Int64 = -0x8000_0000_0000_0000
	public static let allZeros: UInt8 = 0
}

extension UnicodeScalar {
	
	public var value: UInt32 { 
		return self as! UInt32 
	}
	
	public func escape(# asASCII: Bool) -> String {
		if asASCII && !isASCII() {
			#if COOPER
			return self.toString()
			#elseif ECHOES
			return self.ToString()
			#elseif NOUGAT
			return self.description
			#endif
		}
		else {
			#if COOPER
			return java.lang.String.format("\\u{%8x}", self as! Int32)
			#elseif ECHOES
			return System.String.Format("\\u{{{0:X8}}}", self as! Int32)
			#elseif NOUGAT
			return Foundation.NSString.stringWithFormat("\\u{%8x}", self as! Int32)
			#endif
		}
	}
	
	public func isASCII() -> Bool { // Method "static UnicodeScalar.isASCII() -> Bool" hides a method in parent class with the same name and signature
		return self <= 127
	}
	
	/*public func writeTo<Target : OutputStreamType>(inout target: Target) {
	}*/
}

extension String {
	
	typealias Index = Int
	
	/*init(count: Int, repeatedValue c: Character) {
	}*/
	
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
	
	var isEmpty: Bool { return length() == 0 }
	
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
	
	func toInt() -> Int? {
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
	
	/*func generate() -> IndexingGenerator<String> {
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
	
}

