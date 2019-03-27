import RemObjects.Elements.EUnit

public class DictionaryTests : Test {

	public func test82211() {

		var dict = [String: String]()
		dict["test"] = "someString"

		writeLn("dict[\"test\"] \(dict["test"])")

		Check.AreEqual(dict["test"], "someString") // good
		Check.IsNotNil(dict["test"]) // good
		Check.IsTrue(assigned(dict["test"])) // fails
		Check.IsTrue(dict["test"] != nil) // fails
		writeLn("dict[\"test\"] != nil \(dict["test"] != nil)") // False
		writeLn("dict[\"test\"] == nil \(dict["test"] == nil)") // True

		let hasValue: Bool = dict["test"] != nil
		writeLn("hasValue \(hasValue)")
		if !hasValue {
			throw Exception("dict[test] is not nil!")
		}
	}
}