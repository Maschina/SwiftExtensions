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
}
