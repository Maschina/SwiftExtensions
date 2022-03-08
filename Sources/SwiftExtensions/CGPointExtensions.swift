import Foundation

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
	CGPoint(x: left.x + right.x, y: left.y + right.y)
}

extension CGPoint {
	public func project(by: CGSize) -> CGPoint {
		CGPoint(x: self.x * by.width, y: self.y * by.height)
	}
	
	public func horizontalMirror(distance mirror: CGFloat) -> CGPoint {
		CGPoint(x: self.x, y: (2 * mirror) - self.y)
	}
}
