import XCTest
@testable import SwiftExtensions

final class OptionalOperatorsTests: XCTestCase {
    func testOperatorAssignNilToNonNil() {
        var target: String = "target"
        let source: String? = nil
        
        target <-?? source
        
        XCTAssertEqual(target, "target")
    }
    
    func testOperatorAssignNonNilToNonNil() {
        var target: String = "target"
        let source: String? = "source"
        
        target <-?? source
        
        XCTAssertEqual(target, "source")
    }
    
    func testOperatorAssignNilToNil() {
        var target: String? = nil
        let source: String? = nil
        
        target <-?? source
        
        XCTAssertNil(target)
    }
    
    func testOperatorAssignNonNilToNil() {
        var target: String? = nil
        let source: String? = "source"
        
        target <-?? source
        
        XCTAssertEqual(target, "source")
    }
    
    static var allTests = [
        ("testOperatorAssignNilToNonNil", testOperatorAssignNilToNonNil),
        ("testOperatorAssignNonNilToNonNil", testOperatorAssignNonNilToNonNil),
        ("testOperatorAssignNilToNil", testOperatorAssignNilToNil),
        ("testOperatorAssignNonNilToNil", testOperatorAssignNonNilToNil)
    ]
}
