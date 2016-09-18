public struct Character {

	internal let nativeStringValue: NativeString
	
	@ToString public func ToString() -> NativeString {
		return nativeStringValue
	}
	
	internal func toHexString() -> NativeString {
		if length(nativeStringValue) == 1 {
			return UInt32(nativeStringValue[0]).toHexString(length: 4)
		} else if length(nativeStringValue) > 1 {
			var result = ""
			var currentSurrogate: Char = "\0"
			for i in 0 ..< length(nativeStringValue) {

				let c = nativeStringValue[i]
				let c2 = UInt32(c)
				var newChar: NativeString? = nil
				if c2 <= 0x0D7FF || c2 > 0x00E000 {
					if currentSurrogate != "\0" {
						throw Exception("Invalid surrogate pair at index \(i)")
					}
					newChar = UInt32(nativeStringValue[i]).toHexString(length: 4)
				} else if c2 >= 0x00D800 && c2 <= 0x00DBFF {
					if currentSurrogate != "\0" {
						throw Exception("Invalid surrogate pair at index \(i)")
					}
					currentSurrogate = c
				} else if c2 >= 0x00DC00 && c2 < 0x00DFFF {
					if let surrogate = currentSurrogate {
						var code = 0x10000;
						code += (surrogate & 0x03FF) << 10;
						code += (c & 0x03FF);
						newChar = UInt32(code).toHexString(length: 6)
						currentSurrogate = "\0"
					} else {
						throw Exception("Invalid surrogate pair at index \(i)")
					}
				}

				if let newChar = newChar {
					if length(result) > 0 {
						result += "-"
					}
					result += newChar
				}
			}
			return result
		} else {
			return "0"
		}
	}
	
}
