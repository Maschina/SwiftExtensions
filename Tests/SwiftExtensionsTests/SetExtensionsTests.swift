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
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(delta.removed.isEmpty, "Result: \(delta.removed)")
		XCTAssert(changes.isEmpty, "Result: \(changes)")
		XCTAssert(delta.added.contains(TestType(id: 3, value: "c")), "Result: \(delta.added)")
    }
	
	/// Removed element
	func testChanges2() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(changes.isEmpty, "Result: \(changes)")
		XCTAssert(delta.added.isEmpty, "Result: \(delta.added)")
		XCTAssert(delta.removed.contains(TestType(id: 3, value: "c")), "Result: \(delta.removed)")
	}
	
	/// Changed value of one element
	func testChanges3() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "d")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(delta.removed.isEmpty, "Result: \(delta.removed)")
		XCTAssert(delta.added.isEmpty, "Result: \(delta.added)")
		XCTAssert(changes.contains(TestType(id: 3, value: "d")), "Result: \(changes)")
	}
	
	/// Changed hash/equatable (identifier) of one element
	func testChanges4() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 4, value: "c")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(changes.isEmpty, "Result: \(changes)")
		XCTAssert(delta.added.contains(TestType(id: 4, value: "c")), "Result: \(delta.added)")
		XCTAssert(delta.removed.contains(TestType(id: 3, value: "c")), "Result: \(delta.removed)")
	}
	
	/// Added element to an empty set
	func testChanges5() throws {
		let oldSet: Set<TestType> = []
		let newSet: Set<TestType> = [TestType(id: 1, value: "a")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(delta.removed.isEmpty, "Result: \(delta.removed)")
		XCTAssert(changes.isEmpty, "Result: \(changes)")
		XCTAssert(delta.added.contains(TestType(id: 1, value: "a")), "Result: \(delta.added)")
	}
	
	/// Nothing changed
	func testChanges6() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		XCTAssert(delta.removed.isEmpty, "Result: \(delta.removed)")
		XCTAssert(changes.isEmpty, "Result: \(changes)")
		XCTAssert(delta.added.isEmpty, "Result: \(delta.added)")
	}
	
	/// No elementsEquatable given but value changed
	func testChanges7() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "d")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { _,_ in return true })
		
		XCTAssert(delta.removed.isEmpty, "Result: \(delta.removed)")
		XCTAssert(changes.isEmpty, "Result: \(changes)")
		XCTAssert(delta.added.isEmpty, "Result: \(delta.added)")
	}
	
	/// No elementsEquatable given but id changed
	func testChanges8() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 4, value: "c")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { _,_ in return true })
		
		XCTAssert(changes.isEmpty, "Result: \(changes)")
		XCTAssert(delta.added.contains(TestType(id: 4, value: "c")), "Result: \(delta.added)")
		XCTAssert(delta.removed.contains(TestType(id: 3, value: "c")), "Result: \(delta.removed)")
	}
}
