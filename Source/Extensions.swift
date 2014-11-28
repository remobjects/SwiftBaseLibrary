
#if !NOUGAT
extension Object  {

	var description: String {
		#if COOPER
		return self.toString()
		#elseif ECHOES
		return self.ToString()
		#endif
	}

	var debugDescription: String { 
		#if COOPER
		return self.toString()
		#elseif ECHOES
		return self.ToString()
		#endif
	}
}
#endif

#if !NOUGAT // for now
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
	func escape(#asASCII: Bool) -> String { // Method "static UnicodeScalar.escape(asASCII: Bool) -> String" hides a method in parent class with the same name and signature
	}
	func isASCII() -> Bool { // Method "static UnicodeScalar.isASCII() -> Bool" hides a method in parent class with the same name and signature
		return self <= 127
	}
}

extension String {
	
	typealias Index = Int //69954: Silver: can't define type alias inside extension class
	
	var startIndex: /*String.Index*/Int { return 0 }
	
//	var endIndex: /*String.Index*/Int { return self.length() } //69953: Silver: can't call self members w/o "self." prefix in extension class
	
	/*func generate() -> IndexingGenerator<String> {
	}*/
	
	/*var utf8: UTF8View {
	}
	
	var nulTerminatedUTF8: ContiguousArray<CodeUnit> { get }*/
	
	
}
#endif

