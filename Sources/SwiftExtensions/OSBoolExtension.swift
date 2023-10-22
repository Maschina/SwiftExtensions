//  Created by Robert Hahn on 06.10.23.

import Foundation

public extension Bool {
	static var macOS12: Bool {
		if #available(macOS 12, *) { return true }
		return false
	}
	
	static var macOS13: Bool {
		if #available(macOS 13, *) { return true }
		return false
	}
	
	static var macOS14: Bool {
		if #available(macOS 14, *) { return true }
		return false
	}
}
