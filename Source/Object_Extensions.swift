public extension Object {

	#if !NOUGAT
	@inline(__always) public func description() -> String {
		#if COOPER
		return self.toString()
		#elseif ECHOES
		return self.ToString()
		#endif
	}

	#endif

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
