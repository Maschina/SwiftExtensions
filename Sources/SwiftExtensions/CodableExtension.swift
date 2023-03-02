import Foundation

extension Encodable {
	
	/// Encode into JSON and return `Data`
	public func jsonData() throws -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .iso8601
		return try encoder.encode(self)
	}
}
