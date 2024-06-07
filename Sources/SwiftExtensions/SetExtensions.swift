import Foundation

extension Set {
	/// Update (or insert new) element based on update conditions.
	///
	/// The regular update function relies on the Hash of the Set elements. This function provides the capabilty to assert different conditions. Updating means that the element will be removed before the given element is being inserted.
	/// - Parameters:
	///   - element: Element to be inserted or updated
	///   - predicate: Conditions of the element to be replaced. If conditions cannot be met, new element will be inserted only.
	public mutating func update(with element: Element, updateCondition predicate: (Element) throws -> Bool) rethrows {
		if let updateCandidate = try self.first(where: predicate) {
			self.remove(updateCandidate)
		}
		self.update(with: element)
	}
	
	/// Replace element based on conditions.
	///
	/// The regular update functions add the given element, if not yet present. This function only replaces (remove and insert), if the predicate is met.
	/// - Parameters:
	///   - element: Element to be replaced
	///   - predicate: Conditions of the element to be replaced. If conditions cannot be met, no action will be taken.
	public mutating func replace(with element: Element, onlyIf predicate: (Element) throws -> Bool) rethrows {
		if let updateCandidate = try self.first(where: predicate) {
			self.remove(updateCandidate)
			self.insert(element)
		}
	}
	
	/// Calculate the changes from the given set to the current
	/// - Parameters:
	///   - previous: The given set based on what you need to calculate the changes
	///   - elementsEquatable: Optional: Handler to define what has to be evaluated as "not changed", whereas the first parameter depicts an element from the current set and the second parameter depicts an element from the given (previous) set. Whenever this handler returns false for any pair that are equal (defined through `Equatable`), it will return the element from the current set as `changed`.
	/// - Returns: Tuple of calculated changes in the following order: `added`, `removed` and `changed`
	public func changes(to previous: Set<Element>, elementsEquatable: (_ current: Element, _ previous: Element) -> Bool = { _, _ in true }) -> (added: Set<Element>, removed: Set<Element>, changed: Set<Element>) {
		// Returns a new set containing the elements of this set that do not occur in the previous set.
		let added = self.subtracting(previous)
		// Returns a new set containing the elements of the previous set that do not occur in this set.
		let removed = previous.subtracting(self)
		
		var changed = Set<Element>()
		// Check for changes in elements that are present in both sets
		for oldElement in previous {
			for newElement in self {
				if !elementsEquatable(oldElement, newElement) && oldElement == newElement {
					changed.insert(newElement)
					break
				}
			}
		}
		
		return (added, removed, changed)
	}
	
	public func asyncFilter(_ validate: (Element) async throws -> Bool) async throws -> Set<Element> {
		var values = Set<Element>()
		
		for element in self {
			try Task.checkCancellation()
			if try await validate(element) {
				values.insert(element)
			}
		}
		
		return values
	}
}
