import XCTest
@testable import SwiftExtensions

final class SetExtensionTests: XCTestCase {
	struct TestType: Hashable, Equatable {
		let id: Int
		let value: String
		
		func hash(into hasher: inout Hasher) {
			hasher.combine(id)
		}
		
		static func == (lhs: TestType, rhs: TestType) -> Bool {
			guard lhs.id == rhs.id else { return false }
			return true
		}
	}

	/// Added element
    func testChanges1() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		
		let changes = newSet.changes(to: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(changes.removed.isEmpty, "Result: \(changes.removed)")
		XCTAssert(changes.changed.isEmpty, "Result: \(changes.changed)")
		XCTAssert(changes.added.contains(TestType(id: 3, value: "c")), "Result: \(changes.added)")
    }
	
	/// Removed element
	func testChanges2() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b")]
		
		let changes = newSet.changes(to: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(changes.changed.isEmpty, "Result: \(changes.changed)")
		XCTAssert(changes.added.isEmpty, "Result: \(changes.added)")
		XCTAssert(changes.removed.contains(TestType(id: 3, value: "c")), "Result: \(changes.removed)")
	}
	
	/// Changed value of one element
	func testChanges3() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "d")]
		
		let changes = newSet.changes(to: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(changes.removed.isEmpty, "Result: \(changes.removed)")
		XCTAssert(changes.added.isEmpty, "Result: \(changes.added)")
		XCTAssert(changes.changed.contains(TestType(id: 3, value: "d")), "Result: \(changes.changed)")
	}
	
	/// Changed hash/equatable (identifier) of one element
	func testChanges4() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 4, value: "c")]
		
		let changes = newSet.changes(to: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(changes.changed.isEmpty, "Result: \(changes.changed)")
		XCTAssert(changes.added.contains(TestType(id: 4, value: "c")), "Result: \(changes.added)")
		XCTAssert(changes.removed.contains(TestType(id: 3, value: "c")), "Result: \(changes.removed)")
	}
	
	/// Added element to an empty set
	func testChanges5() throws {
		let oldSet: Set<TestType> = []
		let newSet: Set<TestType> = [TestType(id: 1, value: "a")]
		
		let changes = newSet.changes(to: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(changes.removed.isEmpty, "Result: \(changes.removed)")
		XCTAssert(changes.changed.isEmpty, "Result: \(changes.changed)")
		XCTAssert(changes.added.contains(TestType(id: 1, value: "a")), "Result: \(changes.added)")
	}
	
	/// Nothing changed
	func testChanges6() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		
		let changes = newSet.changes(to: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(changes.removed.isEmpty, "Result: \(changes.removed)")
		XCTAssert(changes.changed.isEmpty, "Result: \(changes.changed)")
		XCTAssert(changes.added.isEmpty, "Result: \(changes.added)")
	}
	
	/// No elementsEquatable given but value changed
	func testChanges7() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "d")]
		
		let changes = newSet.changes(to: oldSet)
		
		XCTAssert(changes.removed.isEmpty, "Result: \(changes.removed)")
		XCTAssert(changes.changed.isEmpty, "Result: \(changes.changed)")
		XCTAssert(changes.added.isEmpty, "Result: \(changes.added)")
	}
	
	/// No elementsEquatable given but id changed
	func testChanges8() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 4, value: "c")]
		
		let changes = newSet.changes(to: oldSet)
		
		XCTAssert(changes.changed.isEmpty, "Result: \(changes.changed)")
		XCTAssert(changes.added.contains(TestType(id: 4, value: "c")), "Result: \(changes.added)")
		XCTAssert(changes.removed.contains(TestType(id: 3, value: "c")), "Result: \(changes.removed)")
	}
}
