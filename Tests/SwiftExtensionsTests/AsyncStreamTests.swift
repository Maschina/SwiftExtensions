//
//  AsyncStreamTests.swift
//  
//
//  Created by Robert Hahn on 31.05.24.
//

import XCTest

final class AsyncStreamTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
    func testWithPrevious1() async throws {
		let array = [1, 2, 3, 4, 5, 6]
		let stream = AsyncStream { continuation in
			for element in array {
				continuation.yield(element)
			}
			continuation.finish()
		}
		
		for await (previous, current) in stream.withPrevious(initialPreviousValue: 0) {
			XCTAssert(current - 1 == previous)
		}
    }
	
	func testWithPrevious2() async throws {
		let array = Array(repeating: 1, count: 10)
		let stream = AsyncStream { continuation in
			for element in array {
				continuation.yield(element)
			}
			continuation.finish()
		}
		
		for await (previous, current) in stream.withPrevious() {
			guard let previous else { continue }
			XCTAssert(current == previous)
		}
	}
}
