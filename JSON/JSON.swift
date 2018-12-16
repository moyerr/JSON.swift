import Foundation

@dynamicMemberLookup
public enum JSON {
    case int(Int)
    case double(Double)
    case bool(Bool)
    case string(String)
    
    indirect case optional(JSON?)
    indirect case array(Array<JSON>)
    indirect case object(Dictionary<String, JSON>)
}

public extension JSON {
    public subscript(dynamicMember member: String) -> JSON? {
        guard case .object(let dict) = self else { return nil }
        return dict[member]
    }
    
    public subscript(_ key: String) -> JSON? {
        guard case .object(let dict) = self else { return nil }
        return dict[key]
    }
    
    public subscript(_ index: Int) -> JSON? {
        guard case .array(let arr) = self else { return nil }
        guard arr.indices.contains(index) else { return nil }
        
        return arr[index]
    }
}
