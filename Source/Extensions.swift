
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