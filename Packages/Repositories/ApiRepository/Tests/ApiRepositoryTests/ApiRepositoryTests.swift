import XCTest
@testable import ApiRepository

final class ApiRepositoryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ApiRepository().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
