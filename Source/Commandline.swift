var __C_ARGC = 0;
var __C_ARGV = String[](0);
public var C_ARGC: Int { get { return __C_ARGC; } }
public var C_ARGV: String[] { get { return __C_ARGV; } }

public func `@@nougatSetArgV`(args: String[]) {
	__C_ARGC = length(args);
	__C_ARGV = args;
}

#if NOUGAT
public func __stringArrayToCStringArray(arcv: String[]) -> (UnsafePointer<AnsiChar>)[] {
	
	var result = UnsafePointer<AnsiChar>[](length(arcv))
	for var i = 0; i < arcv.length; i++ {
		if arcv[i] != nil {
			result[i] = arcv[i].UTF8String
		} else {
			result[i] = nil
		}
		//result[i] = arcv[i] != nil ? arcv[i].UTF8String : ""
	}
	return result
}
#endif