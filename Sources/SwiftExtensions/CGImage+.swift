// Copyright (C) 2023 Robert Hahn. All Rights Reserved.

import Foundation
import CoreImage
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension CGImage {
#if !os(macOS)
	public var uiImage: UIImage? {
		UIImage(cgImage: self)
	}
#endif
}
