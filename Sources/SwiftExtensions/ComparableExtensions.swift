import Foundation

extension Comparable {
    public func clamp(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
    
    public mutating func clamped(to limits: ClosedRange<Self>) {
        self = min(max(self, limits.lowerBound), limits.upperBound)
    }
	
	public func inRange(_ of: ClosedRange<Self>) -> Bool {
		of.contains(self)
	}
	
	public func inRange(safeLowerBound: Self, safeUpperBound: Self) -> Bool {
		let lowerBound = min(safeLowerBound, safeUpperBound)
		let upperBound = max(safeLowerBound, safeUpperBound)
		return self.inRange(lowerBound...upperBound)
	}
}
