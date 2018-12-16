import Foundation

internal protocol AnyEncoder {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

internal protocol AnyDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONEncoder: AnyEncoder {}
extension JSONDecoder: AnyDecoder {}
extension PropertyListEncoder: AnyEncoder {}
extension PropertyListDecoder: AnyDecoder {}
