
public typealias CustomReflectable = ICustomReflectable
public protocol ICustomReflectable {
	@warn_unused_result func customMirror() -> Mirror
}

public typealias CustomLeafReflectable = ICustomLeafReflectable
public protocol ICustomLeafReflectable : ICustomReflectable {
}

public typealias MirrorPathType = IMirrorPathType
public protocol IMirrorPathType {
}

public class Mirror : ICustomStringConvertible, ICustomReflectable, IStreamable {

	//
	// Type Aliases
	//

	typealias Child = (label: String?, value: Any)
	typealias Children = ISequence<Child> // AnyForwardCollection

	//
	// Initializers
	//

	//74065: Silver: "cannot assign nil to [nullable enum type]"
	/*init(_ subject: Any, children: ISequence<Child>, displayStyle: Mirror.DisplayStyle? = nil, ancestorRepresentation: Mirror.AncestorRepresentation = Mirror.AncestorRepresentation.Generated) {
	}*/

	//74065: Silver: "cannot assign nil to [nullable enum type]"
	/*init(_ subject: Any, children: Children, displayStyle: Mirror.DisplayStyle? = /*nil*/Mirror.DisplayStyle.Class, ancestorRepresentation: Mirror.AncestorRepresentation = Mirror.AncestorRepresentation.Generated) {
	}*/

	//init(_:unlabeledChildren:displayStyle:ancestorRepresentation:)
	init(reflecting subject: Any) {
	}

	//
	// Properties
	//

	var children: Children {
		fatalError("Not implemented yet")
	}
	#if COCOA
	override var description: String! { 
	#else
	var description: String! { 
	#endif
		return "ToDo"
	}
	let displayStyle: Mirror.DisplayStyle? = nil
	//let subjectType: Any.Type
	
	//
	// Methods
	//

	@warn_unused_result func customMirror() -> Mirror {
		fatalError("Not implemented yet")
	}
	@warn_unused_result func descendant(_ first: IMirrorPathType, _ rest: IMirrorPathType...) -> Any? {
		fatalError("Not implemented yet")
	}
	@warn_unused_result func superclassMirror() -> Mirror? {
		fatalError("Not implemented yet")
	}
	
	//
	// Interfaces
	//

	func writeTo<Target: OutputStreamType>(inout _ target: Target) {
		//target.writeTo(description) // 74052: Silver: generic contraints don't seem to work
	}

	//
	// Nested Types
	//
	
	public enum DisplayStyle {
		case Struct, Class, Enum, Tuple, Optional, Collection, Dictionary, Set
	}
	
	public enum AncestorRepresentation {
		case Generated
		//case Customized(()->Mirror) // 74066: Silver: can't use an enum as default value, if it also has "more fancy" items
		case Suppressed
	}

	
}

