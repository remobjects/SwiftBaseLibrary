
public extension SwiftString {

	public __abstract class BaseCharacterView {
		internal init {
		}

		typealias Index = Int

		public var startIndex: SwiftString.Index { return 0 }
		public __abstract var endIndex: SwiftString.Index { get }

		public __abstract var count: Int { get }
		public var isEmpty: Bool { return count > 0 }
	}

	public class CharacterView: BaseCharacterView {
		private let stringData: [Character]

		private init(stringData: [Character]) {
			self.stringData = stringData
		}

		internal init(string: NativeString) {
			stringData = [Character](capacity: length(string))

			#if JAVA
			let it = java.text.BreakIterator.getCharacterInstance();
			it.setText(string);
			var start = it.first()
			var end = it.next()
			while (end != java.text.BreakIterator.DONE) {
				stringData.append(Character(nativeStringValue: string.substring(start, end)))
				start = end
				end = it.next()
			}
			#elseif CLR
			let te = System.Globalization.StringInfo.GetTextElementEnumerator(string)
			te.Reset()
			while te.MoveNext() {
				stringData.append(Character(nativeStringValue: te.Current as! NativeString))
			}
			#elseif COCOA
			var i = 0
			while i < length(string) {

				let sequenceLength = string.rangeOfComposedCharacterSequenceAtIndex(i).length

				//76192: Silver: can't use range as subscript? (SBL)
				let ch: NativeString = string.__substring(range: i ..< i+sequenceLength)
				stringData.append(Character(nativeStringValue: ch))
				i += sequenceLength
			}
			#endif

				/* old logic to detect surrogate pairs; not needed right now
				let c = string[i]
				let c2 = Int(c)
				/*switch Int(c) {
					case 0x000000...0x00D7FF, 0x00E000...0x00FFFF:
						if currenrtSurrogate != nil {
							throw Exception("Invalid surrogate pair at index \(i)")
						}
						currentCharacter = currentCharacter+String(c)
					case 0x00D800...0x00DBFF:
						if currenrtSurrogate != nil {
							throw Exception("Invalid surrogate pair at index \(i)")
						}
						currentSurrogate = c
					case 0x00DC00...0x00DBFF:
						if let currenrtSurrogate = currenrtSurrogate {
							currentCharacter = currentCharacter+String(currentSurrogate)+String(c)
							currentSurrogate = nil
						} else {
							throw Exception("Invalid surrogate pair at index \(i)")
						}
				}*/
				if c2 <= 0x0D7FF || c2 > 0x00E000 {
					//print(NSString.stringWithFormat("char %x", c2))
					if currentSurrogate != "\0"/*nil*/ {
						throw Exception("Invalid surrogate pair at index \(i)")
					}
					currentCharacter = currentCharacter+String(c)
				} else if c2 >= 0x00D800 && c2 <= 0x00DBFF {
					//print(NSString.stringWithFormat("s1 %x", c2))
					if currentSurrogate != "\0"/*nil*/ {
						throw Exception("Invalid surrogate pair at index \(i)")
					}
					currentSurrogate = c
				} else if c2 >= 0x00DC00 && c2 < 0x00DFFF {
					//print(NSString.stringWithFormat("s2 %x", c2))
					if let surrogate = currentSurrogate {
						currentCharacter = currentCharacter+surrogate+c
						currentSurrogate = "\0"/*nil*/
					} else {
						throw Exception("Invalid surrogate pair at index \(i)")
					}
				}
				addCharacter()

				i += 1
			}*/
			//addCharacter()
		}

		public override var count: Int { return stringData.count }

		public override var endIndex: SwiftString.Index { return stringData.count }

		#if !COOPER
		var first: Character? { return count > 0 ? self[0] : nil }
		#endif

		func `prefix`(through: Index) -> CharacterView {
			return CharacterView(stringData: stringData[0...through])
		}

		func `prefix`(upTo: Index) -> CharacterView {
			return CharacterView(stringData: stringData[0..<upTo])
		}

		func suffix(from: Index) -> CharacterView {
			return CharacterView(stringData: stringData[from..<stringData.count])
		}

		public subscript(range: Range) -> CharacterView {
			return CharacterView(stringData: stringData[range])
		}

		public subscript(index: Int) -> Character {
			return stringData[index]
		}

		@ToString public func description() -> NativeString {
			var result = "UTF32CharacterView("
			for i in startIndex..<endIndex {
				if i > startIndex {
					result += " "
				}
				result += self[i].toHexString()
			}
			result += ")"
			return result
		}
	}

	public class UTF16View: BaseCharacterView {
		private let stringData: NativeString

		internal init(string: NativeString) {
			self.stringData = string
		}

		public override var count: Int { return length(stringData) }

		public override var endIndex: SwiftString.Index { return length(stringData) }

		// 76085: Silver: `Char` becomes String when using with `?:` operator
		var first: UTF16Char? { return count > 0 ? self[0] : nil as? UTF16Char }

		func `prefix`(through: Index) -> UTF16View {
			return UTF16View(string: stringData.__substring(range: 0...through))
		}

		func `prefix`(upTo: Index) -> UTF16View {
			return UTF16View(string: stringData.__substring(range: 0..<upTo))
		}

		func suffix(from: Index) -> UTF16View {
			return UTF16View(string: stringData.__substring(range: from..<stringData.length()))
		}

		public subscript(range: Range) -> UTF16View {
			return UTF16View(string: stringData.__substring(range: range))
		}

		public subscript(index: Int) -> UTF16Char {
			return stringData[index]
		}

		@ToString public func description() -> NativeString {
			var result = "UTF16CharacterView("
			for i in startIndex..<endIndex {
				if i > startIndex {
					result += " "
				}
				result += UInt16(self[i]).toHexString(length: 4)
			}
			result += ")"
			return result
		}
	}

	#if !ISLAND
	public typealias UnicodeScalarView = UTF32View

	public class UTF32View: BaseCharacterView/*, ISequence<UTF32Char>*/ {
		private let stringData: Byte[]

		private init(stringData: Byte[]) {
			self.stringData = stringData
		}

		internal init(string: NativeString) {
			#if JAVA
			stringData = string.getBytes("UTF-32LE")
			#elseif CLR
			stringData = System.Text.UTF32Encoding(/*bigendian:*/false, /*BOM:*/false).GetBytes(string) // todo check order
			#elseif ISLAND
			stringData = Encoding.UTF32LE.GetBytes(aValue, /*BOM:*/false) // todo check order
			#elseif COCOA
			if let utf32 = string.dataUsingEncoding(.NSUTF32LittleEndianStringEncoding) { // todo check order
				stringData = Byte[](capacity: utf32.length);
				utf32.getBytes(stringData, length: utf32.length);
			} else {
				fatalError("Encoding of SwiftString to UTF32 failed.")
			}
			#endif
		}

		public override var count: Int { return length(stringData) }

		public override var endIndex: SwiftString.Index { return RemObjects.Elements.System.length(stringData)/4 }

		var first: UTF32Char? { return count > 0 ? self[0] : nil }

		/*func `prefix`(through: Index) -> UTF32View {
			return UTF32View(stringData: stringData[0...through])
		}

		func `prefix`(upTo: Index) -> UTF32View {
			return UTF32View(stringData: stringData[0..<upTo])
		}

		func suffix(from: Index) -> UTF32View {
			return UTF32View(stringData: stringData[from..<stringData.count])
		}

		public subscript(range: Range) -> UTF32View {
			return UTF32View(stringData: stringData[range])
		}*/

		public subscript(index: Int) -> UTF32Char {
			return stringData[index*4] + stringData[index*4+1]<<8 + stringData[index*4+2]<<16 + stringData[index*4+3]<<24 // todo: check if order is correct
		}

		@Sequence
		public func GetSequence() -> ISequence<UTF32Char> {
			for i in startIndex ..< endIndex {
				__yield self[i]
			}
		}

		@ToString public func description() -> NativeString {
			var result = "UTF32CharacterView("
			for i in startIndex..<endIndex {
				if i > startIndex {
					result += " "
				}
				result += UInt32(self[i]).toHexString(length: 8)
			}
			result += ")"
			return result
		}
	}
	#endif

	#if !ISLAND
	public class UTF8View: BaseCharacterView {
		internal let stringData: UTF8Char[]

		private init(stringData: UTF8Char[]) {
			self.stringData = stringData
		}

		internal init(string: NativeString) {
			#if JAVA
			stringData = string.getBytes("UTF-8");
			#elseif CLR
			stringData = System.Text.UTF8Encoding(/*BOM:*/false).GetBytes(string)
			#elseif ISLAND
			stringData = Encoding.UTF8.GetBytes(aValue, /*BOM:*/false)
			#elseif COCOA
			if let utf8 = string.dataUsingEncoding(.NSUTF8StringEncoding) {
				stringData = UTF8Char[](capacity: utf8.length);
				utf8.getBytes(stringData, length: utf8.length);
			} else {
				fatalError("Encoding of String to UTF8 failed.")
			}
			#endif
		}

		public override var count: Int { return length(stringData) }

		public override var endIndex: SwiftString.Index { return RemObjects.Elements.System.length(stringData) }

		var first: UTF8Char? { return count > 0 ? self[0] : nil }

		/*func `prefix`(through: Index) -> UTF8View {
			return UTF8View(stringData: stringData[0...through])
		}

		func `prefix`(upTo: Index) -> UTF8View {
			return UTF8View(stringData: stringData[0..<upTo])
		}

		func suffix(from: Index) -> UTF8View {
			return UTF8View(stringData: stringData[from..<stringData.count])
		}

		public subscript(range: Range) -> UTF8View {
			return UTF8View(stringData: stringData[range])
		}*/

		public subscript(index: Int) -> UTF8Char {
			return stringData[index]
		}

		@ToString public func description() -> NativeString {
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