//
//  CodableConversions.swift
//  JSON
//
//  Created by Robbie Moyer on 12/13/18.
//  Copyright © 2018 RoJoMo Studios. All rights reserved.
//

import Foundation

public extension JSON {
    public init?<T: Encodable>(from object: T) {
        guard let json: JSON = try? .from(object) else { return nil }
        self = json
    }
    
    public static func from<T: Encodable>(_ object: T) throws -> JSON {
        let encoded = try object.encoded()
        return try encoded.decoded()
    }
    
    public var data: Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        return (try? self.encoded(using: encoder)) ?? Data()
    }
}

public extension Decodable {
    public init?(from json: JSON) {
        guard let object: Self = try? .from(json) else { return nil }
        self = object
    }
    
    public static func from<T: Decodable>(_ json: JSON) throws -> T {
        let encoded = try json.encoded()
        return try encoded.decoded()
    }
}

public extension Data {
    public func toJSON() -> JSON? {
        return try? decoded()
    }
}
