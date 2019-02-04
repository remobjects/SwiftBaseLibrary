import RemObjects.Elements.EUnit

let lTests = Discovery.DiscoverTests()
Runner.RunTests(lTests, withListener: Runner.DefaultListener)