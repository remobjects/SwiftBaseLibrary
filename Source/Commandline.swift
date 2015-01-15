internal var __C_ARGC = 0
internal var __C_ARGV = [String]()
public var C_ARGC: Int { get { return __C_ARGC; } }
public var C_ARGV: [String] { get { return __C_ARGV; } } // ToDo:should be [String]!

public func `$$setArgV`(args: String[]) {
	__C_ARGC = length(args);
	__C_ARGV = [String](arrayLiteral: args);
}

#if NOUGAT
public func __stringArrayToCStringArray(arcv: [String]) -> (UnsafePointer<AnsiChar>)[] {
	
	var result = UnsafePointer<AnsiChar>[](length(arcv))
	for var i = 0; i < arcv.count; i++ {
		if arcv[i] != nil {
			result[i] = arcv[i].UTF8String
		} else {
			result[i] = nil
		}
	}
	return result
}
#endif