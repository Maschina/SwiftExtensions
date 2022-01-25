import Foundation

extension CGPoint {
    public static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    public static func - (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }
    
    public static func += (lhs: inout CGPoint, rhs: CGVector)  {
        lhs = lhs + rhs
    }
    
    public static func -= (lhs: inout CGPoint, rhs: CGVector)  {
        lhs = lhs - rhs
    }
}


extension CGVector {
    public init(_ basis: CGPoint) {
        self.init(dx: basis.x, dy: basis.y)
    }
    
    public static func + (lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx + rhs, dy: lhs.dy + rhs)
    }
    
    public static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    public static func - (lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx - rhs, dy: lhs.dy - rhs)
    }
    
    public static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
    public static func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
    
    public static func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
        return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }
    
    public static func += (lhs: inout CGVector, rhs: CGFloat)  {
        lhs = lhs + rhs
    }
    
    public static func += (lhs: inout CGVector, rhs: CGVector)  {
        lhs = lhs + rhs
    }
    
    public static func -= (lhs: inout CGVector, rhs: CGFloat)  {
        lhs = lhs - rhs
    }
    
    public static func -= (lhs: inout CGVector, rhs: CGVector)  {
        lhs = lhs - rhs
    }
    
    public static func *= (lhs: inout CGVector, rhs: CGFloat)  {
        lhs = lhs * rhs
    }
    
    public static func /= (lhs: inout CGVector, rhs: CGFloat)  {
        lhs = lhs / rhs
    }
}

extension CGFloat {
	public func toString(format: String = "%.2f") -> String {
		String(format: format, self)
	}
}
