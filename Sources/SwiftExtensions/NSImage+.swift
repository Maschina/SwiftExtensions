#if canImport(AppKit)

import AppKit

extension NSImage {
	public convenience init?(systemSymbolName: String) {
		self.init(systemSymbolName: systemSymbolName, accessibilityDescription: nil)
	}
}

#endif
