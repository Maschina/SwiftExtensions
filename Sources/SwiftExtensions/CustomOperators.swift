import Foundation


infix operator <-?? : AssignmentPrecedence

// "assign non-nil values" operator
func <-??<T>(target: inout T?, value: T?) {
    if let value = value {
        target = value
    }
}

// "assign non-nil values" operator
func <-??<T>(target: inout T, value: T?) {
    if let value = value {
        target = value
    }
}


infix operator ^^

// XOR comparison between boolean vars
extension Bool {
    static func ^^(lhs:Bool, rhs:Bool) -> Bool {
        if (lhs && !rhs) || (!lhs && rhs) {
            return true
        }
        return false
    }
}
