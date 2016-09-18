
#if !COCOA
public extension Object : CustomStringConvertible, CustomDebugStringConvertible {

	@inline(__always) public var description: NativeString {
		#if JAVA
		return self.toString()
		#elseif CLR || ISLAND
		return self.ToString()
		#endif
	}

	@inline(__always) public var debugDescription: NativeString { 
		#if JAVA
		return self.toString()
		#elseif CLR || ISLAND
		return self.ToString()
		#endif
	}
}
#endif

public extension Object {

	public var hashValue: Int {
		#if JAVA
		return self.hashCode()
		#elseif CLR || ISLAND
		return self.GetHashCode()
		#elseif COCOA
		return self.hashValue()
		#endif
	}
}
