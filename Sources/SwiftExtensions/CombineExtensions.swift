import Foundation
import Combine

@available(OSX 10.15, *)
extension Publisher {
    public var erased: AnyPublisher<Output, Failure> { eraseToAnyPublisher() }
}
