import XCTest
@testable import TranslationRepository

final class TranslationRepositoryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TranslationRepository().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
