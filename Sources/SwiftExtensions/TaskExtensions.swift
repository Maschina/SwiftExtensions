import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Task where Success == Never, Failure == Never {
	public static func sleep(seconds: Int) async throws {
		let duration = UInt64(seconds) * NSEC_PER_SEC
		try await sleep(nanoseconds: duration)
	}
	
	public static func sleep(timeInterval: TimeInterval) async throws {
		let duration = UInt64(timeInterval * TimeInterval(NSEC_PER_SEC))
		try await sleep(nanoseconds: duration)
	}
	
	public static func sleep(milliseconds: Int) async throws {
		let duration = UInt64(milliseconds) * NSEC_PER_MSEC
		try await sleep(nanoseconds: duration)
	}
}

extension Task {
	/// Awaits the completion of the task with the option to discard the result
	@discardableResult
	public func finish() async -> Result<Success, Failure> {
		await self.result
	}
}
