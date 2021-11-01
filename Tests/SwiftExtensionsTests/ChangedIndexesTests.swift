import XCTest
@testable import SwiftExtensions

final class ChangedIndexesTests: XCTestCase {
    func testLengthIncrease() {
        let previous = [1, 2, 3, 4, 5]
        let current = [1, 2, 3, 4, 5, 6, 7]
		
        let inserts = current.changedIndexes(previous: previous).inserts
        
        XCTAssertEqual([5, 6], inserts)
    }
    
    func testLengthDecrease() {
        let previous = [1, 2, 3, 4, 5, 6, 7]
        let current = [1, 2, 3, 4, 5]
        
        let deletes = current.changedIndexes(previous: previous).deletes
        
        XCTAssertEqual([5, 6], deletes)
    }
    
    func testElementChanges() {
        let previous = [1, 2, 3, 4, 5, 6, 7]
        let current = [1, 0, 3, 0, 5, 6, 7]
        
        let changes = current.changedIndexes(previous: previous).changes
        
        XCTAssertEqual([1, 3], changes)
    }
    
    func testMultiChanges() {
        let previous = [3, 2, 1]
        let current = [2, 2, 1, 4, 9]
        
        let changes = current.changedIndexes(previous: previous).changes
        let inserts = current.changedIndexes(previous: previous).inserts
        
        XCTAssertEqual([0], changes)
        XCTAssertEqual([3, 4], inserts)
    }
    
    func testNoChanges() {
        let previous = [1, 2, 3, 4, 5]
        let current = [1, 2, 3, 4, 5]
        
        let changes = current.changedIndexes(previous: previous).changes
        
        XCTAssertEqual([], changes)
    }
    
    func testEmpty() {
        let previous = [Int]()
        let current = [Int]()
        
        let changes = current.changedIndexes(previous: previous).changes
        
        XCTAssertEqual([], changes)
    }
    
    static var allTests = [
        ("testLengthIncrease", testLengthIncrease),
        ("testLengthDecrease", testLengthDecrease),
        ("testElementChanges", testElementChanges),
        ("testMultiChanges", testMultiChanges),
        ("testNoChanges", testNoChanges),
        ("testEmpty", testEmpty),
    ]
}
