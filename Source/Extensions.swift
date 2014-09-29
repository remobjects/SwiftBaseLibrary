
extension Object : Printable, DebugPrintable {

	#if NOUGAT
	#else
	var description: String {
		#if COOPER
		return toString()
		#elseif ECHOES
		return ToString()
		#endif
	}

	var debugDescription: String { 
		#if COOPER
		return toString()
		#elseif ECHOES
		return ToString()
		#endif
	}
	#endif
}

