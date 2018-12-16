import Foundation

public extension String {
    public init(json: JSON) {
        self = json.string
    }
}

extension JSON: CustomStringConvertible {
    public var string: String {
        return generateJsonString()
    }
    
    public var description: String {
        return string
    }
}

fileprivate extension JSON {
    private func generateJsonString(previousDepth: Int = 0) -> String {
        var currentString = ""
        var depth = previousDepth
        
        switch self {
        case .int(let value):
            currentString += "\(value)"
        case .double(let value):
            currentString += "\(value)"
        case .bool(let value):
            currentString += "\(value)"
        case .string(let value):
            currentString += "\"\(value)\""
        case .optional(let opt):
            if let value = opt {
                currentString += value.generateJsonString(previousDepth: depth)
            } else {
                currentString += "null"
            }
        case .array(let array):
            currentString += "[\n"
            depth += 1
            
            for (index, item) in array.enumerated() {
                currentString += .repeat("\t", count: depth) +
                    item.generateJsonString(previousDepth: depth)
                
                if index != array.index(before: array.endIndex) {
                    currentString += ",\n"
                } else {
                    currentString += "\n"
                }
            }
            
            depth -= 1
            currentString += .repeat("\t", count: depth) + "]"
        case .object(let dict):
            currentString += "{\n"
            depth += 1
            
            for (key, value) in dict {
                currentString +=
                    .repeat("\t", count: depth) +
                    "\"\(key)\"" + ": " + value.generateJsonString(previousDepth: depth) + ",\n"
            }
            
            // remove the last comma and newline
            let secondToLast = currentString.index(currentString.endIndex, offsetBy: -2)
            currentString.removeSubrange(secondToLast..<currentString.endIndex)
            
            depth -= 1
            currentString += "\n" + .repeat("\t", count: depth) + "}"
        }
        
        return currentString
    }
}

fileprivate extension String {
    static func `repeat`(_ character: Character, count: Int) -> String {
        return String(repeating: character, count: count)
    }
}
