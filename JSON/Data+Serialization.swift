//
//  Data+Serialization.swift
//  JSON
//
//  Created by Robbie Moyer on 12/14/18.
//  Copyright © 2018 RoJoMo Studios. All rights reserved.
//

import Foundation

internal extension Data {
    func decoded<T: Decodable>(using decoder: AnyDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}

internal extension Encodable {
    func encoded(using encoder: AnyEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}
