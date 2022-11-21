#if os(macOS)
import AppKit

public extension NSView {
	func bitmapImage() -> NSImage? {
		guard let rep = bitmapImageRepForCachingDisplay(in: bounds) else {
			return nil
		}
		cacheDisplay(in: bounds, to: rep)
		guard let cgImage = rep.cgImage else {
			return nil
		}
		return NSImage(cgImage: cgImage, size: bounds.size)
	}
}

#endif
