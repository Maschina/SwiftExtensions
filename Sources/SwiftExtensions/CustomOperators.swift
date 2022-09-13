import Foundation

// MARK: <-??

infix operator <-?? : AssignmentPrecedence

// "assign non-nil values" operator
public func <-??<T>(target: inout T?, value: T?) {
    if let value = value {
        target = value
    }
}

// "assign non-nil values" operator
public func <-??<T>(target: inout T, value: T?) {
    if let value = value {
        target = value
    }
}

// MARK: ^^

infix operator ^^

// XOR comparison between boolean vars
public extension Bool {
    static func ^^(lhs:Bool, rhs:Bool) -> Bool {
        if (lhs && !rhs) || (!lhs && rhs) {
            return true
        }
        return false
    }
}


// MARK: ?==

infix operator ?== : AssignmentPrecedence

public func ?== <T: Equatable>(left: T?, right: T?) -> Bool {
	switch (left, right) {
		case let (l?, r?):
			return l == r
		case (nil, nil):
			return true
		case (nil, _?):
			return true
		case (_?, nil):
			return true
	}
}
