
func __newLine() -> String {
    #if COOPER
    return System.getProperty("line.separator")
    #elseif ECHOES
    return System.Environment.NewLine
    #elseif NOUGAT
    return "\n"
    #endif
}

@inline(__always) func __toString(object: Object?) -> String {
    if let object = object {
        #if COOPER
        return object.toString()
        #elseif ECHOES
        return object.ToString()
        #elseif NOUGAT
        return object.description
        #endif
    } else {
        return "(null)"
    }
}