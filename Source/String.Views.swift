
public extension SwiftString {

	public __abstract class BaseCharacterView {
		internal init(string: NativeString) {
		}

		public var startIndex: SwiftString.Index { return 0 }
		public __abstract var endIndex: SwiftString.Index { get }
		
	}
	
	public typealias CharacterView = UTF16View // for now
	#if !ISLAND
	public typealias UnicodeScalarView = UTF32View // for now
	#endif
	
	public class UTF16View: BaseCharacterView {
		private let stringData: NativeString
		
		internal init(string: NativeString) {
			self.stringData = string
		}
		
		public override var endIndex: SwiftString.Index { return length(stringData) }

		public subscript(index: Int) -> UTF16Char {
			return stringData[index]
		}

		@ToString public func description() -> String {
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
	
	#if !ISLAND
	public class UTF32View: BaseCharacterView {
		private let stringData: Byte[]

		internal init(string: NativeString) {
			#if JAVA
			stringData = []
			fatalError("UTF32CharacterView is not implemenyted for Java yet.")
			#elseif CLR
			stringData = System.Text.UTF32Encoding(/*bigendian:*/false, /*BOM:*/false).GetBytes(string) // todo check order  
			#elseif ISLAND
			throw Exception("UTF32View is not supported on Island yet.")
			#elseif COCOA
			if let utf32 = string.dataUsingEncoding(.NSUTF16LittleEndianStringEncoding) { // todo check order  
				stringData = Byte[](capacity: utf32.length);
				utf32.getBytes(stringData, length: utf32.length);
			} else {
				stringData = []
				fatalError("Encoding of SwiftString to UTF32 failed.")
			}
			#endif
		}
		
		public override var endIndex: SwiftString.Index { return RemObjects.Elements.System.length(stringData)/4 }

		public subscript(index: Int) -> UTF32Char {
			return stringData[index*4] + stringData[index*4+1]<<8 + stringData[index*4+2]<<16 + stringData[index*4+3]<<24 // todo: check if order is correct
		}

		@ToString public func description() -> String {
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
	#endif
	
	#if !ISLAND
	public class UTF8View: BaseCharacterView {
		internal let stringData: UTF8Char[]
		
		internal init(string: NativeString) {
			#if JAVA
			stringData = []
			fatalError("UTF8CharacterView is not implemenyted for Java yet.")
			#elseif CLR
			stringData = System.Text.UTF8Encoding(/*BOM:*/false).GetBytes(string) // todo check order  
			#elseif ISLAND
			throw Exception("UTF8View is not supported on Island yet.")
			#elseif COCOA
			if let utf8 = string.dataUsingEncoding(.NSUTF8StringEncoding) { // todo check order  
				stringData = UTF8Char[](capacity: utf8.length);
				utf8.getBytes(stringData, length: utf8.length);
			} else {
				stringData = []
				fatalError("Encoding of String to UTF8 failed.")
			}
			#endif
		}
		
		public override var endIndex: SwiftString.Index { return RemObjects.Elements.System.length(stringData) }

		public subscript(index: Int) -> UTF8Char {
			return stringData[index]
		}

		@ToString public func description() -> String {
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
	#endif
	
}
