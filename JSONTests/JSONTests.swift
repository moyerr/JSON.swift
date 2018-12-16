//
//  JSONTests.swift
//  JSONTests
//
//  Created by Robbie Moyer on 12/13/18.
//  Copyright © 2018 RoJoMo Studios. All rights reserved.
//

import XCTest
@testable import JSON

class JSONTests: XCTestCase {
    
    // MARK: - Internal types
    private struct Pet: Codable, Equatable {
        let animal: String
        let name: String
    }
    
    private struct Person: Codable, Equatable {
        let firstName: String
        let middleName: String?
        let lastName: String
        let age: Int
        let weight: Double
        let employed: Bool
        let pets: [Pet]
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
        let person: JSON = .object([
            "firstName": .string("Robbie"),
            "middleName": .optional(nil),
            "lastName": .string("Moyer"),
            "age": .int(29),
            "weight": .double(162.4),
            "employed": true,
            "pets": .array([
                .object([
                    "animal": .string("Rabbit"),
                    "name": .string("Benjamin")
                    ])
                ])
            ])
        
        let literalPerson: JSON = [
            "firstName": "Robbie",
            "middleName": nil,
            "lastName": "Moyer",
            "age": 29,
            "weight": 162.4,
            "employed": true,
            "pets": [
                [
                    "animal": "Rabbit",
                    "name": "Benjamin"
                ]
            ]
        ]
        
        XCTAssertEqual(person, literalPerson)
    }
    
    func testEncode() {
        let person: JSON = [
            "firstName": "Robbie",
            "middleName": nil,
            "lastName": "Moyer",
            "age": 29,
            "weight": 162.4,
            "employed": true,
            "pets": [
                [
                    "animal": "Rabbit",
                    "name": "Benjamin"
                ]
            ]
        ]
        
        let encodedPerson = try? JSONEncoder().encode(person)
        
        XCTAssertNotNil(encodedPerson)
    }
    
    func testDecode() {
        let person = """
        {
            "age" : 29,
            "weight": 162.4,
            "firstName" : "Robbie",
            "lastName" : "Moyer",
            "middleName": null,
            "employed" : true,
            "pets" : [
                {
                    "name" : "Benjamin",
                    "animal" : "Rabbit"
                }
            ]
        }
        """
        
        let data = person.data(using: .utf8)
        
        XCTAssertNotNil(data)
        
        let decodedPerson = try? JSONDecoder().decode(JSON.self, from: data!)
        
        XCTAssertNotNil(decodedPerson)
        
        let otherPerson: JSON = [
            "firstName": "Robbie",
            "middleName": nil,
            "lastName": "Moyer",
            "age": 29,
            "weight": 162.4,
            "employed": true,
            "pets": [
                [
                    "animal": "Rabbit",
                    "name": "Benjamin"
                ]
            ]
        ]
        
        XCTAssertEqual(decodedPerson!, otherPerson)
    }
    
    func testSubscripts() {
        let person: JSON = [
            "firstName": "Robbie",
            "middleName": nil,
            "lastName": "Moyer",
            "age": 29,
            "weight": 162.4,
            "employed": true,
            "pets": [
                [
                    "animal": "Rabbit",
                    "name": "Benjamin"
                ]
            ]
        ]
        
        let wrapped: JSON = ["person": person]
        
        let bennyDynamic = wrapped.person?.pets?[0]?.name
        let bennySubscript = wrapped["person"]?["pets"]?[0]?["name"]
        
        XCTAssertNotNil(bennyDynamic)
        XCTAssertNotNil(bennySubscript)
        XCTAssertEqual(bennyDynamic, .string("Benjamin"))
        XCTAssertEqual(bennySubscript, .string("Benjamin"))
        
        let invalidDynamic = wrapped.person?.address?.city
        let invalidSubscript = wrapped["person"]?["address"]?["city"]
        
        XCTAssertNil(invalidDynamic)
        XCTAssertNil(invalidSubscript)
    }
    
    func testCodableConversions() {
        let personJSON: JSON = [
            "firstName": "Robbie",
            "middleName": nil,
            "lastName": "Moyer",
            "age": 29,
            "weight": 162.4,
            "employed": true,
            "pets": [
                [
                    "animal": "Rabbit",
                    "name": "Benjamin"
                ]
            ]
        ]
        
        let personObject = Person(
            firstName: "Robbie",
            middleName: nil,
            lastName: "Moyer",
            age: 29,
            weight: 162.4,
            employed: true,
            pets: [
                Pet(animal: "Rabbit", name: "Benjamin")
            ]
        )
        
        let jsonConverted = Person(from: personJSON)
        let objectConverted = JSON(from: personObject)
        
        XCTAssertNotNil(jsonConverted)
        XCTAssertNotNil(objectConverted)
        
        XCTAssertEqual(jsonConverted!, personObject)
        
        // We can't really test the JSON to JSON equality because swift's
        // default encode implementation ignores nil values, so our
        // object -> JSON conversion will be missing "middleName".
    }
    
    func testGetValue() {
        let person: JSON = [
            "firstName": "Robbie",
            "middleName": nil,
            "lastName": "Moyer",
            "age": 29,
            "weight": 162.4,
            "employed": true,
            "pets": [
                [
                    "animal": "Rabbit",
                    "name": "Benjamin"
                ]
            ]
        ]
        
        let firstName: String? = person.firstName?.getValue()
        let middleName: JSON?? = person.middleName?.getValue()
        let age: Int? = person.age?.getValue()
        let weight: Double? = person.weight?.getValue()
        let employed: Bool? = person.employed?.getValue()
        let pets: [JSON]? = person.pets?.getValue()
        let benny: [String: JSON]? = person.pets?[0]?.getValue()
        
        XCTAssertNotNil(firstName)
        XCTAssertNotNil(middleName)
        XCTAssertNotNil(age)
        XCTAssertNotNil(weight)
        XCTAssertNotNil(employed)
        XCTAssertNotNil(pets)
        XCTAssertNotNil(benny)
        
        XCTAssertEqual(firstName!, "Robbie")
        XCTAssertEqual(middleName!, nil)
        XCTAssertEqual(age!, 29)
        XCTAssertEqual(weight!, 162.4)
        XCTAssertEqual(employed!, true)
        XCTAssertEqual(pets!, [.object(["animal": "Rabbit", "name": "Benjamin"])])
        XCTAssertEqual(benny!, ["animal": "Rabbit", "name": "Benjamin"])
    }
    
    func testToString() {
        let person: JSON = [
            "firstName": "Robbie",
            "middleName": nil,
            "lastName": "Moyer",
            "age": 29,
            "weight": 162.4,
            "employed": true,
            "pets": [
                [
                    "animal": "Rabbit",
                    "name": "Benjamin"
                ]
            ]
        ]
        
        let string = person.string
        let data = string.data(using: .utf8)
        
        XCTAssertNotNil(data)
        
        let decoded = try? JSONDecoder().decode(JSON.self, from: data!)
        
        XCTAssertNotNil(decoded)
        XCTAssertEqual(person, decoded!)
    }
    
    func testDataConversions() {
        let goodData = """
        {
            "item": {
                "user": {
                    "email": "robbie@ad60.com",
                    "password": "Testing123?"
                }
            },
            "metaData": {
                "someData": "Hello",
                "someBool": true,
                "someInt": 23
            }
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
        let person: JSON = [
            "firstName": "Robbie",
            "middleName": nil,
            "lastName": "Moyer",
            "age": 29,
            "weight": 162.4,
            "employed": true,
            "pets": [
                [
                    "animal": "Rabbit",
                    "name": "Benjamin"
                ]
            ]
        ]
        
        self.measure {
            let string = person.string
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
        
        let person: JSON = [
            "firstName": "Robbie",
            "middleName": nil,
            "lastName": "Moyer",
            "age": 29,
            "weight": 162.4,
            "employed": true,
            "pets": [
                [
                    "animal": "Rabbit",
                    "name": "Benjamin"
                ]
            ]
        ]
        
        self.measure {
            let string = String(data: person.data, encoding: .utf8)
        }
    }

}
