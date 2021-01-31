import Foundation
import Combine

@available(OSX 10.15, *)
extension Publisher {
    var erased: AnyPublisher<Output, Failure> { eraseToAnyPublisher() }
}
