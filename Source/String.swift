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

	/// Construct an instance containing just the given `Character`.
	init(_ c: Character) {
	}

	public subscript (i: String.Index) -> Character {
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
	

	/* Views */


	public var unicodeScalars: String.UnicodeScalarView { 
	}
	public var utf8: String.UTF8View {
	}
	public var utf16: String.UTF16View { 
	}

	public class BaseView /*: ISequence<UnicodeScalar>*/ {
		private let _string: String
		internal init(string: String) {
			_string = string;
		}
	}
	
	public class UnicodeScalarView : String.BaseView /*: ISequence<UnicodeScalar>*/ {
	}

	public class UTF8View : String.BaseView /*: ISequence<UnicodeScalar>*/ {
	}
	public class UTF16View : String.BaseView /*: ISequence<UnicodeScalar>*/ {
	}
}
