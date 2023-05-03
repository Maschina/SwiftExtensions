#if os(macOS)
import AppKit
#else
import UIKit.UIImage

extension CGImagePropertyOrientation {
	public init(_ orientation: UIImage.Orientation) {
		switch orientation {
			case .up: self = .up
			case .upMirrored: self = .upMirrored
			case .down: self = .down
			case .downMirrored: self = .downMirrored
			case .left: self = .left
			case .leftMirrored: self = .leftMirrored
			case .right: self = .right
			case .rightMirrored: self = .rightMirrored
			@unknown default:
				fatalError("Orientation unkown")
		}
	}
}
#endif

extension CIImage {
	
#if !os(macOS)
	/// Creates a `CIImage` and preserve the image orientation.
	///
	/// The `CIImage(image: )` initializer does uses the current orientation of the `UIImage`, we fix this be applying a new orientation property.
	/// Source: https://stackoverflow.com/a/61849964/10026834
	///
	/// - Parameter image: Images with an orientation.
	public convenience init?(imageWithOrientation image: UIImage) {
		self.init(image: image,
				  options: [
					.applyOrientationProperty: true,
					.properties: [kCGImagePropertyOrientation: CGImagePropertyOrientation(image.imageOrientation).rawValue]
				  ])
	}
#endif
	
	public func jpegData(compressionQuality quality: CGFloat = 0.9, colorSpace: CGColorSpace? = nil) -> Data? {
		guard let colorSpace = colorSpace ?? self.colorSpace else { return nil }
		let context = CIContext()
		return context.jpegRepresentation(of: self, colorSpace: colorSpace, options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption : quality])
	}
	
	public func pngData(format: CIFormat? = nil, colorSpace: CGColorSpace? = nil) -> Data? {
		guard let colorSpace = colorSpace ?? self.colorSpace else { return nil }
		let format = format ?? CIFormat.RGBA8
		
		let context = CIContext()
		return context.pngRepresentation(of: self, format: format, colorSpace: colorSpace)
	}
}

extension CIImage {
	public func generateCgImage() -> CGImage? {
		let context = CIContext()
		guard let cgImage = context.createCGImage(self, from: self.extent) else { return nil }
		return cgImage
	}
}
