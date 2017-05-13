
//74077: Allow GetSequence() to actually be used to implement ISequence
public struct CollectionOfOne<Element> : ICollectionType<Bit, Int, Element> {
///*, ISequence<Int>*/ { // 74093: Silver: should not require explicit generic on interfaces in ancestor list

	public typealias Index = Bit
	public typealias Distance = Int // should not be needed, if default is provided

	/// Construct an instance containing just `element`.
	public init(_ element: Element) {
		self.element = element
	}

	/// The position of the first element.
	public var startIndex: Index {
		return .Zero
	}

	public var endIndex: Index {
		return .One
	}

	let element: Element

	public var count: Int {
		return 1
	}

	//
	// Subscripts & Iterators
	//

	public subscript(position: Index) -> Element {
		_precondition(position == .Zero, "Index out of range")
		return element
	}

	public func GetSequence() -> ISequence<Element> {
		__yield element
	}
}