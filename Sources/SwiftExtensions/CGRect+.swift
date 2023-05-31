import Foundation

extension CGRect {
	/** Creates a rectangle with the given center and dimensions
	 - parameter center: The center of the new rectangle
	 - parameter size: The dimensions of the new rectangle
	 */
	public init(center: CGPoint, size: CGSize)
	{
		self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
	}
	
	/** the coordinates of this rectangles center */
	public var center: CGPoint
	{
		get { return CGPoint(x: centerX, y: centerY) }
		set { centerX = newValue.x; centerY = newValue.y }
	}
	
	/** the x-coordinate of this rectangles center
	 - note: Acts as a settable midX
	 - returns: The x-coordinate of the center
	 */
	public var centerX: CGFloat
	{
		get { return midX }
		set { origin.x = newValue - width * 0.5 }
	}
	
	/** the y-coordinate of this rectangles center
	 - note: Acts as a settable midY
	 - returns: The y-coordinate of the center
	 */
	public var centerY: CGFloat
	{
		get { return midY }
		set { origin.y = newValue - height * 0.5 }
	}
	
	// MARK: - "with" convenience functions
	
	/** Same-sized rectangle with a new center
	 - parameter center: The new center, ignored if nil
	 - returns: A new rectangle with the same size and a new center
	 */
	public func with(center: CGPoint?) -> CGRect
	{
		return CGRect(center: center ?? self.center, size: size)
	}
	
	/** Same-sized rectangle with a new center-x
	 - parameter centerX: The new center-x, ignored if nil
	 - returns: A new rectangle with the same size and a new center
	 */
	public func with(centerX: CGFloat?) -> CGRect
	{
		return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY), size: size)
	}
	
	/** Same-sized rectangle with a new center-y
	 - parameter centerY: The new center-y, ignored if nil
	 - returns: A new rectangle with the same size and a new center
	 */
	public func with(centerY: CGFloat?) -> CGRect
	{
		return CGRect(center: CGPoint(x: centerX, y: centerY ?? self.centerY), size: size)
	}
	
	/** Same-sized rectangle with a new center-x and center-y
	 - parameter centerX: The new center-x, ignored if nil
	 - parameter centerY: The new center-y, ignored if nil
	 - returns: A new rectangle with the same size and a new center
	 */
	public func with(centerX: CGFloat?, centerY: CGFloat?) -> CGRect
	{
		return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY ?? self.centerY), size: size)
	}
	
	public func distance(to rect: CGRect) -> CGSize {
		if intersects(rect) {
			return CGSize(width: 0, height: 0)
		}
		
		let mostLeft = origin.x < rect.origin.x ? self : rect
		let mostRight = rect.origin.x < self.origin.x ? self : rect
		
		var xDifference = mostLeft.origin.x == mostRight.origin.x ? 0 : mostRight.origin.x - (mostLeft.origin.x + mostLeft.size.width)
		xDifference = CGFloat(max(0, xDifference))
		
		let upper = self.origin.y < rect.origin.y ? self : rect
		let lower = rect.origin.y < self.origin.y ? self : rect
		
		var yDifference = upper.origin.y == lower.origin.y ? 0 : lower.origin.y - (upper.origin.y + upper.size.height)
		yDifference = CGFloat(max(0, yDifference))
		
		return CGSize(width: xDifference, height: yDifference)
	}
}
