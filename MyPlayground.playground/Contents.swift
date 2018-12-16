import JSON
import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let email: String
}

let response = """
{
    "items": {
        "user": {
            "id": 3829237,
            "email": "somebody@website.com",
            "username": "test_user"
        }
    },
    "otherData": {
        "someString": "Hello",
        "someBool": true,
        "someInt": 23
    }
}
""".data(using: .utf8)!

if let json = response.toJSON() {
    let users = json.compactMap { subJson -> User? in
        // Only attempt the conversion if we're looking at an object
        guard case .object(_) = subJson else { return nil }
        return User(from: subJson)
    }
    
    if let user = users.first {
        print(user)
    }
}
