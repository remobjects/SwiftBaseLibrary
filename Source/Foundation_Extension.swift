#if COCOA
import Foundation

@inline(always) func NSLocalizedString(_ key: String, comment: String) -> String {
	return NSBundle.mainBundle.localizedStringForKey(key, value: "", table: nil)
}
#endif