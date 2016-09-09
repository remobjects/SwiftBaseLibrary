

public extension UnicodeScalar : Streamable {
	
	public var value: UInt32 { 
		return self as! UInt32 
	}
	
	public func escape(# asASCII: Bool) -> String {
		if asASCII && !isASCII() {
			#if JAVA
			return self.toString()
			#elseif CLR || ISLAND
			return self.ToString()
			#elseif COCOA
			return self.description()
			#endif
		}
		else {
			#if JAVA
			return java.lang.String.format("\\u{%8x}", self as! Int32)
			#elseif CLR || ISLAND
			return /*System.*/String.Format("\\u{{{0:X8}}}", self as! Int32)
			#elseif COCOA
			return Foundation.NSString.stringWithFormat("\\u{%8x}", self as! Int32)
			#endif
		}
	}
	
	public func isASCII() -> Bool {
		return self <= 127
	}
	
	
	private func ToString() -> String? {
		/*#if JAVA
		let chars: Char[] = [self]
		return java.lang.String(chars)
		#elseif COCOA
		return Foundation.NSString.stringWithFormat("%c", self)
		#endif*/
		#hint fix to convert properly from UTF-32 to String
		return self.toHexString(length: 6)
	}
	
	public func writeTo(_ target: OutputStreamType) {
		if let s = ToString() {
			target.write(s)
		}
	}
	
	#if JAVA
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