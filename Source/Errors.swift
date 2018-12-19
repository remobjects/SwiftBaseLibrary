public typealias Error = Exception

public enum Result<Value, Error: Swift.Error> {
	case value(Value), error(Error)
}