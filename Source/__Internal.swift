
func __newLine() -> String {
	#if JAVA
	return System.getProperty("line.separator")
	#elseif CLR
	return System.Environment.NewLine
	#elseif ISLAND
	return RemObjects.Elements.System.Environment.NewLine
	#elseif COCOA
	return "\n"
	#endif
}

@inline(__always) func __toString(_ object: Object?) -> String {
	if let object = object {
		#if JAVA
		return object.toString()
		#elseif CLR || ISLAND
		return object.ToString()
		#elseif COCOA
		return object.description
		#endif
	} else {
		return "(null)"
	}
}

@inline(__always) func __toNativeString(_ object: Object?) -> String {
	if let object = object {
		#if JAVA
		return object.toString()
		#elseif CLR || ISLAND
		return object.ToString()
		#elseif COCOA
		return object.description
		#endif
	} else {
		return "(null)"
	}
}