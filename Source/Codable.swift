/// Conformance to `Encodable` indicates that a type can encode itself to an external representation.
public protocol Encodable {
    /// Encodes `self` into the given encoder.
    ///
    /// If `self` fails to encode anything, `encoder` will encode an empty keyed container in its place.
    ///
    /// - parameter encoder: The encoder to write data to.
    /// - throws: An error if any values are invalid for `encoder`'s format.
    func encode(to encoder: Encoder) throws
}

/// Conformance to `Decodable` indicates that a type can decode itself from an external representation.
public protocol Decodable {
    /// Initializes `self` by decoding from `decoder`.
    ///
    /// - parameter decoder: The decoder to read data from.
    /// - throws: An error if reading from the decoder fails, or if read data is corrupted or otherwise invalid.
    init(from decoder: Decoder) throws
}

/// Conformance to `Codable` indicates that a type can convert itself into and out of an external representation.
//78131: Swift 3: support for combining protocols via &
//public typealias Codable = Encodable & Decodable

/// Conformance to `CodingKey` indicates that a type can be used as a key for encoding and decoding.
public protocol CodingKey {
    /// The string to use in a named collection (e.g. a string-keyed dictionary).
    var stringValue: String { get }

    /// Initializes `self` from a string.
    ///
    /// - parameter stringValue: The string value of the desired key.
    /// - returns: An instance of `Self` from the given string, or `nil` if the given string does not correspond to any instance of `Self`.
//    init?(stringValue: String)

    /// The int to use in an indexed collection (e.g. an int-keyed dictionary).
    var intValue: Int? { get }

    /// Initializes `self` from an integer.
    ///
    /// - parameter intValue: The integer value of the desired key.
    /// - returns: An instance of `Self` from the given integer, or `nil` if the given integer does not correspond to any instance of `Self`.
//    init?(intValue: Int)
}

/// An `Encoder` is a type which can encode values into a native format for external representation.
public protocol Encoder {
    /// Returns an encoding container appropriate for holding multiple values keyed by the given key type.
    ///
    /// - parameter type: The key type to use for the container.
    /// - returns: A new keyed encoding container.
    /// - precondition: May not be called after a prior `self.unkeyedContainer()` call.
    /// - precondition: May not be called after a value has been encoded through a previous `self.singleValueContainer()` call.
//    func container<Key : CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>

    /// Returns an encoding container appropriate for holding multiple unkeyed values.
    ///
    /// - returns: A new empty unkeyed container.
    /// - precondition: May not be called after a prior `self.container(keyedBy:)` call.
    /// - precondition: May not be called after a value has been encoded through a previous `self.singleValueContainer()` call.
    func unkeyedContainer() -> UnkeyedEncodingContainer

    /// Returns an encoding container appropriate for holding a single primitive value.
    ///
    /// - returns: A new empty single value container.
    /// - precondition: May not be called after a prior `self.container(keyedBy:)` call.
    /// - precondition: May not be called after a prior `self.unkeyedContainer()` call.
    /// - precondition: May not be called after a value has been encoded through a previous `self.singleValueContainer()` call.
    func singleValueContainer() -> SingleValueEncodingContainer

    /// The path of coding keys taken to get to this point in encoding.
    /// A `nil` value indicates an unkeyed container.
    var codingPath: [CodingKey?] { get }
}

/// A `Decoder` is a type which can decode values from a native format into in-memory representations.
public protocol Decoder {
    /// Returns the data stored in `self` as represented in a container keyed by the given key type.
    ///
    /// - parameter type: The key type to use for the container.
    /// - returns: A keyed decoding container view into `self`.
    /// - throws: `CocoaError.coderTypeMismatch` if the encountered stored value is not a keyed container.
//    func container<Key : CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key>

    /// Returns the data stored in `self` as represented in a container appropriate for holding values with no keys.
    ///
    /// - returns: An unkeyed container view into `self`.
    /// - throws: `CocoaError.coderTypeMismatch` if the encountered stored value is not an unkeyed container.
    func unkeyedContainer() throws -> UnkeyedDecodingContainer

    /// Returns the data stored in `self` as represented in a container appropriate for holding a single primitive value.
    ///
    /// - returns: A single value container view into `self`.
    /// - throws: `CocoaError.coderTypeMismatch` if the encountered stored value is not a single value container.
    func singleValueContainer() throws -> SingleValueDecodingContainer

    /// The path of coding keys taken to get to this point in decoding.
    /// A `nil` value indicates an unkeyed container.
    var codingPath: [CodingKey?] { get }
}

/// Conformance to `KeyedEncodingContainerProtocol` indicates that a type provides a view into an `Encoder`'s storage and is used to hold the encoded properties of an `Encodable` type in a keyed manner.
///
/// Encoders should provide types conforming to `KeyedEncodingContainerProtocol` for their format.
public protocol KeyedEncodingContainerProtocol {
    associatedtype Key : CodingKey

    /// Encodes the given value for the given key.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `CocoaError.coderInvalidValue` if the given value is invalid in the current context for this format.
    mutating func encode<T : Encodable>(_ value: T?, forKey key: Key) throws

    /// Encodes the given value for the given key.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `CocoaError.coderInvalidValue` if the given value is invalid in the current context for this format.
    mutating func encode(_ value: Bool?,   forKey key: Key) throws
    //mutating func encode(_ value: Int?,    forKey key: Key) throws
    mutating func encode(_ value: Int8?,   forKey key: Key) throws
    mutating func encode(_ value: Int16?,  forKey key: Key) throws
    mutating func encode(_ value: Int32?,  forKey key: Key) throws
    mutating func encode(_ value: Int64?,  forKey key: Key) throws
    //mutating func encode(_ value: UInt?,   forKey key: Key) throws
    mutating func encode(_ value: UInt8?,  forKey key: Key) throws
    mutating func encode(_ value: UInt16?, forKey key: Key) throws
    mutating func encode(_ value: UInt32?, forKey key: Key) throws
    mutating func encode(_ value: UInt64?, forKey key: Key) throws
    mutating func encode(_ value: Float?,  forKey key: Key) throws
    mutating func encode(_ value: Double?, forKey key: Key) throws
    mutating func encode(_ value: String?, forKey key: Key) throws

    /// Encodes the given object weakly for the given key.
    ///
    /// For `Encoder`s that implement this functionality, this will only encode the given object and associate it with the given key if it is encoded unconditionally elsewhere in the payload (either previously or in the future).
    ///
    /// For formats which don't support this feature, the default implementation encodes the given object unconditionally.
    ///
    /// - parameter object: The object to encode.
    /// - parameter key: The key to associate the object with.
    /// - throws: `CocoaError.coderInvalidValue` if the given value is invalid in the current context for this format.
    mutating func encodeWeak<T : /*AnyObject &*/ Encodable>(_ object: T?, forKey key: Key) throws

    /// The path of coding keys taken to get to this point in encoding.
    /// A `nil` value indicates an unkeyed container.
    var codingPath: [CodingKey?] { get }
}

/// `KeyedEncodingContainer` is a type-erased box for `KeyedEncodingContainerProtocol` types, similar to `AnyCollection` and `AnyHashable`. This is the type which consumers of the API interact with directly.
/*public struct KeyedEncodingContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
    associatedtype Key = K

    /// Initializes `self` with the given container.
    ///
    /// - parameter container: The container to hold.
    init<Container : KeyedEncodingContainerProtocol>(_ container: Container) where Container.Key == Key

    // + methods from KeyedEncodingContainerProtocol
}*/

/// Conformance to `KeyedDecodingContainerProtocol` indicates that a type provides a view into a `Decoder`'s storage and is used to hold the encoded properties of a `Decodable` type in a keyed manner.
///
/// Decoders should provide types conforming to `KeyedDecodingContainerProtocol` for their format.
public protocol KeyedDecodingContainerProtocol {
    associatedtype Key : CodingKey

    /// All the keys the `Decoder` has for this container.
    ///
    /// Different keyed containers from the same `Decoder` may return different keys here; it is possible to encode with multiple key types which are not convertible to one another. This should report all keys present which are convertible to the requested type.8?
/*    var allKeys: [Key] { get }

    /// Returns whether the `Decoder` contains a value associated with the given key.
    ///
    /// The value associated with the given key may be a null value as appropriate for the data format.
    ///
    /// - parameter key: The key to search for.
    /// - returns: Whether the `Decoder` has an entry for the given key.
    func contains(_ key: Key) -> Bool

    /// Decodes a value of the given type for the given key.
    ///
    /// A default implementation is given for these types which calls into the `decodeIfPresent` implementations below.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `CocoaError.coderTypeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `CocoaError.coderValueNotFound` if `self` does not have an entry for the given key or if the value is null.
    func decode(_ type: Bool.Type,   forKey key: Key) throws -> Bool
    func decode(_ type: Int.Type,    forKey key: Key) throws -> Int
    func decode(_ type: Int8.Type,   forKey key: Key) throws -> Int8
    func decode(_ type: Int16.Type,  forKey key: Key) throws -> Int16
    func decode(_ type: Int32.Type,  forKey key: Key) throws -> Int32
    func decode(_ type: Int64.Type,  forKey key: Key) throws -> Int64
    func decode(_ type: UInt.Type,   forKey key: Key) throws -> UInt
    func decode(_ type: UInt8.Type,  forKey key: Key) throws -> UInt8
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64
    func decode(_ type: Float.Type,  forKey key: Key) throws -> Float
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double
    func decode(_ type: String.Type, forKey key: Key) throws -> String
    func decode<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T

    /// Decodes a value of the given type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value associated with `key`, or if the value is null. The difference between these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter type: The type of value to decode.
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or `nil` if the `Decoder` does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `CocoaError.coderTypeMismatch` if the encountered encoded value is not convertible to the requested type.
    func decodeIfPresent(_ type: Bool.Type,   forKey key: Key) throws -> Bool?
    func decodeIfPresent(_ type: Int.Type,    forKey key: Key) throws -> Int?
    func decodeIfPresent(_ type: Int8.Type,   forKey key: Key) throws -> Int8?
    func decodeIfPresent(_ type: Int16.Type,  forKey key: Key) throws -> Int16?
    func decodeIfPresent(_ type: Int32.Type,  forKey key: Key) throws -> Int32?
    func decodeIfPresent(_ type: Int64.Type,  forKey key: Key) throws -> Int64?
    func decodeIfPresent(_ type: UInt.Type,   forKey key: Key) throws -> UInt?
    func decodeIfPresent(_ type: UInt8.Type,  forKey key: Key) throws -> UInt8?
    func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16?
    func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32?
    func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64?
    func decodeIfPresent(_ type: Float.Type,  forKey key: Key) throws -> Float?
    func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double?
    func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String?
    func decodeIfPresent<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T?

    /// The path of coding keys taken to get to this point in decoding.
    /// A `nil` value indicates an unkeyed container.
    var codingPath: [CodingKey?] { get }*/
}

/// `KeyedDecodingContainer` is a type-erased box for `KeyedDecodingContainerProtocol` types, similar to `AnyCollection` and `AnyHashable`. This is the type which consumers of the API interact with directly.
/*public struct KeyedDecodingContainer<K : CodingKey> : KeyedDecodingContainerProtocol {
    associatedtype Key = K

    /// Initializes `self` with the given container.
    ///
    /// - parameter container: The container to hold.
    init<Container : KeyedDecodingContainerProtocol>(_ container: Container) where Container.Key == Key

    // + methods from KeyedDecodingContainerProtocol
}*/

public protocol UnkeyedEncodingContainer {
    /// Encodes the given value.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `CocoaError.coderInvalidValue` if the given value is invalid in the current context for this format.
    mutating func encode<T : Encodable>(_ value: T?) throws

    /// Encodes the given value.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `CocoaError.coderInvalidValue` if the given value is invalid in the current context for this format.
    mutating func encode(_ value: Bool?) throws
    //mutating func encode(_ value: Int?) throws
    mutating func encode(_ value: Int8?) throws
    mutating func encode(_ value: Int16?) throws
    mutating func encode(_ value: Int32?) throws
    mutating func encode(_ value: Int64?) throws
    //mutating func encode(_ value: UInt?) throws
    mutating func encode(_ value: UInt8?) throws
    mutating func encode(_ value: UInt16?) throws
    mutating func encode(_ value: UInt32?) throws
    mutating func encode(_ value: UInt64?) throws
    mutating func encode(_ value: Float?) throws
    mutating func encode(_ value: Double?) throws
    mutating func encode(_ value: String?) throws

    /// Encodes the given object weakly.
    ///
    /// For `Encoder`s that implement this functionality, this will only encode the given object if it is encoded unconditionally elsewhere in the payload (either previously or in the future).
    ///
    /// For formats which don't support this feature, the default implementation encodes the given object unconditionally.
    ///
    /// - parameter object: The object to encode.
    /// - throws: `CocoaError.coderInvalidValue` if the given value is invalid in the current context for this format.
    mutating func encodeWeak<T : /*AnyObject &*/ Encodable>(_ object: T?) throws

    /// Encodes the elements of the given sequence.
    ///
    /// A default implementation of these is given in an extension.
    ///
    /// - parameter sequence: The sequences whose contents to encode.
    /// - throws: An error if any of the contained values throws an error.
    //mutating func encode<Sequence : Swift.Sequence>(contentsOf sequence: Sequence) throws where Sequence.Iterator.Element == Bool
    //mutating func encode<Sequence : Swift.Sequence>(contentsOf sequence: Sequence) throws where Sequence.Iterator.Element == Int
    // ...
    //mutating func encode<Sequence : Swift.Sequence>(contentsOf sequence: Sequence) throws where Sequence.Iterator.Element : Encodable

    /// The path of coding keys taken to get to this point in encoding.
    /// A `nil` value indicates an unkeyed container.
    var codingPath: [CodingKey?] { get }
}

/// Conformance to `UnkeyedDecodingContainer` indicates that a type provides a view into a `Decoder`'s storage and is used to hold the encoded properties of a `Decodable` type sequentially, without keys.
///
/// Decoders should provide types conforming to `UnkeyedDecodingContainer` for their format.
public protocol UnkeyedDecodingContainer {
    /// Returns the number of elements (if known) contained within this container.
    var count: Int? { get }

    /// Returns whether there are no more elements left to be decoded in the container.
    var isAtEnd: Bool { get }

    /// Decodes a value of the given type.
    ///
    /// A default implementation is given for these types which calls into the `decodeIfPresent` implementations below.
    ///
    /// - parameter type: The type of value to decode.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `CocoaError.coderTypeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `CocoaError.coderValueNotFound` if the encountered encoded value is null, or of there are no more values to decode.
/*    mutating func decode(_ type: Bool.Type) throws -> Bool
    mutating func decode(_ type: Int.Type) throws -> Int
    mutating func decode(_ type: Int8.Type) throws -> Int8
    mutating func decode(_ type: Int16.Type) throws -> Int16
    mutating func decode(_ type: Int32.Type) throws -> Int32
    mutating func decode(_ type: Int64.Type) throws -> Int64
    mutating func decode(_ type: UInt.Type) throws -> UInt
    mutating func decode(_ type: UInt8.Type) throws -> UInt8
    mutating func decode(_ type: UInt16.Type) throws -> UInt16
    mutating func decode(_ type: UInt32.Type) throws -> UInt32
    mutating func decode(_ type: UInt64.Type) throws -> UInt64
    mutating func decode(_ type: Float.Type) throws -> Float
    mutating func decode(_ type: Double.Type) throws -> Double
    mutating func decode(_ type: String.Type) throws -> String
    mutating func decode<T : Decodable>(_ type: T.Type) throws -> T*/

    /// Decodes a value of the given type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to decode, or if the value is null. The difference between these states can be distinguished by checking `isAtEnd`.
    ///
    /// - parameter type: The type of value to decode.
    /// - returns: A decoded value of the requested type, or `nil` if the value is a null value, or if there are no more elements to decode.
    /// - throws: `CocoaError.coderTypeMismatch` if the encountered encoded value is not convertible to the requested type.
/*    mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool?
    mutating func decodeIfPresent(_ type: Int.Type) throws -> Int?
    mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8?
    mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16?
    mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32?
    mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64?
    mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt?
    mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8?
    mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16?
    mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32?
    mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64?
    mutating func decodeIfPresent(_ type: Float.Type) throws -> Float?
    mutating func decodeIfPresent(_ type: Double.Type) throws -> Double?
    mutating func decodeIfPresent(_ type: String.Type) throws -> String?
    mutating func decodeIfPresent<T : Decodable>(_ type: T.Type) throws -> T?*/

    /// The path of coding keys taken to get to this point in decoding.
    /// A `nil` value indicates an unkeyed container.
    var codingPath: [CodingKey?] { get }
}

/// A `SingleValueEncodingContainer` is a container which can support the storage and direct encoding of a single non-keyed value.
public protocol SingleValueEncodingContainer {
    /// Encodes a single value of the given type.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `CocoaError.coderInvalidValue` if the given value is invalid in the current context for this format.
    /// - precondition: May not be called after a previous `self.encode(_:)` call.
    mutating func encode(_ value: Bool) throws
    //mutating func encode(_ value: Int) throws
    mutating func encode(_ value: Int8) throws
    mutating func encode(_ value: Int16) throws
    mutating func encode(_ value: Int32) throws
    mutating func encode(_ value: Int64) throws
    //mutating func encode(_ value: UInt) throws
    mutating func encode(_ value: UInt8) throws
    mutating func encode(_ value: UInt16) throws
    mutating func encode(_ value: UInt32) throws
    mutating func encode(_ value: UInt64) throws
    mutating func encode(_ value: Float) throws
    mutating func encode(_ value: Double) throws
    mutating func encode(_ value: String) throws
}

/// A `SingleValueDecodingContainer` is a container which can support the storage and direct decoding of a single non-keyed value.
public protocol SingleValueDecodingContainer {
    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `CocoaError.coderTypeMismatch` if the encountered encoded value cannot be converted to the requested type.
    /*func decode(_ type: Bool.Type) throws -> Bool
    func decode(_ type: Int.Type) throws -> Int
    func decode(_ type: Int8.Type) throws -> Int8
    func decode(_ type: Int16.Type) throws -> Int16
    func decode(_ type: Int32.Type) throws -> Int32
    func decode(_ type: Int64.Type) throws -> Int64
    func decode(_ type: UInt.Type) throws -> UInt
    func decode(_ type: UInt8.Type) throws -> UInt8
    func decode(_ type: UInt16.Type) throws -> UInt16
    func decode(_ type: UInt32.Type) throws -> UInt32
    func decode(_ type: UInt64.Type) throws -> UInt64
    func decode(_ type: Float.Type) throws -> Float
    func decode(_ type: Double.Type) throws -> Double
    func decode(_ type: String.Type) throws -> String*/
}