import Foundation

extension Comparable {
    public func clamp(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
    
    public mutating func clamped(to limits: ClosedRange<Self>) {
        self = min(max(self, limits.lowerBound), limits.upperBound)
    }
}
