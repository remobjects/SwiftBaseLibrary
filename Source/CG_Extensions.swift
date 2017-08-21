#if COCOA
import CoreGraphics

public extension CGPoint {

	public init() {
		return CoreGraphics.CGPointZero
	}

	public init(x: CGFloat, y: CGFloat) {
		return CGPointMake(x, y)
	}

	public var zero: CGPoint { return CoreGraphics.CGPointZero }
}

public extension CGSize {

	public init() {
		return CoreGraphics.CGSizeZero
	}

	public init(width: CGFloat, height: CGFloat) {
		return CGSizeMake(width, height)
	}

	public var zero: CGSize { return CoreGraphics.CGSizeZero }
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

	public var x: CGFloat { return origin.x }
	public var y: CGFloat { return origin.y }
	public var width: CGFloat { return size.width }
	public var height: CGFloat { return size.height }

	public var zero: CGRect { return CoreGraphics.CGRectZero }
	public var null: CGRect { return CoreGraphics.CGRectNull }
	public var infinite: CGRect { return CoreGraphics.CGRectInfinite }
}
#endif