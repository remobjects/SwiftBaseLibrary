#if COCOA
import CoreGraphics

public extension CGPoint {

	public init() {
		return CoreGraphics.CGPointZero
	}

	public init(x: CGFloat, y: CGFloat) {
		return CGPointMake(x, y)
	}

	public static var zero: CGPoint { return CoreGraphics.CGPointZero }
}

public extension CGSize {

	public init() {
		return CoreGraphics.CGSizeZero
	}

	public init(width: CGFloat, height: CGFloat) {
		return CGSizeMake(width, height)
	}

	public static var zero: CGSize { return CoreGraphics.CGSizeZero }
}

public extension CGRect {

	public init() {
		return CoreGraphics.CGRectZero
	}

	public init(origin: CGPoint, size: CGSize) {
		return CGRectMake(origin.x, origin.y, size.width, size.height)
	}

	public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
		return CGRectMake(x, y, width, height)
	}

	public var minX: CGFloat { return size.width  >= 0 ? origin.x : origin.x-size.width }
	public var minY: CGFloat { return size.height >= 0 ? origin.y : origin.y-size.height }
	public var maxX: CGFloat { return size.width  >= 0 ? origin.x+size.width  : origin.x }
	public var maxY: CGFloat { return size.height >= 0 ? origin.y+size.height : origin.y }

	public var x: CGFloat { return origin.x }
	public var y: CGFloat { return origin.y }
	public var width: CGFloat { return size.width }
	public var height: CGFloat { return size.height }

	public static var zero: CGRect { return CoreGraphics.CGRectZero }
	public static var null: CGRect { return CoreGraphics.CGRectNull }
	public static var infinite: CGRect { return CoreGraphics.CGRectInfinite }
}
#endif