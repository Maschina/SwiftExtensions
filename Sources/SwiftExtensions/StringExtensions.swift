import Foundation
import CommonCrypto


extension NSString {
    public static func randomString(length: Int, letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String {
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
				return leader + self.suffix(limit - leader.count)
			case .middle:
				let charCount = Int(floor((Float(limit) - (Float(leader.count) / 2.0)) / 2.0))
				return "\(self.prefix(charCount))\(leader)\(self.suffix(charCount))"
			case .tail:
				return self.prefix(limit - leader.count) + leader
        }
    }
	
	@available(macOS 10.12, *)
	public func dateFormatterISO8601() -> Date? {
		guard self != "none" else { return nil }
		let formatter = ISO8601DateFormatter()
		return formatter.date(from: (self) + "Z") ?? Date()
	}
	
	static func localizedString(for key: String,
								locale: Locale = .current) -> String {
		
		let language = locale.languageCode
		let path = Bundle.main.path(forResource: language, ofType: "lproj")!
		let bundle = Bundle(path: path)!
		let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
		
		return localizedString
	}
}


extension String.StringInterpolation {
	public mutating func appendInterpolation(_ number: Int, format: NumberFormatter) {
		if let result = format.string(from: number as NSNumber) {
			appendLiteral(result)
		}
	}
}

//extension Optional where Wrapped == String {
//	@available(macOS 10.12, *)
//	public func dateFormatterISO8601() -> Date? {
//		guard let timeval = self else { return nil }
//		let formatter = ISO8601DateFormatter()
//		return formatter.date(from: (timeval) + "Z")
//	}
//}
