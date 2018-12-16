import Foundation

extension JSON: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    public init(integerLiteral value: JSON.IntegerLiteralType) {
        self = .int(value)
    }
}

extension JSON: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    public init(floatLiteral value: JSON.FloatLiteralType) {
        self = .double(value)
    }
}

extension JSON: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = Bool
    public init(booleanLiteral value: JSON.BooleanLiteralType) {
        self = .bool(value)
    }
}

extension JSON: ExpressibleByNilLiteral {
    public init(nilLiteral: Void) {
        self = .optional(nil)
    }
}

extension JSON: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: JSON.StringLiteralType) {
        self = .string(value)
    }
}

extension JSON: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = JSON
    public init(arrayLiteral elements: JSON.ArrayLiteralElement...) {
        self = .array(elements)
    }
}

extension JSON: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = JSON
    public init(dictionaryLiteral elements: (JSON.Key, JSON.Value)...) {
        self = .object(Dictionary(uniqueKeysWithValues: elements))
    }
}
