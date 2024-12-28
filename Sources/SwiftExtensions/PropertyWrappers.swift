//
//  Clamp.swift
//  SwiftExtensions
//
//  Created by Robert Hahn on 20.10.24.
//


import Foundation
import Combine

@propertyWrapper
public struct Clamp<V: Comparable & Codable & Hashable & Sendable>: Codable, Hashable, Sendable {
    var value: V
    let range: ClosedRange<V>
	let precision: Int?
    
	public init(wrappedValue value: V, _ range: ClosedRange<V>, precision: Int? = nil) {
        self.range = range
		self.value = min(max(range.lowerBound, value), range.upperBound)
		self.precision = precision
    }
    
	public var wrappedValue: V {
        get { value }
		set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}

@propertyWrapper
public struct ClampFrom<V: Comparable & Codable & Hashable & Sendable>: Codable, Hashable, Sendable {
	public static func == (lhs: ClampFrom<V>, rhs: ClampFrom<V>) -> Bool {
		lhs.hashValue == rhs.hashValue
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.value)
	}
	
	var value: V
	let range: PartialRangeFrom<V>
	let precision: Int?
	
	public init(wrappedValue value: V, _ range: PartialRangeFrom<V>, precision: Int? = nil) {
		self.range = range
		self.value = max(range.lowerBound, value)
		self.precision = precision
	}
	
	public var wrappedValue: V {
		get { value }
		set { value = max(range.lowerBound, newValue) }
	}
}

/// Trigger boolean that can be set to true and will automatically be set back to false after read
@propertyWrapper
public struct FlipBackTrigger {
	var value: Bool = false
	
	public var wrappedValue: Bool {
		mutating get {
			let storage = value
			value = false
			return storage
		}
		
		set {
			value = newValue
		}
	}
	
	public init(wrappedValue: Bool) {
		self.wrappedValue = wrappedValue
	}
}

@propertyWrapper
public class DelayedResetBool {
	@Published private var value: Bool
	private let delay: TimeInterval
	private var cancellable: AnyCancellable?
	
	public init(wrappedValue: Bool, delay: TimeInterval = 2.0) {
		self.value = wrappedValue
		self.delay = delay
	}
	
	public var wrappedValue: Bool {
		get {
			return value
		}
		set(newValue) {
			if newValue == false {
				cancellable?.cancel()
				cancellable = Just(()).delay(for: .seconds(delay), scheduler: RunLoop.main)
					.sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
						self?.value = false
					})
			} else {
				self.value = true
			}
		}
	}
}

@propertyWrapper
public struct Debouncer<Value> {
	private var value: Value {
		willSet {
			self.publisher.subject.send(newValue)
		}
	}
	
	private let debounce: TimeInterval
	private var lastChange = Date(timeIntervalSince1970: 0)
	
	private var publisher: Publisher
	public struct Publisher: Combine.Publisher {
		public typealias Output = Value
		public typealias Failure = Never
		var subject: CurrentValueSubject<Value, Never> // PassthroughSubject will lack the call of initial assignment
		public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
			subject.subscribe(subscriber)
		}
		init(_ output: Output) {
			subject = .init(output)
		}
	}
	
	public init(wrappedValue: Value, debounce: TimeInterval = 2.0) {
		self.value = wrappedValue
		self.debounce = debounce
		self.publisher = Publisher(wrappedValue)
	}
	
	public static subscript<OuterSelf: ObservableObject>(
		_enclosingInstance observed: OuterSelf,
		wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, Value>,
		storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
	) -> Value {
		get {
			observed[keyPath: storageKeyPath].wrappedValue
		}
		set {
			if let subject = observed.objectWillChange as? ObservableObjectPublisher {
				subject.send() // Before modifying wrappedValue
				observed[keyPath: storageKeyPath].wrappedValue = newValue
			}
		}
	}
	
	public var wrappedValue: Value {
		get {
			value
		}
		set {
			// Update the color if more than 2 seconds have passed since the last color change,
			// or if there has been no color change recorded yet.
			if Date().timeIntervalSince(self.lastChange) > self.debounce {
				self.value = newValue
			}
		}
	}
	
	public var projectedValue: Publisher {
		self.publisher
	}
	
	mutating func bypassing(_ value: Value) {
		self.value = value
		self.lastChange = Date()
	}
}
