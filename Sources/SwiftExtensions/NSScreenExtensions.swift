#if os(macOS)
import AppKit

extension NSScreen {
	public static func getScreenWithMouse() -> NSScreen? {
		let mouseLocation = NSEvent.mouseLocation
		let screens = NSScreen.screens
		let screenWithMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })
		
		return screenWithMouse
	}
	
	public var displayIdentifier: String {
		guard let number = deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber else {
			return ""
		}
		let uuid = CGDisplayCreateUUIDFromDisplayID(number.uint32Value).takeRetainedValue()
		return CFUUIDCreateString(nil, uuid) as String
	}
}
#endif
