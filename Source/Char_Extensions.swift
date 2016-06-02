

public extension UnicodeScalar : Streamable {
	
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
			return self.description()
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
	
	public func isASCII() -> Bool {
		return self <= 127
	}
	
	#if !ECHOES && !ISLAND
	private func ToString() -> String? {
		#if COOPER
		let chars: Char[] = [self]
		return java.lang.String(chars)
		#elseif NOUGAT
		return Foundation.NSString.stringWithFormat("%c", self)
		#endif
	}
	#endif
	
	public func writeTo(_ target: OutputStreamType) {
		if let s = ToString() {
			target.write(s)
		}
	}
	
	#if COOPER
	//workaround for 75341: Silver: Cooper: adding any interface to a struct via extension requires implementing `equals` and `hashCode`.
	func equals(_ arg1: Object!) -> Boolean {
		if let v = arg1 as? UnicodeScalar {
			return v == self
		}
		return false
	}
	
	func hashCode() -> Integer {
		return value
	}
	#endif
}