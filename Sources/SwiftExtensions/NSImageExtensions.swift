import Cocoa

extension NSImage {
	@available(macOS 10.11, *)
	public convenience init?(gradient: [NSColor], size: NSSize, text textString: String? = nil, font: NSFont? = nil, highlighted: Bool = false) {
		// Gradient
		let gradient = NSGradient(colors: gradient) ?? NSGradient(colors: [NSColor.textBackgroundColor.withAlphaComponent(0.15)])
		
		// Text
		let text: String? = { if let textString = textString { return textString } else { return nil } }()
		let textFont = font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize, weight: NSFont.Weight.light)
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
			guard let textBox = text?.size(withAttributes: textFontAttributes) else { return nil }
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
		text?.draw(in: textRect ?? NSRect.zero, withAttributes: textFontAttributes)
		
		self.unlockFocus()
	}
	
	@available(macOS 10.11, *)
	public convenience init?(gradient: [NSColor], rectangle size: NSSize, text textString: String? = nil, font: NSFont? = nil, highlighted: Bool = false) {
		// Gradient
		let gradient = NSGradient(colors: gradient) ?? NSGradient(colors: [NSColor.textBackgroundColor.withAlphaComponent(0.15)])
		
		// Text
		let text: String? = { if let textString = textString { return textString } else { return nil } }()
		let textFont = font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize, weight: NSFont.Weight.light)
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
			guard let textBox = text?.size(withAttributes: textFontAttributes) else { return nil }
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
		text?.draw(in: textRect ?? NSRect.zero, withAttributes: textFontAttributes)
		
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
}
