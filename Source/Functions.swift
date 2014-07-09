
#if NOUGAT
func println(object: Any? = nil) {
	if let ob = object {
		writeLn(object)
	} else {
		writeLn()
	}
}

#endif
