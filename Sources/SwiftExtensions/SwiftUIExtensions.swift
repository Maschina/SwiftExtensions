import SwiftUI

#if os(macOS)

@available(macOS 10.15, *)
extension View {
	public func renderAsImage() -> NSImage? {
		let view = NoInsetHostingView(rootView: self)
		view.setFrameSize(view.fittingSize)
		return view.bitmapImage()
	}
}

@available(macOS 10.15, *)
private class NoInsetHostingView<V>: NSHostingView<V> where V: View {
	override var safeAreaInsets: NSEdgeInsets {
		return .init()
	}
}

#endif

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension LocalizedStringKey {
	var stringKey: String? {
		Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
	}
	
	func stringValue(locale: Locale = .current) -> String {
		guard let stringKey = stringKey else { return "?" }
		return .localizedString(for: stringKey, locale: locale)
	}
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Array where Element == LocalizedStringKey {
	
	/// Returns a new string by concatenating the elements of the sequence,
	/// adding the given separator between each element.
	///
	/// The following example shows how an array of strings can be joined to a
	/// single, comma-separated string:
	///
	///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
	///     let list = cast.joined(separator: ", ")
	///     print(list)
	///     // Prints "Vivien, Marlon, Kim, Karl"
	///
	/// - Parameter separator: A string to insert between each of the elements
	///   in this sequence. The default separator is an empty string.
	/// - Returns: A single, concatenated string.
	@available(macOS 11.0, *)
	public func joined(separator: LocalizedStringKey = "") -> Text {
		var result = Text("")
		for element in self {
			if element == self.last {
				result = result + Text(element)
			} else {
				result = result + Text(element) + Text(separator)
			}
		}
		return result
	}
}

@available(iOS 13.0, *)
@available(macOS 11.0, *)
extension LocalizedStringKey.StringInterpolation {
	public mutating func appendInterpolation(_ input: Int, format formatter: NumberFormatter) {
		if let result = formatter.string(from: input as NSNumber) {
			appendLiteral(result)
		}
	}
	
	public mutating func appendInterpolation(_ input: Double, format formatter: NumberFormatter) {
		if let result = formatter.string(from: input as NSNumber) {
			appendLiteral(result)
		}
	}
}

extension Shape {
	public func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
		self
			.stroke(strokeStyle, lineWidth: lineWidth)
			.background(self.fill(fillStyle))
	}
}

extension InsettableShape {
	public func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
		self
			.strokeBorder(strokeStyle, lineWidth: lineWidth)
			.background(self.fill(fillStyle))
	}
}
