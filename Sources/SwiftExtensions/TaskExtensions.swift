import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Task where Success == Never, Failure == Never {
	public static func sleep(seconds: Int) async throws {
		let duration = UInt64(seconds) * NSEC_PER_SEC
		try await sleep(nanoseconds: duration)
	}
	
	public static func sleep(milliseconds: Int) async throws {
		let duration = UInt64(milliseconds) * NSEC_PER_MSEC
		try await sleep(nanoseconds: duration)
	}
}
