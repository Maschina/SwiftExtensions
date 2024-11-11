import SwiftUI

extension View {
	@ViewBuilder
	public func modifiers<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
		content(self)
	}
}

extension View {
	/// Conditionally apply modifiers to views
	/// - Parameters:
	///   - condition: Condition when to apply
	///   - transform: Modifier
	/// - Returns: View
	///
	/// - Example: *Apply padding, if X*
	/// ~~~
	/// .if(X) { $0.padding(8) }
	/// ~~~
	@ViewBuilder
	public func `if`<Transform: View>(
		_ condition: Bool,
		transform: (Self) -> Transform
	) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
	
	/// Conditionally apply modifiers to view including else block
	/// - Parameters:
	///   - condition: Condition when to apply
	///   - ifTransform: Modifier if true
	///   - elseTransform: Modifier if false
	/// - Returns: View
	///
	/// - Example: *Apply padding, if X, else apply blue background color
	/// ~~~
	/// .if(X) { $0.padding(8) } else: { $0.background(Color.blue) }
	/// ~~~
	@ViewBuilder
	public func `if`<TrueContent: View, FalseContent: View>(
		_ condition: Bool,
		if ifTransform: (Self) -> TrueContent,
		else elseTransform: (Self) -> FalseContent
	) -> some View {
		if condition {
			ifTransform(self)
		} else {
			elseTransform(self)
		}
	}
	
	/// Conditionally apply modifier if value is not nil
	/// - Parameters:
	///   - value: Optional value
	///   - transform: Modifier
	/// - Returns: View
	///
	/// - Example: *Apply give foreground color, if not nil*
	/// ~~~
	/// .ifLet(optionalColor) { $0.foregroundColor($1) }
	/// ~~~
	@ViewBuilder
	public func ifLet<V, Transform: View>(
		_ value: V?,
		transform: (Self, V) -> Transform
	) -> some View {
		if let value = value {
			transform(self, value)
		} else {
			self
		}
	}
}

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
	public func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1, shadowRadius: CGFloat? = nil, shadowColor: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), shadowX: CGFloat = 0, shadowY: CGFloat = 0) -> some View {
		self
			.stroke(strokeStyle, lineWidth: lineWidth)
			.background(
				self
					.fill(fillStyle)
					.ifLet(shadowRadius, transform: { shape, radius in
						shape
							.shadow(color: shadowColor, radius: radius, x: shadowX, y: shadowY)
					})
			)
	}
	
	/// fills and strokes a shape
	public func fill<S: ShapeStyle>(_ fillContent: S, stroke: StrokeStyle, strokeColor: S, shadowRadius: CGFloat? = nil, shadowColor: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), shadowX: CGFloat = 0, shadowY: CGFloat = 0) -> some View {
		ZStack {
			self
				.fill(fillContent)
				.ifLet(shadowRadius, transform: { shape, radius in
					shape
						.shadow(color: shadowColor, radius: radius, x: shadowX, y: shadowY)
				})
			
			self.stroke(strokeColor, style: stroke)
		}
	}
}

extension InsettableShape {
	public func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
		self
			.strokeBorder(strokeStyle, lineWidth: lineWidth)
			.background(self.fill(fillStyle))
	}
}

extension Color {
	/// This color is either black or white, whichever is more accessible when viewed against the scrum color.
	public var bestContrastColor: Color {
		self.bestContrastColor()
	}
	
	/// This color is either black or white, whichever is more accessible when viewed against the scrum color.
	public func bestContrastColor(in colorSpace: NSColorSpace = .deviceRGB) -> Color {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
#if os(iOS)
		guard let rgbColor = UIColor(self).usingColorSpace(colorSpace) else { return Color.primary }
		rgbColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
#elseif os(macOS)
		guard let rgbColor = NSColor(self).usingColorSpace(colorSpace) else { return Color.primary }
		rgbColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
#endif
		return isLightColor(red: red, green: green, blue: blue) ? .black : .white
	}
	
	/// This color is either black or white, whichever is more accessible when viewed against the scrum color.
	@available(*, deprecated, renamed: "bestContrastColor")
	public var accessibleFontColor: Color {
		self.bestContrastColor()
	}
	
	/// This color is either black or white, whichever is more accessible when viewed against the scrum color.
	@available(*, deprecated, renamed: "bestContrastColor(in:)")
	public func accessibleFontColor(in colorSpace: NSColorSpace = .deviceRGB) -> Color {
		bestContrastColor(in: colorSpace)
	}
	
	private func isLightColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
		let lightRed = red > 0.65
		let lightGreen = green > 0.65
		let lightBlue = blue > 0.65
		
		let lightness = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }
		return lightness >= 2
	}
}

extension Font {
	static public func roundedFont(_ style: Font.TextStyle) -> Font {
		Font.system(style, design: .rounded)
	}
}


// MARK: Binding extension

extension Binding {
	public func toPresented<T>() -> Binding<Bool> where Value == Optional<T> {
		Binding<Bool> {
			wrappedValue != nil
		} set: {
			if !$0 {
				self.wrappedValue = nil
			}
		}
	}
	
}

extension Binding {
	/// Wrapper to listen to didSet of Binding
	func didSet(_ didSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
		return .init(get: { self.wrappedValue }, set: { newValue in
			let oldValue = self.wrappedValue
			self.wrappedValue = newValue
			didSet((newValue, oldValue))
		})
	}
	
	/// Wrapper to listen to willSet of Binding
	func willSet(_ willSet: @escaping ((newValue: Value, oldValue: Value)) -> Bool) -> Binding<Value> {
		return .init(get: { self.wrappedValue }, set: { newValue in
			if willSet((newValue, self.wrappedValue)) {
				self.wrappedValue = newValue
			}
		})
	}
}


// MARK: Menu

extension Menu {
	public init(@ViewBuilder content: () -> Content) where Label == Text {
		self.init("", content: content)
	}
}
