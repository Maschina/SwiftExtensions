import Foundation

extension NSRegularExpression {
	public convenience init(_ pattern: String) {
		do {
			try self.init(pattern: pattern)
		} catch {
			preconditionFailure("Illegal regular expression: \(pattern).")
		}
	}
	
	public func isMatching(_ string: String) -> Bool {
		let range = NSRange(location: 0, length: string.utf16.count)
		return firstMatch(in: string, options: [], range: range) != nil
	}
	
	public func match(_ string: String, groupIndex: Int) -> String? {
		let match = firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
		if let result = match?.range(at: groupIndex) {
			return String(string[Range(result, in: string)!])
		}
		return nil
	}
	
	@available(OSX 10.13, *)
	public func match(_ string: String, groupName: String) -> String? {
		let match = firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
		if let result = match?.range(withName: groupName) {
			return String(string[Range(result, in: string)!])
		}
		return nil
	}
}
