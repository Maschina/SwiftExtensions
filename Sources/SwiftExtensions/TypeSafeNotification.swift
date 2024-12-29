//
//  TypeSafeNotification.swift
//  SwiftExtensions
//

import SwiftUI
import Combine

/// Native Notifications that support type-safety.
///
///
/// # Define custom notification
/// Extend `TypeSafeNotification`  and define a new static like this:
///
/// `static var customNotification: TypeSafeNotification<...> { .init(name: .init(#function)) }`
///
///
/// # Post notification
/// `NotificationCenter.default.post(.customNotiication, data: ...)`
///
///
/// # Observe notifications
/// `NotificationCenter.default.addObserver(for: .customNotification, ...)`
public struct TypeSafeNotification<T: Sendable>: Sendable {
	public let name: NSNotification.Name
}

public enum NotificationData<T: Sendable>: Sendable {
	case some(T)
	case void
}

extension NotificationCenter {
	/// Creates a given notification with a type-safe parameter to the notification center.
	/// - Parameters:
	///   - notification: Pre-defined notification with the respective type
	///   - data: Type-safe data to be sent with the notification
	public func post<T: Sendable>(_ notification: TypeSafeNotification<T>, data: T) {
		Task.detached { @MainActor [weak self, data] in
			self?.post(name: notification.name, object: nil, userInfo: ["_notificationData": NotificationData.some(data)])
		}
	}
	
	public func post(_ notification: TypeSafeNotification<Void>) {
		Task.detached { @MainActor [weak self] in
			self?.post(name: notification.name, object: nil, userInfo: ["_notificationData": NotificationData<Void>.void])
		}
	}
	
	public func addObserver<T: Sendable>(for notification: TypeSafeNotification<T>, queue: OperationQueue? = .main, using block: @Sendable @escaping (T) -> Void) -> NotificationDisposer {
		let token = addObserver(forName: notification.name, object: nil, queue: queue) { n in
			if let data = n.userInfo?["_notificationData"] as? NotificationData<T> {
				switch data {
					case .some(let value):
						block(value)
					case .void:
						break // Do nothing for void notifications
				}
			}
		}
		
		return NotificationDisposer(tokens: [token], center: self)
	}
	
	public func addObserver(for notification: TypeSafeNotification<Void>, queue: OperationQueue? = .main, using block: @Sendable @escaping () -> Void) -> NotificationDisposer {
		let token = addObserver(forName: notification.name, object: nil, queue: queue) { _ in
			block()
		}
		
		return NotificationDisposer(tokens: [token], center: self)
	}
	
	public func notifications<T>(for notification: TypeSafeNotification<T>) -> AsyncStream<T> {
		AsyncStream { continuation in
			let task = Task {
				for await n in NotificationCenter.default.notifications(named: notification.name) {
					if let data = n.userInfo?["_notificationData"] as? NotificationData<T> {
						switch data {
							case .some(let value):
								continuation.yield(value)
							case .void:
								break // Do nothing for void notifications
						}
					}
				}
			}
			
			continuation.onTermination = { _ in
				task.cancel()
			}
		}
	}
	
	public func notifications(for notification: TypeSafeNotification<Void>) -> AsyncStream<Void> {
		AsyncStream { continuation in
			let task = Task {
				for await _ in NotificationCenter.default.notifications(named: notification.name) {
					continuation.yield()
				}
			}
			
			continuation.onTermination = { _ in
				task.cancel()
			}
		}
	}
}

extension View {
	/// Adds an action with type-safe payload to perform when this view detects data emitted by the given publisher.
	/// - Parameters:
	///   - notification: The notification to subscribe to.
	///   - block: The action to perform when an event is emitted by publisher. The event's type-safed parameter is passed to the closure.
	/// - Returns: A view that triggers action when publisher emits an event.
	public func onReceive<T>(for notification: TypeSafeNotification<T>, perform block: @escaping (T) -> Void) -> some View {
		self.onReceive(NotificationCenter.default.publisher(for: notification.name)) { output in
			if let data = output.userInfo?["_notificationData"] as? NotificationData<T> {
				switch data {
					case .some(let value):
						block(value)
					case .void:
						break // Do nothing for void notifications
				}
			}
		}
	}
	
	public func onReceive(for notification: TypeSafeNotification<Void>, perform block: @escaping () -> Void) -> some View {
		self.onReceive(NotificationCenter.default.publisher(for: notification.name)) { _ in
			block()
		}
	}
}

public class NotificationDisposer: Cancellable {
	private var tokens: [any NSObjectProtocol] = []
	private let center: NotificationCenter
	
	init(tokens: [any NSObjectProtocol], center: NotificationCenter) {
		self.tokens = tokens
		self.center = center
	}
	
	func addToken(_ token: any NSObjectProtocol) {
		tokens.append(token)
	}
	
	deinit {
		cancel()
	}
	
	public func cancel() {
		tokens.forEach { center.removeObserver($0) }
		tokens.removeAll()
	}
}

// Extend AnyCancellable to store multiple tokens
extension AnyCancellable {
	public func store(in token: NotificationDisposer) {
		token.addToken(self as! (any NSObjectProtocol))
	}
}
