import RemObjects.Elements.EUnit

public extension Range {
	public var allValuesAsString: String {
		var result = ""
		for v in self {
			if result != "" {
				result += ","
			}
			result += v
		}
		return result
	}
}


public class RangeTests : Test {

	public func FirstTest() {

		var openRange = 1..<5
		Check.AreEqual(openRange.description, "1..<5")
		Check.AreEqual(openRange.allValuesAsString, "1,2,3,4")

		var openRange2 = 5..<1
		Check.AreEqual(openRange2.description, "5..<1")
		Check.AreEqual(openRange2.allValuesAsString, "5,4,3,2")

		var reversedOpenRange = 5>..1
		Check.AreEqual(reversedOpenRange.description, "5>..1")
		Check.AreEqual(reversedOpenRange.allValuesAsString, "4,3,2,1")

		var reversedOpenRange2 = 1>..5
		Check.AreEqual(reversedOpenRange2.description, "1>..5")
		Check.AreEqual(reversedOpenRange2.allValuesAsString, "2,3,4,5")

		//
		//

		var closedRange = 1...5
		Check.AreEqual(closedRange.description, "1...5")
		Check.AreEqual(closedRange.allValuesAsString, "1,2,3,4,5")

		var reversedClosedRange = 5...1
		Check.AreEqual(reversedClosedRange.description, "5...1")
		Check.AreEqual(reversedClosedRange.allValuesAsString, "5,4,3,2,1")

		//
		//

		var looseOpenRange = ..<5
		Check.AreEqual(looseOpenRange.description, "..<5")
		Check.Throws() { _ = looseOpenRange.allValuesAsString }

		var looseOpenRange2 = 5>..
		Check.AreEqual(looseOpenRange2.description, "5>..")
		//Check.Throws() { _ = looseOpenRange2.allValuesAsString }
		Check.AreEqual(looseOpenRange2.allValuesAsString, "4,3,2,1,0")

		//
		//

		var looseClosedRange = ...5
		Check.AreEqual(looseClosedRange.description, "...5")
		Check.Throws() { _ = looseClosedRange.allValuesAsString }

		var looseClosedRange2 = 5...
		Check.AreEqual(looseClosedRange2.description, "5...")
		//CANNOT TEST, infinmite sequence: // Check.Throws() { _ = looseClosedRange2.allValuesAsString }

	}

}