import Foundation

public extension JSON {
    public func traverse(_ body: @escaping (JSON) throws -> Void) rethrows {
        try body(self)
        
        switch self {
        case .array(let array):
            try array.forEach { json in
                try json.traverse(body)
            }
        case .object(let dict):
            try dict.forEach { _, json in
                try json.traverse(body)
            }
        case .optional(let opt):
            if let value = opt {
                try value.traverse(body)
            }
        default:    break
        }
    }
    
    public func map<T>(_ transform: @escaping (JSON) throws -> T) rethrows -> [T] {
        var array = [T]()
        
        try traverse { array.append(try transform($0)) }
        
        return array
    }
    
    public func compactMap<T>(_ transform: @escaping (JSON) throws -> T?) rethrows -> [T] {
        var array = [T]()
        
        try traverse { json in
            guard let unwrapped = try transform(json) else { return }
            array.append(unwrapped)
        }
        
        return array
    }
    
    public func reduce<Result>(into initialResult: Result,
                               _ updateAccumulatingResult: @escaping (inout Result, JSON) throws -> ())
        rethrows -> Result {
        
        var updatingResult = initialResult
        try traverse { json in
            try updateAccumulatingResult(&updatingResult, json)
        }
        return updatingResult
    }
}
