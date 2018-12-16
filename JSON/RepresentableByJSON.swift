import Foundation

public protocol RepresentableByJSON {}

extension Int: RepresentableByJSON {}
extension Double: RepresentableByJSON {}
extension String: RepresentableByJSON {}
extension Bool: RepresentableByJSON {}
extension Optional: RepresentableByJSON where Wrapped == JSON {}
extension Array: RepresentableByJSON where Element == JSON {}
extension Dictionary: RepresentableByJSON where Key == String, Value == JSON {}

public extension JSON {
    internal var value: RepresentableByJSON {
        switch self {
        case .int(let value):       return value
        case .double(let value):    return value
        case .bool(let value):      return value
        case .string(let value):    return value
        case .optional(let value):  return value
        case .array(let value):     return value
        case .object(let value):    return value
        }
    }
    
    public func getValue<T: RepresentableByJSON>() -> T {
        return value as! T
    }
}
