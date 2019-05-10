import RemObjects.Elements.EUnit

let lTests = Discovery.DiscoverTests()
return Runner.RunTests(lTests, withListener: Runner.DefaultListener) == TestState.Succeeded ? 0 : 1