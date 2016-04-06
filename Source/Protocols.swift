
#if NOUGAT
/*@unsafe_no_objc_tagged_pointer*/ public protocol _CocoaArrayType {
	func objectAtIndex(index: Int) -> AnyObject
	//func getObjects(_: UnsafeMutablePointer<AnyObject>, range: _SwiftNSRange)
	//func countByEnumeratingWithState(state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>, objects buffer: UnsafeMutablePointer<AnyObject>, count len: Int) -> Int
	//func copyWithZone(_: COpaquePointer) -> _CocoaArrayType
	var count: Int { get }
}
#endif

public typealias CustomStringConvertible = ICustomStringConvertible
public protocol ICustomStringConvertible {
	var description: String! { get } // unwrapped nullable for better Nougat compatibility
}

public typealias CustomDebugStringConvertible = ICustomDebugStringConvertible
public protocol ICustomDebugStringConvertible {
	#if NOUGAT
	var debugDescription: String! { get }
	#else
	var debugDescription: String { get }
	#endif
}

public typealias RawRepresentable = IRawRepresentable
public protocol IRawRepresentable {
	associatedtype RawValue
	init/*?*/(rawValue rawValue: Self.RawValue)
	var rawValue: Self.RawValue { get }
}

public typealias ErrorType = IErrorType
public protocol IErrorType {
}

public typealias Hashable = IHashable
public protocol IHashable /*: Equatable*/ {
	var hashValue: Int { get }
}

public typealias OutputStreamType = IOutputStreamType
public protocol IOutputStreamType {
	mutating func write(_ string: String)
}

public typealias Streamable = IStreamable
public protocol IStreamable {
	func writeTo<Target: OutputStreamType>(inout _ target: Target)
}

//
// Collections, Sequences and the like
//

/*public protocol GeneratorType {
	typealias Element
	mutating func next() -> Element?
}*/

