
#if COCOA
/*@unsafe_no_objc_tagged_pointer*/ public protocol _CocoaArrayType {
	func objectAtIndex(index: Int) -> AnyObject
	//func getObjects(_: UnsafeMutablePointer<AnyObject>, range: _SwiftNSRange)
	//func countByEnumeratingWithState(state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>, objects buffer: UnsafeMutablePointer<AnyObject>, count len: Int) -> Int
	//func copyWithZone(_: OpaquePointer) -> _CocoaArrayType
	var count: Int { get }
}
#endif

public typealias CustomStringConvertible = ICustomStringConvertible
public protocol ICustomStringConvertible {
	var description: NativeString! { get } // unwrapped nullable for better Cocoa compatibility
}

public typealias CustomDebugStringConvertible = ICustomDebugStringConvertible
public protocol ICustomDebugStringConvertible {
	var debugDescription: NativeString! { get } // unwrapped nullable for better Cocoa compatibility
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

typealias Identifiable = IIdentifiable
protocol IIdentifiable {
	associatedtype ID: IHashable
	var id: ID { get }
}

public typealias OutputStreamType = IOutputStreamType
public protocol IOutputStreamType {
	//mutating func write(_ string: String)
}

public typealias Streamable = IStreamable
public protocol IStreamable {
	//func writeTo<Target: OutputStreamType>(inout _ target: OutputStreamType)
	func writeTo(_ target: OutputStreamType) // deliberately different that Apple's SBL due to limitations on Island
}

public typealias TextOutputStream = ITextOutputStream
public protocol ITextOutputStream {
	mutating func write(_ string: String)
}

public typealias TextOutputStreamable = ITextOutputStreamable
public protocol ITextOutputStreamable {
	//func write<Target>(to target: inout Target) where Target : TextOutputStream
	func write(to target: inout TextOutputStream)
}

public typealias StringProtocol = IStringProtocol
public protocol IStringProtocol : ITextOutputStream {
}

//
// Collections, Sequences and the like
//

/*public protocol GeneratorType {
	typealias Element
	mutating func next() -> Element?
}*/

public typealias Actor = IActor
protocol IActor : AnyObject, Sendable {
}

public typealias Sendable = ISendable
protocol ISendable {
}