import Foundation

extension Optional {
	public var isNotNil: Bool { self != nil }
}

extension Optional where Wrapped: Equatable {
	@discardableResult
	public mutating func compareOrSetOptional(against value: Wrapped) -> Bool {
		if self == nil { self = value }
		return self == value
	}
	
	@discardableResult
	public mutating func compareOrSetOptional(against value: Wrapped?) -> Bool {
		if self == nil { self = value }
		return self == value
	}
}
