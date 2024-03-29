// Copyright (C) 2023 Robert Hahn. All Rights Reserved.

import XCTest
import SwiftExtensions

final class ArraySubscriptTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testSubscriptOne() throws {
		let collection = [0, 1, 2, 3, 4, 5, 6, 7]
		let subsequence = try XCTUnwrap(collection[safe: 0 ..< 3], "subsequence == nil")
		XCTAssertEqual(subsequence.count, 3)
		XCTAssertEqual(subsequence.first, 0)
		XCTAssertEqual(subsequence.last, 2)
	}

	func testSubcriptUpperBoundOutOfRange() throws {
		let collection = [0, 1, 2, 3, 4, 5, 6, 7]
		let subsequence = try XCTUnwrap(collection[safe: 5 ... 9], "subsequence == nil")
		XCTAssertEqual(subsequence.count, 3)
		XCTAssertEqual(subsequence.first, 5)
		XCTAssertEqual(subsequence.last, 7)
	}
	
	func testSubcriptLowerAndUpperBoundOutOfRange() throws {
		let collection = [0, 1, 2, 3, 4, 5, 6, 7]
		let subsequence = try XCTUnwrap(collection[safe: -5 ... 9], "subsequence == nil")
		XCTAssertEqual(subsequence.count, 8)
		XCTAssertEqual(subsequence.first, 0)
		XCTAssertEqual(subsequence.last, 7)
	}
	
	func testSubscriptEmptyCollection() throws {
		let collection = [Int]()
		let subsequence = collection[safe: -5 ... 9]
		XCTAssertNil(subsequence, "subsequence != nil")
	}
	
	func testSubscriptSingleElementCollection() throws {
		let collection = [0]
		let subsequence = try XCTUnwrap(collection[safe: 0 ... 1], "subsequence == nil")
		XCTAssertEqual(subsequence.count, 1)
		XCTAssertEqual(subsequence.first, 0)
	}
}
