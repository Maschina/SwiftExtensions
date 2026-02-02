import Foundation
import UniformTypeIdentifiers

extension URL {
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
	public var ipAddress: String? {
		let regex = /([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3})/
		do {
			guard let host = self.host() else { return nil }
			guard let matchingIPaddress = try regex.firstMatch(in: host) else { return nil }
			return String(matchingIPaddress.1)
		} catch {
			return nil
		}
	}
	
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
	public var hasIpAddress: Bool {
		let regex = /[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}/
		guard let host = self.host() else { return false }
		return host.firstMatch(of: regex) != nil
	}
	
	public var mimeType: String {
		if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
			return mimeType
		}
		else {
			return "application/octet-stream"
		}
	}
}

#if canImport(AppKit)

import AppKit

extension URL {
    public func open() {
        NSWorkspace.shared.open(self)
    }
}

#endif

#if canImport(UIKit)

import UIKit

extension URL {
    public func open() {
        UIApplication.shared.open(self)
    }
}

#endif
