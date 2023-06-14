// Copyright (C) 2023 Robert Hahn. All Rights Reserved.

import Foundation

extension NSPredicate {
	public func add(format: String, _ args: CVarArg...) -> NSPredicate {
		let addCandidate = NSPredicate(format: format, args)
		return NSCompoundPredicate(andPredicateWithSubpredicates: [self, addCandidate])
	}
}
