import XCTest
@testable import JSONFoundation

final class JSONFoundationTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(JSONFoundation().text, "Hello, World!")
//        let a = ["asdfasdf", 321] as [Any]
//        XCTAssert(JSONSerialization.isValidJSONObject(true))
//        XCTAssert(JSONSerialization.isValidJSONObject(false))
//        XCTAssert(JSONSerialization.isValidJSONObject(NSNull()))
//        XCTAssert(JSONSerialization.isValidJSONObject("a"))
//        XCTAssert(JSONSerialization.isValidJSONObject(1))
//        XCTAssert(JSONSerialization.isValidJSONObject(2.3 as NSNumber))
//        XCTAssert(JSONSerialization.isValidJSONObject(["3"]))
//        XCTAssert(JSONSerialization.isValidJSONObject(["asdf": 3]))
        XCTAssertNoThrow(try JSONSerialization.data(withJSONObject: 2.3, options: .fragmentsAllowed))
        
//        let b = try a.eraseToJSONValue()
//        print(try true.eraseToJSONValue())
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
