import CoreGraphics
import SpriteKit

extension CGVector {
	/**
	 * Creates a new CGVector given a CGPoint.
	 */
	public init(point: CGPoint) {
		self.init(dx: point.x, dy: point.y)
	}
	
	/**
	 * Given an angle in radians, creates a vector of length 1.0 and returns the
	 * result as a new CGVector. An angle of 0 is assumed to point to the right.
	 */
	public init(angle: CGFloat) {
		self.init(dx: cos(angle), dy: sin(angle))
	}
	
	/**
	 * Adds (dx, dy) to the vector.
	 */
	public mutating func offset(dx: CGFloat, dy: CGFloat) -> CGVector {
		self.dx += dx
		self.dy += dy
		return self
	}
	
	/**
	 * Returns the length (magnitude) of the vector described by the CGVector.
	 */
	public func length() -> CGFloat {
		return sqrt(dx*dx + dy*dy)
	}
	
	/**
	 * Returns the squared length of the vector described by the CGVector.
	 */
	public func lengthSquared() -> CGFloat {
		return dx*dx + dy*dy
	}
	
	/**
	 * Normalizes the vector described by the CGVector to length 1.0 and returns
	 * the result as a new CGVector.
	 public  */
	public func normalized() -> CGVector {
		let len = length()
		return len>0 ? self / len : CGVector.zero
	}
	
	/**
	 * Normalizes the vector described by the CGVector to length 1.0.
	 */
	public mutating func normalize() -> CGVector {
		self = normalized()
		return self
	}
	
	/**
	 * Calculates the distance between two CGVectors. Pythagoras!
	 */
	public func distanceTo(_ vector: CGVector) -> CGFloat {
		return (self - vector).length()
	}
	
	/**
	 * Returns the angle in radians of the vector described by the CGVector.
	 * The range of the angle is -π to π; an angle of 0 points to the right.
	 */
	public var angle: CGFloat {
		return atan2(dy, dx)
	}
}

public func + (lhs: CGVector, rhs: CGFloat) -> CGVector {
	return CGVector(dx: lhs.dx + rhs, dy: lhs.dy + rhs)
}

public func + (lhs: CGVector, rhs: CGVector) -> CGVector {
	return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

public func - (lhs: CGVector, rhs: CGFloat) -> CGVector {
	return CGVector(dx: lhs.dx - rhs, dy: lhs.dy - rhs)
}

public func - (lhs: CGVector, rhs: CGVector) -> CGVector {
	return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

public func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
	return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

public func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
	return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
}

public func += (lhs: inout CGVector, rhs: CGFloat)  {
	lhs = lhs + rhs
}

public func += (lhs: inout CGVector, rhs: CGVector)  {
	lhs = lhs + rhs
}

public func -= (lhs: inout CGVector, rhs: CGFloat)  {
	lhs = lhs - rhs
}

public func -= (lhs: inout CGVector, rhs: CGVector)  {
	lhs = lhs - rhs
}

public func *= (lhs: inout CGVector, rhs: CGFloat)  {
	lhs = lhs * rhs
}

public func /= (lhs: inout CGVector, rhs: CGFloat)  {
	lhs = lhs / rhs
}
