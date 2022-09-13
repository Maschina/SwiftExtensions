import Foundation

extension Bool: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: Int) {
		self = value != 0
	}
}
