// Copyright (C) 2023 Robert Hahn. All Rights Reserved.

import Foundation

extension NSSet {
	public func toArray<T>(of: T.Type) -> [T] {
		self.compactMap({ $0 as? T})
	}
}

extension Optional where Wrapped == NSSet {
	public func toArray<T: Hashable>(of: T.Type) -> [T] {
		if let set = self as? Set<T> {
			return Array(set)
		}
		return [T]()
	}
}
