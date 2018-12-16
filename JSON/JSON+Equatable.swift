import Foundation

extension JSON: Equatable {
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case let (.int(lValue), .int(rValue)):
            return lValue == rValue
        case let (.double(lValue), .double(rValue)):
            return lValue == rValue
        case let (.bool(lValue), .bool(rValue)):
            return lValue == rValue
        case let (.string(lValue), .string(rValue)):
            return lValue == rValue
        case let (.optional(lValue), .optional(rValue)):
            return lValue == rValue
        case let (.array(lValue), .array(rValue)):
            return lValue == rValue
        case let (.object(lValue), .object(rValue)):
            return lValue == rValue
        default:
            return false
        }
    }
}
