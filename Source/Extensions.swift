
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

#if NOUGAT // for now
/*extension UInt8 {
	static let max: UInt8 = 0xff
	static let min: UInt8 = 0
	static let allZeros: UInt8 = 0
}

extension UInt16 {
	static let max: UInt16 = 0xffff
	static let min: UInt16 = 0
	static let allZeros: UInt8 = 0
}

extension UInt32 {
	//static let max: UInt32 = 0xffff_ffff //69949: Silver: can't assign 0xffff_ffff to UInt32?
	static let min: UInt32 = 0
	static let allZeros: UInt8 = 0
}

extension UInt64 {
	//static let max: UInt64 = 0xffff_ffff_ffff_ffff //69949: Silver: can't assign 0xffff_ffff to UInt32?
	static let min: UInt64 = 0
	static let allZeros: UInt8 = 0
}

//69950: Compiler checks bounds for positive int consts,but not for negative?
extension Int8 {
	static let max: Int8 = 0x7f
	static let min: Int8 = -0x80
	static let allZeros: UInt8 = 0
}

extension Int16 {
	static let max: Int16 = 0x7fff
	static let min: Int16 = -0x8000
	static let allZeros: UInt8 = 0
}

extension Int32 {
	static let max: Int32 = 0x7fff_ffff
	static let min: Int32 = -0x8000_0000
	static let allZeros: UInt8 = 0
}

extension Int64 {
	static let max: Int64 = 0x7fff_ffff_ffff_ffff 
	static let min: Int64 = -0x8000_0000_0000_0000
	static let allZeros: UInt8 = 0
}

extension UnicodeScalar {
	func escape(#asASCII: Bool) -> String {
	}
	func isASCII() -> Bool {
		return self <= 127
	}
}*/

extension String {
	
	typealias Index = Int //69954: Silver: can't define type alias inside extension class
	
	var startIndex: /*String.Index*/Int { return 0 }
	
	var endIndex: /*String.Index*/Int { return self.length } //69953: Silver: can't call self members w/o "self." prefix in extension class
	
	/*func generate() -> IndexingGenerator<String> {
	}*/
	
	/*var utf8: UTF8View {
	}
	
	var nulTerminatedUTF8: ContiguousArray<CodeUnit> { get }*/
	
	
}
#endif

