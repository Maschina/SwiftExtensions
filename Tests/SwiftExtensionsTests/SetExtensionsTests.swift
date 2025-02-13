import XCTest
@testable import SwiftExtensions
import Testing

struct SetExtensionTests {
	struct TestType: Hashable, Equatable {
		let id: Int
		let value: String
		
		func hash(into hasher: inout Hasher) {
			hasher.combine(id)
		}
		
		static func == (lhs: TestType, rhs: TestType) -> Bool {
			lhs.id == rhs.id
		}
	}
	
	@Test("Added element")
	func testChanges1() async throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet) { oldElement, newElement in
			oldElement.value == newElement.value
		}
		
		#expect(delta.removed.isEmpty, "Expected no elements to be removed, but found: \(delta.removed)")
		#expect(changes.isEmpty, "Expected no changes, but found: \(changes)")
		#expect(delta.added.contains(TestType(id: 3, value: "c")), "Expected added elements to contain TestType(id: 3, value: 'c'), but found: \(delta.added)")
	}
	
	@Test("Removed element")
	func testChanges2() async throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet) { oldElement, newElement in
			oldElement.value == newElement.value
		}
		
		#expect(changes.isEmpty, "Expected no changes, but found: \(changes)")
		#expect(delta.added.isEmpty, "Expected no elements to be added, but found: \(delta.added)")
		#expect(delta.removed.contains(TestType(id: 3, value: "c")), "Expected removed elements to contain TestType(id: 3, value: 'c'), but found: \(delta.removed)")
	}
	
	@Test("Changed value of one element")
	func testChanges3() async throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "d")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet) { oldElement, newElement in
			oldElement.value == newElement.value
		}
		
		#expect(delta.removed.isEmpty, "Expected no elements to be removed, but found: \(delta.removed)")
		#expect(delta.added.isEmpty, "Expected no elements to be added, but found: \(delta.added)")
		#expect(changes.contains(TestType(id: 3, value: "d")), "Expected changes to contain TestType(id: 3, value: 'd'), but found: \(changes)")
	}
	
	@Test("Changed hash/equatable (identifier) of one element")
	func testChanges4() async throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 4, value: "c")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet) { oldElement, newElement in
			oldElement.value == newElement.value
		}
		
		#expect(changes.isEmpty, "Expected no changes, but found: \(changes)")
		#expect(delta.added.contains(TestType(id: 4, value: "c")), "Expected added elements to contain TestType(id: 4, value: 'c'), but found: \(delta.added)")
		#expect(delta.removed.contains(TestType(id: 3, value: "c")), "Expected removed elements to contain TestType(id: 3, value: 'c'), but found: \(delta.removed)")
	}
	
	@Test("Added element to an empty set")
	func testChanges5() async throws {
		let oldSet: Set<TestType> = []
		let newSet: Set<TestType> = [TestType(id: 1, value: "a")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet) { oldElement, newElement in
			oldElement.value == newElement.value
		}
		
		#expect(delta.removed.isEmpty, "Expected no elements to be removed, but found: \(delta.removed)")
		#expect(changes.isEmpty, "Expected no changes, but found: \(changes)")
		#expect(delta.added.contains(TestType(id: 1, value: "a")), "Expected added elements to contain TestType(id: 1, value: 'a'), but found: \(delta.added)")
	}
	
	@Test
	func testChanges6() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { (oldElement, newElement) -> Bool in
			oldElement.value == newElement.value
		})
		
		#expect(delta.removed.isEmpty, "Result: \(delta.removed)")
		#expect(changes.isEmpty, "Result: \(changes)")
		#expect(delta.added.isEmpty, "Result: \(delta.added)")
	}
	
	@Test("No elementsEquatable given but value changed")
	func testChanges7() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "d")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { _,_ in return true })
		
		#expect(delta.removed.isEmpty, "Result: \(delta.removed)")
		#expect(changes.isEmpty, "Result: \(changes)")
		#expect(delta.added.isEmpty, "Result: \(delta.added)")
	}
	
	@Test("No elementsEquatable given but id changed")
	func testChanges8() throws {
		let oldSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 3, value: "c")]
		let newSet: Set<TestType> = [TestType(id: 1, value: "a"), TestType(id: 2, value: "b"), TestType(id: 4, value: "c")]
		
		let delta = newSet.diff(to: oldSet)
		let changes = newSet.compare(with: oldSet, elementsEquatable: { _,_ in return true })
		
		#expect(changes.isEmpty, "Result: \(changes)")
		#expect(delta.added.contains(TestType(id: 4, value: "c")), "Result: \(delta.added)")
		#expect(delta.removed.contains(TestType(id: 3, value: "c")), "Result: \(delta.removed)")
	}
	
	@Test("Test remove(where predicate: (Element) throws -> Bool) rethrows")
	func testRemoveWhere() throws {
		var set: Set<Int> = [1, 2, 3, 4, 5]
		set.remove(where: { $0 > 2 })
		
		#expect(set.count == 2)
		#expect(set == [1, 2])
	}
	
	@Test("Operator extension for +")
	func testOperatorExtensionPlus() {
		let set1: Set<Int> = [1, 2, 3, 4, 5]
		let set2: Set<Int> = [1, 2, 3, 4, 5]
		let set3: Set<Int> = [6, 7, 8]
		
		let union1 = set1 + set2
		#expect(union1.count == 5, "Should not count more than 5")
		
		let union2 = set1 + set3
		#expect(union2.count == 8, "Should not count more than 8")
	}
}
