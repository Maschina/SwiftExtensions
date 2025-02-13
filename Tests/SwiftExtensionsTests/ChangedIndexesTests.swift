import Testing
@testable import SwiftExtensions

@Suite("Changed Indexes Tests")
struct ChangedIndexesTests {
    @Test("Array length increases by adding elements")
    func lengthIncrease() {
        let previous = [1, 2, 3, 4, 5]
        let current = [1, 2, 3, 4, 5, 6, 7]
		
        let inserts = current.changedIndexes(previous: previous).inserts
        
        #expect(inserts == [5, 6])
    }
    
    @Test("Array length decreases by removing elements")
    func lengthDecrease() {
        let previous = [1, 2, 3, 4, 5, 6, 7]
        let current = [1, 2, 3, 4, 5]
        
        let deletes = current.changedIndexes(previous: previous).deletes
        
        #expect(deletes == [5, 6])
    }
    
    @Test("Detects changed elements at specific indexes")
    func elementChanges() {
        let previous = [1, 2, 3, 4, 5, 6, 7]
        let current = [1, 0, 3, 0, 5, 6, 7]
        
        let changes = current.changedIndexes(previous: previous).changes
        
        #expect(changes == [1, 3])
    }
    
    @Test("Handles multiple types of changes simultaneously")
    func multiChanges() {
        let previous = [3, 2, 1]
        let current = [2, 2, 1, 4, 9]
        
        let result = current.changedIndexes(previous: previous)
        
        #expect(result.changes == [0])
        #expect(result.inserts == [3, 4])
    }
    
    @Test("Returns empty changes for identical arrays")
    func noChanges() {
        let previous = [1, 2, 3, 4, 5]
        let current = [1, 2, 3, 4, 5]
        
        let changes = current.changedIndexes(previous: previous).changes
        
        #expect(changes.isEmpty)
    }
    
    @Test("Handles empty arrays correctly")
    func empty() {
        let previous = [Int]()
        let current = [Int]()
        
        let changes = current.changedIndexes(previous: previous).changes
        
        #expect(changes.isEmpty)
    }
}
