import Foundation

extension AsyncStream {
	public func withPrevious() -> AsyncStream<(previous: Element?, current: Element)> {
		.init { continuation in
			Task {
				var previous: Element?
				for await element in self {
					continuation.yield((previous, element))
					previous = element
				}
				
				continuation.finish()
			}
		}
	}
	
	public func withPrevious(initialPreviousValue: Element) -> AsyncStream<(previous: Element, current: Element)> {
		.init { continuation in
			Task {
				var previous = initialPreviousValue
				for await element in self {
					continuation.yield((previous, element))
					previous = element
				}
				
				continuation.finish()
			}
		}
	}
}
