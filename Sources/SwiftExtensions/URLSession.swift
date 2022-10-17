import Foundation


public extension URLSession {
	
	@available(macOS 10.15.0, *)
	@available(macOS, deprecated: 12.0, message: "Use the built-in API instead")
	/// Creates a task that retrieves the contents of a URL based on the specified URL request object, and awaits the completion. This is a fallback solution for macOS <12.0
	/// - Parameter request: Request URL load request
	/// - Returns: Data bytes and Response from the server
	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		let sessionDataTask = URLSessionDataTaskActor()
		
		return try await withTaskCancellationHandler {
			Task { await sessionDataTask.cancel() }
		} operation: {
			try await withCheckedThrowingContinuation { continuation in
				Task { [weak self] in
					guard let self else { return }
					
					await sessionDataTask.start(self.dataTask(with: request) { data, response, error in
						guard let data = data, let response = response else {
							let error = error ?? URLError(.badServerResponse)
							return continuation.resume(throwing: error)
						}
						
						continuation.resume(returning: (data, response))
					})
				}
			}
		}
	}
	
	@available(macOS 10.15.0, *)
	@available(macOS, deprecated: 12.0, message: "Use the built-in API instead")
	private actor URLSessionDataTaskActor {
		weak var task: URLSessionDataTask?
		
		func start(_ task: URLSessionDataTask) {
			self.task = task
			task.resume()
		}
		
		func cancel() {
			task?.cancel()
		}
	}
}
