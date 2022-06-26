import Foundation

@available(macOS 10.15, *)
extension Task where Success == Never, Failure == Never {
	public static func sleep(seconds: Int) async throws {
		let duration = UInt64(seconds * 1000_000_000)
		try await sleep(nanoseconds: duration)
	}
}
