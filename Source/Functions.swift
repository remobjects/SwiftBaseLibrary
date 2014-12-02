
public func println(object: Any? = nil) {
	if let unwrappedObject = object {
		writeLn(unwrappedObject)
	} else {
		writeLn()
	}
}

public func print(object: Any? = nil) {
	if let unwrappedObject = object {
		write(unwrappedObject)
	} 
}
