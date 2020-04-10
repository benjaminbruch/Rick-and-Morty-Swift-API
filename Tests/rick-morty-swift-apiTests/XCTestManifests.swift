import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(rick_morty_swift_apiTests.allTests),
    ]
}
#endif
