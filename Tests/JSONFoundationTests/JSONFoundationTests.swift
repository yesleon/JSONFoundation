import XCTest
@testable import JSONFoundation

final class JSONFoundationTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(JSONFoundation().text, "Hello, World!")
        
        var value: JSONValue = .null
        value = ["asdf": 123]
        value = nil
        
        let string = try value.stringified(options: [.fragmentsAllowed, .prettyPrinted, .withoutEscapingSlashes])
        let b = try JSONValue.parse(string, options: .fragmentsAllowed)
        print(string)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
