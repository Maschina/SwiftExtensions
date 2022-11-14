import Foundation

extension URL {
	public var ipAddress: String? {
		let regex = NSRegularExpression("([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3})")
		return regex.match(self.absoluteString, groupIndex: 1)
	}
}
