import Foundation

extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension Array where Element: Equatable {
    @discardableResult
    public mutating func append(ifNew element: Element) -> (appended: Bool, memberAfterAppend: Element) {
        if let index = firstIndex(of: element) {
            return (false, self[index])
        } else {
            append(element)
            return (true, element)
        }
    }
    
    public func appended(ifNew element: Element) -> [Element] {
        if contains(element) {
            return self
        } else {
            var result = self
            result.append(element)
            return result
        }
    }
    
    public func appended(element: Element) -> [Element] {
        var result = self
        result.append(element)
        return result
    }
    
    public func appended(contentsOf newElements: [Element]) -> [Element] {
        var result = self
        result.append(contentsOf: newElements)
        return result
    }
}


extension Array {
    /// Creates strings out of every element based on a given stringifier function.
    /// - Parameter stringifier: Function to stringify the array element
    public func stringify(stringifier: @escaping (_ collection: Element) -> String) -> [String] {
        var strings = [String]()
        self.forEach { strings.append(stringifier($0)) }
        return strings
    }
    
    /// Get a sorted index within an array for a new element to add
    /// - Parameters:
    ///   - elem: Element to add
    ///   - sortedBy: Order function
    /// - Returns: Insertion index
    public func insertIndex(elem: Element, sortedBy: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if sortedBy(self[mid], elem) {
                lo = mid + 1
            } else if sortedBy(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
    
    /// Insert element into an sorted array and return the insertion index
    /// - Parameters:
    ///   - elem: Element to add
    ///   - sortedBy: Order function
    /// - Returns: Insertion index
    @discardableResult
    public mutating func insertedIndex(elem: Element, sortedBy: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if sortedBy(self[mid], elem) {
                lo = mid + 1
            } else if sortedBy(elem, self[mid]) {
                hi = mid - 1
            } else {
                self.insert(elem, safe: mid)
                return mid // found at position mid
            }
        }
        self.insert(elem, safe: lo)
        return lo // not found, would be inserted at position lo
    }
    
    /// Inserts element into array and returns the index used for insert process. If the index is beyond the range of the array, this function will automatically determine the max index for insertion.
    /// - Parameters:
    ///   - newElement: Element to be inserted
    ///   - idx: Required position
    /// - Returns: Insert index
    @discardableResult
    public mutating func insert(_ newElement: Self.Element, safe idx: Self.Index) -> Int {
        let insertIdx = Swift.min(count, idx)
        insert(newElement, at: insertIdx)
        return insertIdx
    }
    
    /// Safely removes an element from array by given index
    /// - Parameter index: Given index
    /// - Returns: The removed element
    @discardableResult
    public mutating func remove(safe index: Index) -> Element? {
        if indices.contains(index) { return remove(at: index) }
        return nil
    }
    
    /// Repeat popLast() for k times, which is similar to remove last k elements and return them.
    /// - Parameter k: Number of last elements
    /// - Returns: Removed elements
    public mutating func popLast(_ k: Int) -> [Element] {
        var returningArray = [Element]()
        for _ in 0..<k {
            if let last = self.popLast() {
                returningArray.append(last)
            }
        }
        return returningArray
    }
}


extension Array where Element: Equatable {
    /// Safely removes the element by previously checking if the element exists
    /// - Parameter input: Element to remove
    @discardableResult
    public mutating func removeSafely(element: Element) -> Element? {
        guard let index = firstIndex(of: element) else { return nil }
        return remove(safe: index)
    }
    
    @discardableResult
    public mutating func removeSafely(where closure: (Element) -> Bool) -> Element? {
        guard let index = firstIndex(where: closure) else { return nil }
        return remove(safe: index)
    }
    
    public mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
    
    /// Compares the array with a previous version and returns a index path to indicate the differences
    /// - Parameter previous: Previous version of the current array
    /// - Returns: Index path to indicate the differences
    public func changedIndexes(previous: [Element]) -> (changes: IndexPath, inserts: IndexPath, deletes: IndexPath) {
        let changes = zip(self, previous).enumerated().reduce([]) { $1.element.0 == $1.element.1 ? $0 : $0 + [$1.offset] }
        let lenChanges = IndexPath(indexes: Swift.min(self.count, previous.count)..<Swift.max(self.count, previous.count))
        let inserts = self.count > previous.count ? lenChanges : []
        let deletes = self.count < previous.count ? lenChanges : []
        return (changes: changes, inserts: inserts, deletes: deletes)
    }
}


extension Array where Element: Hashable {
    public func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    public mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
    
    public func uniqueElements() -> (uniques: [Element], filtered: [Int]) {
        var uniques = [Element]()
        var filtered = [Int]()
        for (index, element) in self.enumerated() {
            guard !uniques.contains(element) else {
                filtered.append(index)
                continue
            }
            uniques.append(element)
        }
        return (uniques: uniques, filtered: filtered)
    }
    
    public mutating func remove(indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            self.remove(safe: index)
        }
    }
    
    public func dictionize<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key: Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
