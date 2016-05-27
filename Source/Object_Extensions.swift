
#if !NOUGAT
public extension Object : CustomStringConvertible, CustomDebugStringConvertible {

	@inline(__always) public var description: String {
		#if COOPER
		return self.toString()
		#elseif ECHOES
		return self.ToString()
		#endif
	}

	@inline(__always) public var debugDescription: String { 
		#if COOPER
		return self.toString()
		#elseif ECHOES
		return self.ToString()
		#endif
	}
}
#endif

public extension Object {

	public var hashValue: Int {
		#if COOPER
		return self.hashCode()
		#elseif ECHOES
		return self.GetHashCode()
		#elseif NOUGAT
		return self.hashValue()
		#endif
	}
}
