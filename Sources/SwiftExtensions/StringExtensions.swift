import Foundation
import CommonCrypto


extension NSString {
    static func randomString(length: Int, letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String {
        return String((0 ..< length).map{ _ in letters.randomElement()! })
    }
}


extension String {
    public enum TruncationPosition {
        case head
        case middle
        case tail
    }

    public func truncated(limit: Int, position: TruncationPosition = .middle, leader: String = "...") -> String {
        guard self.count > limit else { return self }

        switch position {
        case .head:
            return leader + self.suffix(limit)
        case .middle:
            let headCharactersCount = Int(ceil(Float(limit) / 2.0))
            let tailCharactersCount = Int(floor(Float(limit) / 2.0))
            return "\(self.prefix(headCharactersCount))\(leader)\(self.suffix(tailCharactersCount))"
        case .tail:
            return self.prefix(limit) + leader
        }
    }
	
	@available(macOS 10.12, *)
	public func dateFormatterISO8601() -> Date {
		let formatter = ISO8601DateFormatter()
		return formatter.date(from: (self) + "Z") ?? Date()
	}
}

extension Optional where Wrapped == String {
	@available(macOS 10.12, *)
	public func dateFormatterISO8601() -> Date? {
		let formatter = ISO8601DateFormatter()
		return formatter.date(from: (self ?? "") + "Z")
	}
}
