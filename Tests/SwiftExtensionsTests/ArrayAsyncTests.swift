// Copyright (C) 2023 Robert Hahn. All Rights Reserved.

import XCTest
import SwiftExtensions

final class ArrayAsyncTests: XCTestCase {
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testAsyncAllSatisfy1() async throws {
		let collection = [0, 1, 2, 3, 4, 5, 6, 7]
		
		let result = try await collection.asyncAllSatisfy { value in
			try await asyncProcessingSmaller10(value)
		}
		
		XCTAssertTrue(result)
	}
	
	func testAsyncAllSatisfy2() async throws {
		let collection = [0, 1, 2, 3, 4, 5, 6, 7]
		
		let result = try await collection.asyncAllSatisfy { value in
			try await asyncProcessingSmaller5(value)
		}
		
		XCTAssertFalse(result)
	}
}

extension ArrayAsyncTests {
	func asyncProcessingSmaller10(_ value: Int) async throws -> Bool {
		try await Task.sleep(milliseconds: 50)
		return value < 10
	}
	
	func asyncProcessingSmaller5(_ value: Int) async throws -> Bool {
		try await Task.sleep(milliseconds: 50)
		return value < 5
	}
}
