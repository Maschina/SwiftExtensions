//
//  Created by Robert Hahn on 31.12.24.
//

import SwiftUI

/// A custom SwiftUI view that simplifies error handling by conditionally rendering a success view or a failure view based on the result of a throwing function.
public struct DoCatch<Success: View, Failure: View>: View {
	private let result: Result<Success, Error>
	private let failureView: (Error) -> Failure
	
	/// Initializes a `DoCatch` view with a success view and a default failure view.
	///
	/// This initializer allows you to create a `DoCatch` view by providing only the success view closure.
	/// If an error is thrown while generating the success view, a default failure view displaying the error's localized description as text will be used.
	///
	/// - Parameters:
	///   - success: A throwing closure that generates the `Success` view if no error occurs.
	@available(iOS 13.0, macOS 10.15, *)
	public init(
		@ViewBuilder try success: () throws -> Success,
		@ViewBuilder catch failure: @escaping (Error) -> Failure
	) {
		self.result = Result(catching: success)
		self.failureView = failure
	}
	
	public var body: some View {
		switch result {
			case .success(let successView):
				successView
			case .failure(let error):
				failureView(error)
		}
	}
}

extension DoCatch where Failure == Text {
	
	/// Initializes a `DoCatch` view with a success view and a default text-based failure view.
	///
	/// This convenience initializer simplifies the creation of a `DoCatch` view when the failure case can be represented as a `Text` view.
	/// By providing only the success view closure, this initializer automatically generates a default failure view that displays the localized description of the error.
	///
	/// The localized description of the error is rendered using a `Text` view, making it suitable for basic error reporting without requiring custom failure handling.
	///
	/// - Parameters:
	///   - success: A throwing closure that generates the `Success` view if no error occurs.
	///     If the closure throws an error, the `Text` view displaying the error’s localized description will be shown instead.
	///
	/// # Example
	/// ```swift
	/// DoCatch {
	/// 	let foo = try bar()
	///     Text("This is the success view: \(foo)")
	/// }
	/// ```
	@available(iOS 13.0, macOS 10.15, *)
	public init(
		@ViewBuilder try success: () throws -> Success,
		failureText: @escaping (Error) -> LocalizedStringKey
	) {
		self.init(try: success, catch: { error in
			Text(failureText(error))
		})
	}
}

// MARK: Preview

fileprivate enum CustomError: Error {
	case foo(string: String)
}

fileprivate func failingFunction(fail: Bool) throws -> String {
	guard !fail else {
		throw CustomError.foo(string: "Failed")
	}
	
	return String("Success")
}

#Preview {
	DoCatch {
		let string = try failingFunction(fail: true)
		Text("\(string)")
	} failureText: { error in
		if let error = error as? CustomError {
			switch error {
				case .foo(let string):
					return LocalizedStringKey(string)
			}
		} else {
			return LocalizedStringKey(error.localizedDescription)
		}
	}
}
