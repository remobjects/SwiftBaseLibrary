#if COCOA
import CoreGraphics

public extension CGPoint {

	init() {
		return CoreGraphics.CGPointZero
	}

	init(x: CGFloat, y: CGFloat) {
		return CGPointMake(x, y)
	}

	var zero: CGPoint { return CoreGraphics.CGPointZero }
}

public extension CGSize {

	init() {
		return CoreGraphics.CGSizeZero
	}

	init(width: CGFloat, height: CGFloat) {
		return CGSizeMake(width, height)
	}

	var zero: CGSize { return CoreGraphics.CGSizeZero }
}

public extension CGRect {

	init() {
		return CoreGraphics.CGRectZero
	}

	init(origin: CGPoint, size: CGSize) {
		return CGRectMake(origin.x, origin.y, size.width, size.height)
	}

	init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
		return CGRectMake(x, y, width, height)
	}

	var x: CGFloat { return origin.x }
	var y: CGFloat { return origin.y }
	var width: CGFloat { return size.width }
	var height: CGFloat { return size.height }

	var zero: CGRect { return CoreGraphics.CGRectZero }
	var null: CGRect { return CoreGraphics.CGRectNull }
	var infinite: CGRect { return CoreGraphics.CGRectInfinite }
}
#endif