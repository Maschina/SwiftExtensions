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
