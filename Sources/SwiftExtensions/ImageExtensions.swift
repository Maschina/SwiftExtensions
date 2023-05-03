#if os(macOS)
import AppKit
#else
import UIKit
#endif

import UniformTypeIdentifiers

#if os(macOS)
typealias PlatformImage = NSImage
#else
typealias PlatformImage = UIImage
#endif


extension PlatformImage {
#if os(macOS)
	@available(macOS 10.11, *)
	public convenience init?(gradient: [NSColor], size: NSSize, text textString: String, font: NSFont? = nil, highlighted: Bool) {
		// Gradient
		let gradient = NSGradient(colors: gradient) ?? NSGradient(colors: [NSColor.textBackgroundColor.withAlphaComponent(0.15)])
		
		// Text
		let textFont = font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize, weight: NSFont.Weight.regular)
		let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		let textColor = highlighted ? NSColor.selectedMenuItemTextColor : NSColor.controlTextColor
		let textFontAttributes: [NSAttributedString.Key : Any] = [
			NSAttributedString.Key.font: textFont,
			NSAttributedString.Key.foregroundColor: textColor,
			NSAttributedString.Key.paragraphStyle: textStyle
		]
		
		// Selection background
		let textBackgroundColor = highlighted ? NSColor.selectedMenuItemColor : NSColor.textBackgroundColor.withAlphaComponent(0.7)
		
		// Rectangles
		let gradientRect = NSRect(origin: CGPoint.zero, size: size)
		let textRect: NSRect? = {
			let textBox = textString.size(withAttributes: textFontAttributes)
			return NSRect(x: (gradientRect.size.width - textBox.width) / 2, y: (gradientRect.size.height - textBox.height) / 2, width: textBox.width, height: textBox.height)
		}()
		let textRectPath: NSBezierPath? = {
			guard let textRect = textRect else { return nil }
			return NSBezierPath(roundedRect: textRect.insetBy(dx: -4, dy: -1), xRadius: 5, yRadius: 5)
		}()
		let textHighlightPath: NSBezierPath? = {
			guard let textRect = textRect else { return nil }
			return highlighted ? NSBezierPath(roundedRect: gradientRect.insetBy(dx: 2, dy: 2), xRadius: 5, yRadius: 5) : NSBezierPath(rect: textRect)
		}()
		
		// Draw
		self.init(size: size)
		self.lockFocus()
		
		let path = NSBezierPath(roundedRect: gradientRect, xRadius: 7, yRadius: 7)
		gradient?.draw(in: path, angle: 0.0)
		
		if highlighted {
			textBackgroundColor.set()
			textHighlightPath?.fill()
		} else {
			textBackgroundColor.set()
			textRectPath?.fill()
		}
		
		// Draw text string, if given
		textString.draw(in: textRect ?? NSRect.zero, withAttributes: textFontAttributes)
		
		self.unlockFocus()
	}
	
	@available(macOS 10.11, *)
	public convenience init?(gradient: [NSColor], size: NSSize) {
		// Gradient
		let gradient = NSGradient(colors: gradient) ?? NSGradient(colors: [NSColor.textBackgroundColor.withAlphaComponent(0.15)])
		
		// Rectangle
		let gradientRect = NSRect(origin: CGPoint.zero, size: size)
		
		// Draw
		self.init(size: size)
		self.lockFocus()
		
		let path = NSBezierPath(roundedRect: gradientRect, xRadius: 7, yRadius: 7)
		gradient?.draw(in: path, angle: 0.0)
		
		self.unlockFocus()
	}
	
	public convenience init?(gradient: [NSColor], circle size: NSSize, highlighted: Bool = false) {
		// Gradient
		let gradient = NSGradient(colors: gradient) ?? NSGradient(colors: [NSColor.textBackgroundColor.withAlphaComponent(0.15)])
		
		// Rectangles
		let gradientCircle = NSRect(origin: CGPoint.zero, size: size)
		
		// Draw
		self.init(size: size)
		self.lockFocus()
		
		let path = NSBezierPath(ovalIn: gradientCircle)
		gradient?.draw(in: path, angle: 0.0)
		
		self.unlockFocus()
	}
	
	/// Draws a rectangle with single color
	/// - Parameters:
	///   - rectSize: size of rectangle
	///   - color: color of rectangle
	public convenience init(rectSize: NSSize, color: NSColor) {
		// Rectangle
		let rect = NSRect(origin: CGPoint.zero, size: rectSize)
		
		// Draw
		self.init(size: rectSize)
		self.lockFocus()
		color.set()
		rect.fill()
		self.unlockFocus()
	}
	
	public func resize(width: CGFloat, height: CGFloat) -> NSImage {
		let img = NSImage(size: CGSize(width:width, height:height))
		
		img.lockFocus()
		let ctx = NSGraphicsContext.current
		ctx?.imageInterpolation = .high
		self.draw(in: NSMakeRect(0, 0, width, height), from: NSMakeRect(0, 0, size.width, size.height), operation: .copy, fraction: 1)
		img.unlockFocus()
		
		img.isTemplate = self.isTemplate
		
		return img
	}
	
	public func resized(to newSize: NSSize, keepAspectRatio: Bool = true) -> NSImage? {
		let currentSize = self.size
		
		var newSize = newSize
		if keepAspectRatio {
			let ratioX = newSize.width / currentSize.width
			let ratioY = newSize.height / currentSize.height
			let ratio = ratioX < ratioY ? ratioX : ratioY
			newSize.width = currentSize.width * ratio
			newSize.height = currentSize.height * ratio
		}
		
		if let bitmapRep = NSBitmapImageRep(
			bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height),
			bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
			colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0
		) {
			bitmapRep.size = newSize
			NSGraphicsContext.saveGraphicsState()
			NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
			draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: .zero, operation: .copy, fraction: 1.0)
			NSGraphicsContext.restoreGraphicsState()
			
			let resizedImage = NSImage(size: newSize)
			resizedImage.addRepresentation(bitmapRep)
			return resizedImage
		}
		
		return nil
	}
	
	public func tint(color: NSColor) -> NSImage {
		let image = self.copy() as! NSImage
		image.isTemplate = false
		image.lockFocus()
		
		color.set()
		
		let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
		imageRect.fill(using: .sourceAtop)
		
		image.unlockFocus()
		
		return image
	}
#endif
}

extension NSItemProvider {
	@available(macOS 13.0, *)
	@available(iOS 16.0, *)
	public func loadDataRepresentation(for contentType: UTType) async throws -> Data? {
		try await withCheckedThrowingContinuation { [weak self] continuation in
			_ = self?.loadDataRepresentation(for: contentType, completionHandler: { data, error in
				if let error {
					continuation.resume(throwing: error)
					return
				}
				continuation.resume(returning: data)
			})
		}
	}
}
