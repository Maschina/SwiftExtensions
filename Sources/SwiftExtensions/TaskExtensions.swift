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

extension Task where Failure == Error {
	/// Runs the given throwing operation asynchronously
	/// as part of a new top-level task on behalf of the current actor.
	///
	/// Use this function when creating asynchronous work
	/// that operates on behalf of the synchronous function that calls it.
	/// Like `Task.detached(priority:operation:)`,
	/// this function creates a separate, top-level task.
	/// Unlike `detach(priority:operation:)`,
	/// the task created by `Task.init(priority:operation:)`
	/// inherits the priority and actor context of the caller,
	/// so the operation is treated more like an asynchronous extension
	/// to the synchronous operation.
	///
	/// You need to keep a reference to the task
	/// if you want to cancel it by calling the `Task.cancel()` method.
	/// Discarding your reference to a detached task
	/// doesn't implicitly cancel that task,
	/// it only makes it impossible for you to explicitly cancel the task.
	///
	/// - Parameters:
	///   - priority: The priority of the task.
	///     Pass `nil` to use the priority from `Task.currentPriority`.
	///   - timeout: The duration in seconds `operation` is allowed to run before timing out.
	///   - operation: The operation to perform.
	@available(macOS 13.0, *)
	@discardableResult
	public init(
		priority: TaskPriority? = nil,
		timeout: Duration,
		operation: @escaping @Sendable () async throws -> Success,
		timeoutHandler:  @escaping @Sendable () async -> () = { }
	) {
		self = Task(priority: priority) {
			try await withThrowingTaskGroup(of: Success.self) { group -> Success in
				// Start actual work
				group.addTask(operation: operation)
				// Start timeout child task
				group.addTask {
					try await Task<Never, Never>.sleep(for: timeout)
					throw TimeoutError()
				}
				guard let success = try await group.next() else {
					await timeoutHandler()
					throw _Concurrency.CancellationError()
				}
				group.cancelAll()
				return success
			}
		}
	}
}

private struct TimeoutError: LocalizedError {
	var errorDescription: String? = "Task timed out before completion"
}
