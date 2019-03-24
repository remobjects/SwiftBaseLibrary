#if COCOA
import CoreFoundation
#endif

public extension SwiftString {

	public struct Encoding {
		//76080: Island: error jusing "lazy"
		public static /*lazy*/ let ascii: SwiftString.Encoding = Encoding(name: "ASCII")
		//public static /*lazy*/ let iso2022JP: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let isoLatin1: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let isoLatin2: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let japaneseEUC: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let macOSRoman: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let nextstep: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let nonLossyASCII: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let shiftJIS: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let symbol: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let unicode: SwiftString.Encoding = Encoding()
		public static /*lazy*/ let utf16: SwiftString.Encoding = Encoding(name: "UTF-16")
		public static /*lazy*/ let utf16BigEndian: SwiftString.Encoding = Encoding(name: "UTF-16BE")
		public static /*lazy*/ let utf16LittleEndian: SwiftString.Encoding = Encoding(name: "UTF-16LE")
		public static /*lazy*/ let utf32: SwiftString.Encoding = Encoding(name: "UTF-32")
		public static /*lazy*/ let utf32BigEndian: SwiftString.Encoding = Encoding(name: "UTF-32BE")
		public static /*lazy*/ let utf32LittleEndian: SwiftString.Encoding = Encoding(name: "UTF-32LE")
		public static /*lazy*/ let utf8: SwiftString.Encoding = Encoding(name: "UTF-8")
		//public static /*lazy*/ let windowsCP1250: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let windowsCP1251: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let windowsCP1252: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let windowsCP1253: SwiftString.Encoding = Encoding()
		//public static /*lazy*/ let windowsCP1254: SwiftString.Encoding = Encoding()

		init(rawValue: NativeEncoding) {
			self.rawValue = rawValue
		}

		convenience init(name: String) {
			init(rawValue: getNativeEncoding(name: name))
		}

		static func getNativeEncoding(name: String) -> NativeEncoding {
			#if JAVA
			return java.nio.charset.Charset.forName(name)
			#elseif CLR
			return System.Text.Encoding.GetEncoding(name)
			#elseif ISLAND
			switch name.uppercased() {
				case "UTF8","UTF-8": return RemObjects.Elements.System.Encoding.UTF8
				case "UTF16","UTF-16": return RemObjects.Elements.System.Encoding.UTF16
				case "UTF32","UTF-32": return RemObjects.Elements.System.Encoding.UTF32
				case "UTF16LE","UTF-16LE": return RemObjects.Elements.System.Encoding.UTF16LE
				case "UTF16BE","UTF-16BE": return RemObjects.Elements.System.Encoding.UTF16BE
				case "UTF32LE","UTF-32LE": return RemObjects.Elements.System.Encoding.UTF32LE
				case "UTF32BE","UTF-32BE": return RemObjects.Elements.System.Encoding.UTF32BE
				//case "US-ASCII", "ASCII","UTF-ASCII": return RemObjects.Elements.System.Encoding.ASCII
				default: throw Exception("Invalid Encoding '\(name)'")
			}
			#elseif COCOA
			switch name.uppercased() {
				case "UTF8","UTF-8": return NSStringEncoding.UTF8StringEncoding
				case "UTF16","UTF-16": return NSStringEncoding.UTF16StringEncoding
				case "UTF32","UTF-32": return NSStringEncoding.UTF32StringEncoding
				case "UTF16LE","UTF-16LE": return NSStringEncoding.UTF16LittleEndianStringEncoding
				case "UTF16BE","UTF-16BE": return NSStringEncoding.UTF16BigEndianStringEncoding
				case "UTF32LE","UTF-32LE": return NSStringEncoding.UTF32LittleEndianStringEncoding
				case "UTF32BE","UTF-32BE": return NSStringEncoding.UTF32BigEndianStringEncoding
				case "US-ASCII", "ASCII","UTF-ASCII": return NSStringEncoding.ASCIIStringEncoding
				default:
					let encoding = CFStringConvertIANACharSetNameToEncoding(bridge<CFStringRef>(name))
					if encoding != kCFStringEncodingInvalidId {
						return CFStringConvertEncodingToNSStringEncoding(encoding) as! NSStringEncoding
					}
					throw Exception("Invalid Encoding '\(name)'")
			}
			#endif
		}

		let rawValue: NativeEncoding

		#if JAVA
		typealias NativeEncoding = java.nio.charset.Charset
		#elseif CLR
		typealias NativeEncoding = System.Text.Encoding
		#elseif ISLAND
		typealias NativeEncoding = RemObjects.Elements.System.Encoding
		#elseif COCOA
		typealias NativeEncoding = Foundation.NSStringEncoding
		#endif
	}


}