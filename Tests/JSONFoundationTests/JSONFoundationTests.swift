import XCTest
@testable import JSONFoundation

final class JSONFoundationTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(JSONFoundation().text, "Hello, World!")
        let a = ["asdfasdf", 321] as [Any]
        
//        let b = try a.eraseToJSONValue()
        print(try true.eraseToJSONValue())
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
