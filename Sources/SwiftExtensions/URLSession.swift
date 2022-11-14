import Foundation


public extension URLSession {
	
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
