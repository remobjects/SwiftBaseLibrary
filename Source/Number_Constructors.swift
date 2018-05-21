// ctors

#if COCOA
fileprivate static func parseNumber(_ value: String) -> NSNumber? {
	var value = value
	let formatter = NSNumberFormatter()
	formatter.numberStyle = .decimalStyle
	formatter.locale = nil
	if value.hasPrefix("+") && value.range(of: "-").location == NSNotFound { // NSNumberFormatter doesn't like +, strip it;
		value = value.substring(fromIndex: 1)
	}
	return formatter.numberFromString(value)
}
#endif

public extension Int8 {

	init(_ value: String) {
		if #defined(JAVA) {
			return java.lang.Byte.parseByte(value);
		} else if #defined(CLR) || #defined(ISLAND) {
			return Int8.Parse(value);
		} else if #defined(COCOA) {
			if let result = parseNumber(value) {
				return result.charValue
			} else {
				throw Exception("Error parsing Integer")
			}
		}
	}
}

public extension Int16 {

	init(_ value: String) {
		if #defined(JAVA) {
			return java.lang.Integer.parseInt(value);
		} else if #defined(CLR) || #defined(ISLAND) {
			return Int16.Parse(value);
		} else if #defined(COCOA) {
			if let result = parseNumber(value) {
				return result.shortValue
			} else {
				throw Exception("Error parsing Integer")
			}
		}
	}
}

public extension Int32 {

	init(_ value: String) {
		if #defined(JAVA) {
			return java.lang.Integer.parseInt(value);
		} else if #defined(CLR) || #defined(ISLAND) {
			return Int32.Parse(value);
		} else if #defined(COCOA) {
			if let result = parseNumber(value) {
				return result.intValue
			} else {
				throw Exception("Error parsing Integer")
			}
		}
	}
}

public extension Int64 {

	init(_ value: String) {
		if #defined(JAVA) {
			return java.lang.Long.parseLong(value)
		} else if #defined(CLR) || #defined(ISLAND) {
			return Int64.Parse(value)
		} else if #defined(COCOA) {
			if let result = parseNumber(value) {
				return result.longValue
			} else {
				throw Exception("Error parsing Integer")
			}
		}
	}
	}

public extension Float {

	init(_ value: String) {
		if #defined(JAVA) {
			return java.lang.Float.parseFloat(value);
		} else if #defined(CLR) || #defined(ISLAND) {
			return Float.Parse(value);
		} else if #defined(COCOA) {
			if let result = parseNumber(value) {
				return result.floatValue
			} else {
				throw Exception("Error parsing Integer")
			}
		}
	}
}

public extension Double {

	init(_ value: String) {
		if #defined(JAVA) {
			return java.lang.Double.parseDouble(value);
		} else if #defined(CLR) || #defined(ISLAND) {
			return Double.Parse(value);
		} else if #defined(COCOA) {
			if let result = parseNumber(value) {
				return result.doubleValue
			} else {
				throw Exception("Error parsing Integer")
			}
		}
	}
}