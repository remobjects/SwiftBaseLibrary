internal var __C_ARGC = 0
internal var __C_ARGV: [NativeString]!
public var C_ARGC: Int { get { return __C_ARGC; } }
public var C_ARGV: [NativeString] { get { return __C_ARGV!; } }

public func `$$setArgV`(_ args: NativeString[]) {
	__C_ARGC = length(args);
	__C_ARGV = [NativeString](arrayLiteral: args);
}

#if COCOA
public func __stringArrayToCStringArray(_ arcv: [NativeString]) -> (UnsafePointer<AnsiChar>)[] {

	var result = UnsafePointer<AnsiChar>[](arcv.count)
	for i in 0 ..< arcv.count {
		if arcv[i] != nil {
			result[i] = (arcv[i] as! NativeString).UTF8String
		} else {
			result[i] = nil
		}
	}
	return result
}
#endif

public enum CommandLine {
  public static var argc: Int32 { return __C_ARGC }
  // public static var unsafeArgv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>
  public static var arguments: [String] { return __C_ARGV }
}