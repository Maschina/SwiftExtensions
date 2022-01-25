import Foundation

public struct Stack<Element> {
	fileprivate var array: [Element] = []
	fileprivate var maxElements: Int?
	
	public init(maxElements: Int? = nil) {
		self.maxElements = maxElements
	}
	
	public mutating func push(_ element: Element) {
		if let maxElements = maxElements, maxElements < array.count {
			array.removeFirst()
		}
		array.append(element)
	}
	
	@discardableResult
	public mutating func pop() -> Element? {
		return array.popLast()
	}
	
	public func peek() -> Element? {
		return array.last
	}
	
	public func peekpeek() -> Element? {
		return array[safe: array.count - 2]
	}
	
	public var isEmpty: Bool {
		return array.isEmpty
	}
	
	public var count: Int {
		return array.count
	}
}
