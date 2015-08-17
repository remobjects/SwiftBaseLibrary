# SwiftBaseLibrary

The Swift Base Library is a small library that can be optionally used in Swift projects compiled with the [RemObjects Silver](http://elementscompiler.com/silver) compiler. It provides some of the core types, classes and functions that, while not part of the Swift language spec per se, are commonly used in Swift apps (and provided in a similar Swift Base Library in Apple's implementation).

This includes types such as the Swift-native [array](http://docs.elementscompiler.com/API/StandardTypes/Arrays) and [dictionary](http://docs.elementscompiler.com/API/StandardTypes/DictionarySwift) types, and base functions like `println()`.

The Swift Base Library ships precompiled with the [Elements](http://elementscompiler.com) compiler. New projects created with one of the RemObjects Silver project templates will automatically have a reference to the library, but if you are adding Swift files to a project that started out with a different language, you can add a reference to your projects via the [Add References](http://docs.elementscompiler.com/Projects/References) dialog in Fire or Visual Studio, where the Swift library should show automatically.

The library will be called `Swift.dll` on .NET, `libSwift.fx` on Cocoa and `swift.jar` on Java and Android.

The code for the Swift Base Library is open source and available under a liberal license. We appreciate contributions.

## See Also

* [RemObjects Silver Homepage](http://www.elementscompiler.com/silver/)
* [RemObjects Silver Docs](http://docs.elementscompiler.com/Silver/)
* [Swift Base Library API Reference](http://docs.elementscompiler.com/API/SwiftBaseLibrary) on docs.elementscompiler.com
