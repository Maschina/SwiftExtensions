//
//  ArrayTests.swift
//  SwiftExtensions
//
//  Created by Robert Hahn on 06.03.25.
//

import Testing
@testable import SwiftExtensions

@Suite("Array Tests")
struct ArrayTests {
	@Test("Form Union")
	func formUnion() {
		var array1: [Int] = []
		array1.formUnion([1, 2, 3])
		#expect(array1 == [1, 2, 3])
		
		var array2: [Int] = [1, 2]
		array2.formUnion([3])
		#expect(array2 == [1, 2, 3])
		
		var array3: [Int] = [1, 2, 3]
		array3.formUnion([1, 2, 3])
		#expect(array3 == [1, 2, 3])
		
		var array4: [Int] = []
		array4.formUnion([])
		#expect(array4 == [])
		
		var array5: [Int] = [1]
		array5.formUnion([])
		#expect(array5 == [1])
	}
	
	@Test("Form Unioned")
	func formUnioned() {
		var array1: [Int] = []
		array1 = array1.formUnioned([1, 2, 3])
		#expect(array1 == [1, 2, 3])
		
		var array2: [Int] = [1, 2]
		array2 = array2.formUnioned([3])
		
		var array3: [Int] = [1, 2, 3]
		array3 = array3.formUnioned([1, 2, 3])
		#expect(array3 == [1, 2, 3])
		
		var array4: [Int] = []
		array4 = array4.formUnioned([])
		#expect(array4 == [])
		
		var array5: [Int] = [1]
		array5 = array5.formUnioned([])
		#expect(array5 == [1])
	}
}
