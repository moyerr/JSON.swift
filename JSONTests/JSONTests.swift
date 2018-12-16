import XCTest
@testable import JSON

class JSONTests: XCTestCase {
    
    // MARK: - Internal types
    private struct SubObject: Codable, Equatable {
        let anotherString: String
        let anotherInt: Int
    }
    
    private struct SomeObject: Codable, Equatable {
        let someString: String
        let someOptional: String?
        let someInt: Int
        let someDouble: Double
        let someBool: Bool
        let someArray: [SubObject]
    }

    // MARK: - Setup & Teardown
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests
    func testEquality() {
        let lInt: JSON = .int(45)
        let rIntGood: JSON = .int(45)
        let rIntBad: JSON = .int(100)

        XCTAssertEqual(lInt, rIntGood)
        XCTAssertNotEqual(lInt, rIntBad)
        
        let lDouble: JSON = .double(12.8)
        let rDoubleGood: JSON = .double(12.8)
        let rDoubleBad: JSON = .double(39.2)
        
        XCTAssertEqual(lDouble, rDoubleGood)
        XCTAssertNotEqual(lDouble, rDoubleBad)
        
        let lBool: JSON = .bool(true)
        let rBoolGood: JSON = .bool(true)
        let rBoolBad: JSON = .bool(false)
        
        XCTAssertEqual(lBool, rBoolGood)
        XCTAssertNotEqual(lBool, rBoolBad)
        
        let lString: JSON = .string("Hello, World!")
        let rStringGood: JSON = .string("Hello, World!")
        let rStringBad: JSON = .string("Goodnight, nobody.")
        
        XCTAssertEqual(lString, rStringGood)
        XCTAssertNotEqual(lString, rStringBad)
        
        let lOptional: JSON = .optional(nil)
        let rOptionalGood: JSON = .optional(nil)
        let rOptionalBad: JSON = .optional(.int(35))
        
        XCTAssertEqual(lOptional, rOptionalGood)
        XCTAssertNotEqual(lOptional, rOptionalBad)
        
        let lArray: JSON = .array([lInt, lDouble, lBool, lString])
        let rArrayGood: JSON = .array([rIntGood, rDoubleGood, rBoolGood, rStringGood])
        let rArrayBad: JSON = .array([rIntBad, rDoubleBad, rBoolBad, rStringBad])
        
        XCTAssertEqual(lArray, rArrayGood)
        XCTAssertNotEqual(lArray, rArrayBad)
        
        let lObject: JSON = .object(["int": lInt, "double": lDouble, "bool": lBool, "string": lString])
        let rObjectGood: JSON = .object(["int": rIntGood, "double": rDoubleGood, "bool": rBoolGood, "string": rStringGood])
        let rObjectBad: JSON = .object(["int": rIntBad, "double": rDoubleBad, "bool": rBoolBad, "string": rStringBad])
        
        XCTAssertEqual(lObject, rObjectGood)
        XCTAssertNotEqual(lObject, rObjectBad)
    }
    
    func testLiterals() {
        let json: JSON = .object([
            "someString": .string("Hello"),
            "someOptional": .optional(nil),
            "someInt": .int(257),
            "someDouble": .double(162.4),
            "someBool": true,
            "someArray": .array([
                .object([
                    "anotherString": .string("World"),
                    "anotherInt": .int(345)
                    ])
                ])
            ])
        
        let jsonViaLiterals: JSON = [
            "someString": "Hello",
            "someOptional": nil,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                [
                    "anotherString": "World",
                    "anotherInt": 345
                ]
            ]
        ]
        
        XCTAssertEqual(json, jsonViaLiterals)
    }
    
    func testEncode() {
        let json: JSON = [
            "someString": "Hello",
            "someOptional": nil,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                [
                    "anotherString": "World",
                    "anotherInt": 345
                ]
            ]
        ]
        
        let encodedPerson = try? JSONEncoder().encode(json)
        
        XCTAssertNotNil(encodedPerson)
    }
    
    func testDecode() {
        let jsonString = """
        {
            "someString": "Hello",
            "someOptional": null,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                {
                    "anotherString": "World",
                    "anotherInt": 345
                }
            ]
        }
        """
        
        let data = jsonString.data(using: .utf8)
        
        XCTAssertNotNil(data)
        
        let decodedJson = try? JSONDecoder().decode(JSON.self, from: data!)
        
        XCTAssertNotNil(decodedJson)
        
        let json: JSON = [
            "someString": "Hello",
            "someOptional": nil,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                [
                    "anotherString": "World",
                    "anotherInt": 345
                ]
            ]
        ]
        
        XCTAssertEqual(decodedJson!, json)
    }
    
    func testSubscripts() {
        let json: JSON = [
            "someString": "Hello",
            "someOptional": nil,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                [
                    "anotherString": "World",
                    "anotherInt": 345
                ]
            ]
        ]
        
        let wrapped: JSON = ["item": json]
        
        let itemFromDynamicLookup = wrapped.item?.someArray?[0]?.anotherString
        let itemFromSubscript = wrapped["item"]?["someArray"]?[0]?["anotherString"]
        
        XCTAssertNotNil(itemFromDynamicLookup)
        XCTAssertNotNil(itemFromSubscript)
        XCTAssertEqual(itemFromDynamicLookup, .string("World"))
        XCTAssertEqual(itemFromSubscript, .string("World"))
        
        let invalidDynamic = wrapped.json?.nonExistentMember?.someString
        let invalidSubscript = wrapped["json"]?["nonExistentMember"]?["someString"]
        
        XCTAssertNil(invalidDynamic)
        XCTAssertNil(invalidSubscript)
    }
    
    func testCodableConversions() {
        let objectJson: JSON = [
            "someString": "Hello",
            "someOptional": nil,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                [
                    "anotherString": "World",
                    "anotherInt": 345
                ]
            ]
        ]
        
        let object = SomeObject(
            someString: "Hello",
            someOptional: nil,
            someInt: 257,
            someDouble: 162.4,
            someBool: true,
            someArray: [
                SubObject(anotherString: "World", anotherInt: 345)
            ]
        )
        
        let jsonConverted = SomeObject(from: objectJson)
        let objectConverted = JSON(from: object)
        
        XCTAssertNotNil(jsonConverted)
        XCTAssertNotNil(objectConverted)
        
        XCTAssertEqual(jsonConverted!, object)
        
        // We can't really test the JSON to JSON equality because swift's
        // default encode implementation ignores nil values, so our
        // object -> JSON conversion will be missing "someOptional".
    }
    
    func testGetValue() {
        let json: JSON = [
            "someString": "Hello",
            "someOptional": nil,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                [
                    "anotherString": "World",
                    "anotherInt": 345
                ]
            ]
        ]
        
        let string: String? = json.someString?.getValue()
        let optional: JSON?? = json.someOptional?.getValue()
        let int: Int? = json.someInt?.getValue()
        let double: Double? = json.someDouble?.getValue()
        let bool: Bool? = json.someBool?.getValue()
        let array: [JSON]? = json.someArray?.getValue()
        
        XCTAssertNotNil(string)
        XCTAssertNotNil(optional)
        XCTAssertNotNil(int)
        XCTAssertNotNil(double)
        XCTAssertNotNil(bool)
        XCTAssertNotNil(array)
        
        XCTAssertEqual(string!, "Hello")
        XCTAssertEqual(optional!, nil)
        XCTAssertEqual(int!, 257)
        XCTAssertEqual(double!, 162.4)
        XCTAssertEqual(bool!, true)
        XCTAssertEqual(array!, [.object(["anotherString": "World", "anotherInt": 345])])
    }
    
    func testToString() {
        let json: JSON = [
            "someString": "Hello",
            "someOptional": nil,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                [
                    "anotherString": "World",
                    "anotherInt": 345
                ]
            ]
        ]
        
        let string = json.string
        let data = string.data(using: .utf8)
        
        XCTAssertNotNil(data)
        
        let decoded = try? JSONDecoder().decode(JSON.self, from: data!)
        
        XCTAssertNotNil(decoded)
        XCTAssertEqual(json, decoded!)
    }
    
    func testDataConversions() {
        let goodData = """
        {
            "someString": "Hello",
            "someOptional": null,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                {
                    "anotherString": "World",
                    "anotherInt": 345
                }
            ]
        }
        """.data(using: .utf8)
        
        let badData = "asdfasdfasdfadsfad".data(using: .utf8)
        
        XCTAssertNotNil(goodData!)
        XCTAssertNotNil(badData!)
        
        let goodConversion = goodData!.toJSON()
        let badConversion = badData!.toJSON()
        
        XCTAssertNotNil(goodConversion)
        XCTAssertNil(badConversion)
        
        let dataFromJSON = goodConversion!.data
        
        XCTAssertFalse(dataFromJSON.isEmpty)
    }

    // MARK: - Performance Tests
    func testManualStringGeneration() {
        let json: JSON = [
            "someString": "Hello",
            "someOptional": nil,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                [
                    "anotherString": "World",
                    "anotherInt": 345
                ]
            ]
        ]
        
        self.measure {
            let string = json.string
        }
    }
    
    func testStringGenerationFromData() {
        
        // I want to test whether manually generating the JSON string
        // is faster than simply encoding the JSON and reading that
        // data as a string.
        //
        // Turns out both are quite fast, but manual generation is slightly
        // faster and has the benefit of returning a String rather than an
        // optional String.
        
        let json: JSON = [
            "someString": "Hello",
            "someOptional": nil,
            "someInt": 257,
            "someDouble": 162.4,
            "someBool": true,
            "someArray": [
                [
                    "anotherString": "World",
                    "anotherInt": 345
                ]
            ]
        ]
        
        self.measure {
            let string = String(data: json.data, encoding: .utf8)
        }
    }

}
