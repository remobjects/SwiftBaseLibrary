#if COOPER
import java.util
import com.remobjects.elements.linq
#elseif ECHOES
import System.Collections.Generic
import System.Linq
#elseif NOUGAT
import Foundation
import RemObjects.Elements.Linq
#endif

#if NOUGAT
__mapped public class String => NSString {
#elseif COOPER
__mapped public class String => java.lang.String {
#elseif ECHOES
__mapped public class String => System.String {
#endif

	typealias Index = Int
	
	#if !NOUGAT
	typealias AnsiChar = Byte
	#endif

	/// Construct an instance containing just the given `Character`.
	init(_ c: Character) {
	}

	public var startIndex: /*String.Index*/Int { return 0 }
	
	public var endIndex: /*String.Index*/Int { 
		#if ECHOES
		return __mapped.Length-1
		#else
		return __mapped.length()-1 
		#endif
	}
	
	public subscript (i: String.Index) -> Character { // UTF-16, for now
		return __mapped[i]
	}
	
	/// Creates a new `String` by copying the nul-terminated UTF-8 data
	/// referenced by a `CString`.
	///
	/// Returns `nil` if the `CString` is `NULL` or if it contains ill-formed
	/// UTF-8 code unit sequences.
	#if NOUGAT
	static func fromCString(cs: UnsafePointer<CChar>) -> String? {
	}

	/// Creates a new `String` by copying the nul-terminated UTF-8 data
	/// referenced by a `CString`.
	///
	/// Returns `nil` if the `CString` is `NULL`.  If `CString` contains
	/// ill-formed UTF-8 code unit sequences, replaces them with replacement
	/// characters (U+FFFD).
	static func fromCStringRepairingIllFormedUTF8(cs: UnsafePointer<CChar>) -> (String?, hadError: Bool) {
	}
	#endif
	
	var length: Int {
		#if COOPER
		return __mapped.length()
		#elseif ECHOES
		return __mapped.Length
		#elseif NOUGAT
		return __mapped.length
		#endif
	}

	/* Views */

	public var unicodeScalars: String.UnicodeScalarView { 
		//return String.UnicodeScalarView(/*string:*/ self)
	}
	public var utf8: String.UTF8View {
		//return String.UTF8View(string: self)
	}
	public var utf16: String.UTF16View { 
		//return String.UTF16View(string: self)
	}

	public class BaseView /*: ISequence<UnicodeScalar>*/ {
		internal let _string: String
		internal public init(string: String) {
			_string = string;
		}
	}
	
	public class UnicodeScalarView : BaseView /*: ISequence<UnicodeScalar>*/ {

		internal public init(string: String) {
			super.init(string: string)
			#if COOPER
			#elseif ECHOES
			_data = System.Text.UTF32Encoding(/*bigendian:*/false, /*BOM:*/false).GetBytes(string) // todo check order  
			#elseif NOUGAT
			_utf32 = (string as! NSString).dataUsingEncoding(NSStringEncoding.NSUTF16LittleEndianStringEncoding) // todo check order  
			_data = _utf32.bytes as! UnsafePointer<Byte>
			#endif
		}

		#if COOPER
		private let _data: Byte[] //todo
		private var _length: Int { return _data.length/4 }
		#elseif ECHOES
		private let _data: Byte[]
		private var _length: Int { return _data.Length/4 }
		#elseif NOUGAT
		private let _utf32: NSData
		private let _data: UnsafePointer<Byte>
		private var _length: Int { return _utf32.length/4 }
		#endif

		public var startIndex: String.Index { return 0 }
		public var endIndex: String.Index { return _length-1 }

		public subscript (i: String.Index) -> UInt32 {
			return _data[i] | _data[i+1] << 8 | _data[i+2] << 16 | _data[i+3] << 24 // todo: probably wrong order, check
		}
	}
	
	public class UTF8View : BaseView /*: ISequence<UnicodeScalar>*/ {
		
		internal public init(string: String) {
			super.init(string: string)
			#if COOPER
			#elseif ECHOES
			_data = System.Text.UTF8Encoding(/*BOM:*/false).GetBytes(string)
			#elseif NOUGAT
			_data = (string as! NSString).UTF8String
			_length = strlen(_data)
			#endif
		}
		
		#if COOPER
		private let _data: Byte[] //todo
		private var _length: Int { return _data.length }
		#elseif ECHOES
		private let _data: Byte[]
		private var _length: Int { return _data.Length }
		#elseif NOUGAT
		private let _data: UnsafePointer<AnsiChar>
		private let _length: Int
		#endif

		public var startIndex: String.Index { return 0 }
		public var endIndex: String.Index { return _length-1 }

		public subscript (i: String.Index) -> AnsiChar {
			return _data[i]
		}
	}
	public class UTF16View : BaseView /*: ISequence<UnicodeScalar>*/ {

		public var startIndex: String.Index { return _string.startIndex }
		public var endIndex: String.Index { return _string.endIndex }

		public subscript (i: String.Index) -> Character {
			#if COOPER
			return (_string as! java.lang.String)[i]
			#elseif ECHOES
			return (_string as! System.String)[i]
			#elseif NOUGAT
			return (_string as! Foundation.NSString)[i]
			#endif
		}
	}

}
