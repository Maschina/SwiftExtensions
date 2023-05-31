// Copyright (C) 2023 Robert Hahn. All Rights Reserved.

import Foundation

extension NSDataDetector {
	public static func firstMatch(type: NSTextCheckingResult.CheckingType, string: String) -> String? {
		if let detector = try? NSDataDetector(types: type.rawValue) {
			let matches = detector.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
			for match in matches {
				guard let range = Range(match.range, in: string) else { continue }
				let substring = String(string[range])
				return substring
			}
		}
		
		return nil
	}
}
