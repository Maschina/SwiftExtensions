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
	
	/// Update element based on update handler that matches to a given predicate.
	///
	/// The regular update function relies on the Hash of the Set elements. This function provides the capabilty to assert different conditions. Update is being handled through the update handler. If predicate fails, there will be no update being applied.
	/// - Parameters:
	///   - updateHandler: Element to be inserted or updated
	///   - predicate: Conditions of the element to be replaced. If conditions cannot be met, new element will be inserted only.
	public mutating func update(
		with updateHandler: (Element) -> Void,
		matching predicate: (Element) throws -> Bool
	) rethrows {
		if let existingElement = try self.first(where: predicate) {
			updateHandler(existingElement)
		}
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
