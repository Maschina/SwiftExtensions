import Foundation
import Combine

@available(OSX 10.15, *)
extension Publisher {
    public var erased: AnyPublisher<Output, Failure> { eraseToAnyPublisher() }
}

@available(OSX 10.15, *)
public extension Publisher {
    /// Creates a new publisher which will upon failure retry the upstream publisher a provided number of times, with the provided delay between retry attempts.
    ///
    /// - Parameters:
    ///   - retries: The number of times to retry the upstream publisher.
    ///   - delay: Delay in seconds between retry attempts.
    ///   - scheduler: The scheduler to dispatch the delayed events.
    ///   - intercall: Callback function that can be optionally executed after each retry
    /// - Returns: A new publisher which will retry the upstream publisher with a delay upon failure.
    ///
    /// If the upstream publisher succeeds the first time this is bypassed and proceeds as normal.
    /// - Example: *Retry 4 times with delay of 5 seconds before finally fail*
    /// ~~~
    /// let url = URL(string: "https://api.myService.com")!
    ///
    /// URLSession.shared.dataTaskPublisher(for: url)
    ///     .retryWithDelay(retries: 4, delay: 5, scheduler: DispatchQueue.global())
    ///     .sink { completion in
    ///         switch completion {
    ///             case .finished:
    ///                 print("Success 😊")
    ///             case .failure(let error):
    ///                 print("The last and final failure after retry attempts: \(error)")
    ///         }
    ///     } receiveValue: { output in
    ///         print("Received value: \(output)")
    ///     }
    ///     .store(in: &cancellables)
    /// ~~~
    func retryWithDelay<S>(retries: Int, delay: S.SchedulerTimeType.Stride, scheduler: S, intercall: (() -> ())? = nil) -> AnyPublisher<Output, Failure> where S: Scheduler {
        self
            .catch { (error) -> Future<Output, Failure> in
                intercall?()
                return Future { completion in
                    scheduler.schedule(after: scheduler.now.advanced(by: delay)) {
                        return completion(.failure(error))
                    }
                }
            }
            .retry(retries)
            .erased
    }
}

@available(macOS 10.15, *)
public extension Publisher {
	/// Freely call any non-throwing async function within a Combine pipeline
	/// - Returns: Continued publisher stream
	func asyncMap<T>(_ transform: @escaping (Self.Output) async -> T) -> Publishers.FlatMap<Future<T, Never>, Self> {
		flatMap { value in
			Future { promise in
				Task {
					let output = await transform(value)
					promise(.success(output))
				}
			}
		}
	}
	
	/// Attaches a concurrent Task-driven subscriber with closure-based behavior.
	/// - parameter receiveComplete: The closure to execute on completion.
	/// - parameter receiveValue: The closure to be awaited to execute within a concurrent Task on receipt of a value.
	/// - Returns: A cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
	func sink<T>(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void), receiveValue: @escaping ((Self.Output) async -> T)) -> AnyCancellable {
		sink { completion in
			receiveCompletion(completion)
		} receiveValue: { value in
			Task {
				await receiveValue(value)
			}
		}
	}
	
	/// Attaches a concurrent Task-driven subscriber with closure-based behavior.
	/// - parameter receiveComplete: The closure to be awaited to execute within a concurrent Task on completion.
	/// - parameter receiveValue: The closure to be awaited to execute within a concurrent Task on receipt of a value.
	/// - Returns: A cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
	func sink<T>(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) async -> Void), receiveValue: @escaping ((Self.Output) async -> T)) -> AnyCancellable {
		sink { completion in
			Task {
				await receiveCompletion(completion)
			}
		} receiveValue: { value in
			Task {
				await receiveValue(value)
			}
		}
		
	}
	
	/// Performs the specified closures when publisher events occur.
	/// - Parameters:
	///   - receiveOutput: An optional closure to be awaited to execute within a concurrent Task when the publisher receives a value from the upstream publisher. This value defaults to `nil`.
	func handleReceivedOutputEvent(_ receiveOutput: @escaping ((Self.Output) async -> Void)) -> Publishers.HandleEvents<Self> {
		handleEvents(receiveOutput: { output in
			Task {
				await receiveOutput(output)
			}
		})
	}
}

@available(macOS 10.15, *)
public extension Publisher where Self.Failure == Never {
	/// Attaches a concurrent Task-driven subscriber with closure-based behavior to a publisher that never fails.
	/// - parameter receiveValue: The closure to be awaited to execute within a concurrent Task on receipt of a value.
	/// - Returns: A cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
	func sink<T>(receiveValue: @escaping (Self.Output) async -> T) -> AnyCancellable {
		sink { value in
			Task {
				await receiveValue(value)
			}
		}
	}
}

public struct PublisherChange<Value> {
	public var old: Value?
	public var new: Value
}

@available(macOS 10.15, *)
public extension Publisher {
	func change() -> Publishers.Map<Publishers.Scan<Self, (Optional<Self.Output>, Optional<Self.Output>)>, PublisherChange<Self.Output>> {
		return self
			.scan((Output?.none, Output?.none)) { (state, new) in
				(state.1, .some(new))
			}
			.map { (old, new) in
				PublisherChange(old: old, new: new!)
			}
	}
}
