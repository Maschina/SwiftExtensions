import SwiftUI

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
