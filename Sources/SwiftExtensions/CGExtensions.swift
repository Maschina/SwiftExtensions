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
}

extension CGFloat {
	public func toString(format: String = "%.2f") -> String {
		String(format: format, self)
	}
}
