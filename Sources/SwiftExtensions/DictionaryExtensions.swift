import Foundation

extension Dictionary {
	public mutating func switchKey(fromKey: Key, toKey: Key) {
		if let entry = removeValue(forKey: fromKey) {
			self[toKey] = entry
		}
	}
	
	public subscript(optional key: Key?) -> Value? {
		guard let key = key else { return nil }
		return self[key]
	}
}
